#!/usr/bin/make -f

EXE ?= hello

CC ?= gcc
CC_ARGS ?= -Wall
OPT_LVL ?= -O2
INCLUDE ?= -Iinclude
SRC ?= src/*.c src/*/*.c
OUTPUT ?= -o $(EXE)

GCOVARGS ?= -fprofile-arcs -ftest-coverage -fPIC
BROWSER ?= firefox-wayland

DESTDIR ?=
BINDIR ?= /usr/bin
INCLUDEDIR ?= /usr/include

all:
	$(CC) $(CC_ARGS) $(OPT_LVL) $(INCLUDE) $(SRC) $(OUTPUT)

clean:
	rm -f $(EXE) coverage*.html *.gcda *.gcno

debug:
	$(CC) $(CC_ARGS) -O0 -g $(INCLUDE) $(SRC) $(OUTPUT)

install:
	install -d $(DESTDIR)/$(BINDIR)
	install $(EXE) $(DESTDIR)/$(BINDIR)/

install-devel:
	install -d $(DESTDIR)
	cp -r include $(DESTDIR)

test:
	# TODO: Create a separate tests/ directory and compile that instead
	$(CC) $(CC_ARGS) -O0 -g $(GCOVARGS) $(INCLUDE) $(SRC) $(OUTPUT)
	valgrind ./$(EXE)
	gcovr -r . --html --html-details -o coverage.html
	$(BROWSER) *.html
