#!/usr/bin/make -f

NAME ?= ctemplate

CC ?= gcc
CC_ARGS ?= -Wall -fPIC
OPT_LVL ?= -O2
# These assume a modern x86 CPU, change or remove for other platforms
PLAT_FLAGS ?= -mfpmath=sse -mssse3

# Only used with the 'debug' target.  -g used for tools other than gdb.
DEBUG_FLAGS ?= -ggdb3
DEBUGGER ?= gdb

ARCH ?= $(shell uname --machine)

GCOVARGS ?= -fprofile-arcs -ftest-coverage  # -fPIC
BROWSER ?= firefox-wayland

DESTDIR ?=
BINDIR ?= /usr/bin
INCLUDEDIR ?= /usr/include

all:
	# Compile the binary
	$(CC) \
	    $(CC_ARGS) $(OPT_LVL) $(PLAT_FLAGS) \
	    $(shell find src cli -name *.c) -Iinclude -o $(NAME)

clean:
	# Remove all temporary files
	rm -rf $(NAME) \
	    $(NAME).{debug,gprof,pahole,perf,tests} \
	    html/* *.gcda *.gcno *.rpm gmon.out pahole.txt profile.txt

debug:
	# Compile the binary with the appropriate flags to debug in GDB
	$(CC) \
	    $(CC_ARGS) -O0 $(DEBUG_FLAGS) $(PLAT_FLAGS) \
	    $(shell find src cli -name *.c) -Iinclude -o $(NAME).debug
	$(DEBUGGER) ./$(NAME).debug

gprof:
	# Profile which functions the test suite spends the most time
	# in using gprof
	$(CC) $(CC_ARGS) $(OPT_LVL) -pg $(PLAT_FLAGS) \
	    $(shell find src tests -name *.c) \
	    -Iinclude \
	    -o $(NAME).gprof
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

pahole:
	# Check struct alignnment using pahole
	$(CC) $(CC_ARGS) -O0 -g $(PLAT_FLAGS) \
	    $(shell find src tests -name *.c) \
	    -Iinclude \
	    -o $(NAME).pahole
	pahole $(NAME).pahole > pahole.txt
	less pahole.txt

perf:
	# Profile system performance counters using perf
	$(CC) $(CC_ARGS) $(OPT_LVL) $(PLAT_FLAGS) \
	    $(shell find src tests -name *.c) \
	    -Iinclude \
	    -o $(NAME).perf
	perf stat -e cache-references,cache-misses,dTLB-loads,\
	dTLB-load-misses,iTLB-loads,iTLB-load-misses,L1-dcache-loads,\
	L1-dcache-load-misses,L1-icache-loads,L1-icache-load-misses,\
	branch-misses,LLC-loads,LLC-load-misses ./$(NAME).perf

rpm:
	# Generate an RPM package
	$(eval version := $(shell jq .version meta.json))
	rpmdev-setuptree
	rm -rf ~/rpmbuild/BUILD/$(NAME)*
	rm -rf ~/rpmbuild/RPMS/$(NAME)*
	cp -r . ~/rpmbuild/BUILD/$(NAME)-$(version)
	tar czf ~/rpmbuild/SOURCES/$(NAME)-$(version).tar.gz .
	rpmbuild -v -ba $(NAME).spec \
		-D "version $(version)" \
		-D "name $(NAME)"
	cp ~/rpmbuild/RPMS/$(ARCH)/$(NAME)-$(version)-1.$(ARCH).rpm .

test:
	# Compile and run the test suite through Valgrind to check for
	# memory errors, then generate an HTML code coverage report
	# using gcovr
	$(CC) $(CC_ARGS) -O0 -g $(PLAT_FLAGS) $(GCOVARGS) \
	    $(shell find src tests -name *.c) \
	    -Iinclude \
	    -o $(NAME).tests
	# If Valgrind exits non-zero, try running 'gdb ./ctemplate.tests'
	# to debug the test suite
	valgrind ./$(NAME).tests --track-origins=yes
	mkdir html || rm -rf html/*
	gcovr -r . --html --html-details -o html/coverage.html
	$(BROWSER) html/coverage.html &
