#!/usr/bin/make -f

NAME ?= ctemplate

# Compiler flags
CC ?= gcc
CC_ARGS ?= -Wall -fPIC
OPT_LVL ?= -O2
LINK_FLAGS ?=
# These assume a modern x86 CPU, change or remove for other platforms
PLAT_FLAGS ?= -mfpmath=sse -mssse3

# Debugging flags
# Use -g used for tools other than gdb.
DEBUG_FLAGS ?= -ggdb3
DEBUGGER ?= gdb

# Coverage report flags
GCOVARGS ?= -fprofile-arcs -ftest-coverage  # -fPIC
# Coverage reports will open in this browser
BROWSER ?= firefox

# Install and packaging flags
DESTDIR ?=
BINDIR ?= /usr/bin
INCLUDEDIR ?= /usr/include
ARCH ?= $(shell uname --machine)

# `make perf` counters
PERF_COUNTERS ?= "cache-references,cache-misses,dTLB-loads,\
dTLB-load-misses,iTLB-loads,iTLB-load-misses,L1-dcache-loads,\
L1-dcache-load-misses,L1-icache-loads,L1-icache-load-misses,\
branch-misses,LLC-loads,LLC-load-misses"

# Benchmark flags
# Tells benchmarks that use the ITERATIONS macro how many iterations to attempt
BENCH_ITERATIONS ?= 100000000UL
# Tells the benchmarks to try not using more than this amount of memory.  It
# is not guaranteed that this number will not be exceeded
BENCH_SIZE_MB ?= 500UL


all:
	# Compile the binary
	$(CC) \
	    $(CC_ARGS) $(OPT_LVL) $(PLAT_FLAGS) \
	    $(shell find src cli -name *.c) -Iinclude $(LINK_FLAGS) -o $(NAME)

bench:
	# Run the benchmark, output the results as YAML to stderr
	$(CC) \
	    $(CC_ARGS) $(OPT_LVL) $(PLAT_FLAGS) \
	    $(shell find src benchmark -name *.c) -Iinclude \
	    -DITERATIONS=$(BENCH_ITERATIONS) \
	    -DBENCH_SIZE_MB=$(BENCH_SIZE_MB) \
	    $(LINK_FLAGS) -o $(NAME).benchmark
	./$(NAME).benchmark

bench-test:
	# Run the benchmark through valgrind and gcov
	$(CC) \
	    $(CC_ARGS) -O0 $(DEBUG_FLAGS) $(PLAT_FLAGS) $(GCOVARGS) \
	    $(shell find src benchmark -name *.c) -Iinclude \
	    -DITERATIONS=100 -DBENCH_SIZE_MB=1 \
	    $(LINK_FLAGS) -o $(NAME).benchmark
	# If Valgrind exits non-zero, try running 'gdb ./ctemplate.tests'
	# to debug the test suite
	valgrind ./$(NAME).benchmark --track-origins=yes
	mkdir html || rm -rf html/*
	gcovr -r . --html --html-details \
		--exclude=tests \
		-o html/coverage.html
	$(BROWSER) html/coverage.html &
	# NOTE: You do not need to cover all lines, this is simply for
	# 	debugging purposes

clean:
	# Remove all temporary files
	rm -rf $(NAME) \
	    $(NAME).{benchmark,debug,gprof,pahole,perf,tests} \
	    html/* *.gcda *.gcno *.rpm gmon.out pahole.txt profile.txt \
	    bench.out

debug:
	# Compile the binary with the appropriate flags to debug in GDB
	$(CC) \
	    $(CC_ARGS) -O0 $(DEBUG_FLAGS) $(PLAT_FLAGS) \
	    $(shell find src cli -name *.c) -Iinclude $(LINK_FLAGS) \
	   	-o $(NAME).debug
	$(DEBUGGER) ./$(NAME).debug

gprof:
	# Profile which functions the test suite spends the most time
	# in using gprof
	$(CC) $(CC_ARGS) $(OPT_LVL) -pg $(PLAT_FLAGS) \
	    $(shell find src benchmark -name *.c) \
	    -Iinclude $(LINK_FLAGS) -o $(NAME).gprof
	./$(NAME).gprof
	gprof ./$(NAME).gprof > profile.txt
	less profile.txt

install:
	# Install the binary
	install -d $(DESTDIR)/$(BINDIR)
	install $(NAME) $(DESTDIR)/$(BINDIR)/

install-devel:
	# Install the headers
	install -d $(DESTDIR)
	cp -r include $(DESTDIR)

lines-of-code:
	# source code
	find src -name '*.c' -exec cat {} \; | wc -l
	# tests
	find tests -name '*.c' -exec cat {} \; | wc -l
	# headers
	find include -name '*.h' -exec cat {} \; | wc -l
	# benchmarks
	find benchmark -name '*.c' -exec cat {} \; | wc -l

pahole:
	# Check struct alignnment using pahole
	$(CC) $(CC_ARGS) -O0 $(DEBUG_FLAGS) $(PLAT_FLAGS) \
	    $(shell find src tests -name *.c) \
	    -Iinclude $(LINK_FLAGS) -o $(NAME).pahole
	pahole $(NAME).pahole > pahole.txt
	less pahole.txt

perf:
	# Profile system performance counters using perf
	$(CC) $(CC_ARGS) $(OPT_LVL) $(PLAT_FLAGS) \
	    $(shell find src benchmark -name *.c) \
	    -Iinclude $(LINK_FLAGS) -o $(NAME).perf
	perf stat -e $(PERF_COUNTERS) ./$(NAME).perf

rpm:
	# Generate an RPM package
	$(eval version := $(shell jq .version meta.json))
	$(eval release := $(shell jq .release meta.json))
	rpmdev-setuptree
	rm -rf ~/rpmbuild/BUILD/$(NAME)*
	rm -rf ~/rpmbuild/RPMS/$(NAME)*
	cp -r . ~/rpmbuild/BUILD/$(NAME)-$(version)
	tar czf ~/rpmbuild/SOURCES/$(NAME)-$(version).tar.gz .
	rpmbuild -v -ba $(NAME).spec \
		-D "version $(version)" \
		-D "release $(release)" \
		-D "name $(NAME)"
	cp ~/rpmbuild/RPMS/$(ARCH)/$(NAME)-$(version)-1.$(ARCH).rpm .

shared:
	# Compile the shared library
	$(CC) \
	    $(CC_ARGS) $(OPT_LVL) $(PLAT_FLAGS) -shared \
	    $(shell find src -name *.c) -Iinclude $(LINK_FLAGS) -o $(NAME).so

test:
	# Compile and run the test suite through Valgrind to check for
	# memory errors, then generate an HTML code coverage report
	# using gcovr
	$(CC) $(CC_ARGS) -O0 $(DEBUG_FLAGS) $(PLAT_FLAGS) $(GCOVARGS) \
	    $(shell find src tests -name *.c) \
	    -Iinclude $(LINK_FLAGS) -o $(NAME).tests
	# If Valgrind exits non-zero, try running 'gdb ./ctemplate.tests'
	# to debug the test suite
	valgrind ./$(NAME).tests --track-origins=yes
	mkdir html || rm -rf html/*
	gcovr -r . --html --html-details \
		--exclude=benchmark \
		-o html/coverage.html
	$(BROWSER) html/coverage.html &
