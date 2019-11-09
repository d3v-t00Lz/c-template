#!/usr/bin/make -f

EXE ?= hello

CC ?= gcc
CC_ARGS ?= -Wall -fPIC
OPT_LVL ?= -O2

GCOVARGS ?= -fprofile-arcs -ftest-coverage  # -fPIC
BROWSER ?= firefox-wayland

DESTDIR ?=
BINDIR ?= /usr/bin
INCLUDEDIR ?= /usr/include

all:
	$(CC) \
	    $(CC_ARGS) $(OPT_LVL) \
	    $(shell find src cli -name *.c) -Iinclude -o $(EXE)

clean:
	rm -rf $(EXE)* html/* *.gcda *.gcno

debug:
	$(CC) \
	    $(CC_ARGS) -O0 -g \
	    $(shell find src cli -name *.c) -Iinclude -o $(EXE)

install:
	install -d $(DESTDIR)/$(BINDIR)
	install $(EXE) $(DESTDIR)/$(BINDIR)/

install-devel:
	install -d $(DESTDIR)
	cp -r include $(DESTDIR)

test:
	$(CC) $(CC_ARGS) -O0 -g $(GCOVARGS) \
	    $(shell find src tests -name *.c) \
	    -Iinclude \
	    -o $(EXE).tests
	valgrind ./$(EXE).tests
	mkdir html || rm -rf html/*
	gcovr -r . --html --html-details \
	    -o html/coverage.html
	$(BROWSER) html/coverage.html &
