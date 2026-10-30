# Compiler
CC := gcc

# Compiler flags
CFLAGS := -Wall -Wextra -Wpedantic -std=c11

# Libraries
PKG_CONFIG := pkg-config
LIBS := libxml-2.0 libmicrohttpd

# Directories
SERVER_DIR := server
SCHEMA_DIR := schemas
EXAMPLES_DIR := examples

# Files
SERVER_SOURCE := $(SERVER_DIR)/server.c
SERVER_BINARY := $(SERVER_DIR)/server
SCHEMA_FILE := $(SCHEMA_DIR)/menu.xsd
EXAMPLE_XML := $(EXAMPLES_DIR)/menu.xml

# Compiler and linker flags from pkg-config
CPPFLAGS += $(shell $(PKG_CONFIG) --cflags $(LIBS))
LDLIBS += $(shell $(PKG_CONFIG) --libs $(LIBS))

# Default target
.PHONY: all
all: $(SERVER_BINARY)

# Build server
$(SERVER_BINARY): $(SERVER_SOURCE) $(SCHEMA_FILE)
	$(CC) $(CFLAGS) $(CPPFLAGS) $(SERVER_SOURCE) -o $@ $(LDLIBS)

# Run server
.PHONY: run
run: $(SERVER_BINARY)
	cd $(SERVER_DIR) && ./server

# Validate example XML against XSD
.PHONY: validate
validate:
	xmllint --noout --schema $(SCHEMA_FILE) $(EXAMPLE_XML)

# Clean generated binary
.PHONY: clean
clean:
	rm -f $(SERVER_BINARY)

# Display available targets
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  make          - Compile the server"
	@echo "  make run      - Compile and run the server"
	@echo "  make validate - Validate example XML against XSD"
	@echo "  make clean    - Remove the compiled server"
	@echo "  make help     - Show this help"