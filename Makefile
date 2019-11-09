#!/usr/bin/make -f

NAME ?= ctemplate

CC ?= gcc
CC_ARGS ?= -Wall -fPIC
OPT_LVL ?= -O2
# These assume a modern x86 CPU, change or remove for other platforms
PLAT_FLAGS ?= -mfpmath=sse -mssse3

ARCH ?= $(shell uname --machine)

GCOVARGS ?= -fprofile-arcs -ftest-coverage  # -fPIC
BROWSER ?= firefox-wayland

DESTDIR ?=
BINDIR ?= /usr/bin
INCLUDEDIR ?= /usr/include

all:
	$(CC) \
	    $(CC_ARGS) $(OPT_LVL) $(PLAT_FLAGS) \
	    $(shell find src cli -name *.c) -Iinclude -o $(NAME)

clean:
	rm -rf $(NAME) $(NAME).tests html/* *.gcda *.gcno *.rpm

debug:
	$(CC) \
	    $(CC_ARGS) -O0 -g $(PLAT_FLAGS) \
	    $(shell find src cli -name *.c) -Iinclude -o $(NAME)

install:
	install -d $(DESTDIR)/$(BINDIR)
	install $(NAME) $(DESTDIR)/$(BINDIR)/

install-devel:
	install -d $(DESTDIR)
	cp -r include $(DESTDIR)

perf:
	$(CC) $(CC_ARGS) $(OPT_LVL) $(PLAT_FLAGS) $(GCOVARGS) \
	    $(shell find src tests -name *.c) \
	    -Iinclude \
	    -o $(NAME).perf
	perf stat -e cache-references,cache-misses,dTLB-loads,\
	dTLB-load-misses,iTLB-loads,iTLB-load-misses,L1-dcache-loads,\
	L1-dcache-load-misses,L1-icache-loads,L1-icache-load-misses,\
	branch-misses,LLC-loads,LLC-load-misses ./$(NAME).perf

rpm:
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
	$(CC) $(CC_ARGS) -O0 -g $(PLAT_FLAGS) $(GCOVARGS) \
	    $(shell find src tests -name *.c) \
	    -Iinclude \
	    -o $(NAME).tests
	valgrind ./$(NAME).tests --track-origins=yes
	mkdir html || rm -rf html/*
	gcovr -r . --html --html-details \
	    -o html/coverage.html
	$(BROWSER) html/coverage.html &
