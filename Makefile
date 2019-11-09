#!/usr/bin/make -f

NAME ?= ctemplate

CC ?= gcc
CC_ARGS ?= -Wall -fPIC
OPT_LVL ?= -O2

ARCH ?= $(shell uname --machine)

GCOVARGS ?= -fprofile-arcs -ftest-coverage  # -fPIC
BROWSER ?= firefox-wayland

DESTDIR ?=
BINDIR ?= /usr/bin
INCLUDEDIR ?= /usr/include

all:
	$(CC) \
	    $(CC_ARGS) $(OPT_LVL) \
	    $(shell find src cli -name *.c) -Iinclude -o $(NAME)

clean:
	rm -rf $(NAME) $(NAME).tests html/* *.gcda *.gcno

debug:
	$(CC) \
	    $(CC_ARGS) -O0 -g \
	    $(shell find src cli -name *.c) -Iinclude -o $(NAME)

install:
	install -d $(DESTDIR)/$(BINDIR)
	install $(NAME) $(DESTDIR)/$(BINDIR)/

install-devel:
	install -d $(DESTDIR)
	cp -r include $(DESTDIR)

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
	$(CC) $(CC_ARGS) -O0 -g $(GCOVARGS) \
	    $(shell find src tests -name *.c) \
	    -Iinclude \
	    -o $(NAME).tests
	valgrind ./$(NAME).tests
	mkdir html || rm -rf html/*
	gcovr -r . --html --html-details \
	    -o html/coverage.html
	$(BROWSER) html/coverage.html &
