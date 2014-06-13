default: build

SRCDIR = src
LIBDIR = lib

SRC = $(shell find "$(SRCDIR)" -name "*.coffee" -type f | sort)
LIB = $(SRC:$(SRCDIR)/%.coffee=$(LIBDIR)/%.js)

build: $(LIB)
