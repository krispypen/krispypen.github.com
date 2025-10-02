# Makefile for building the Flutter web application with WASM

# The .PHONY directive tells make that 'build' is a phony target,
# meaning it's a command to be executed and not a file to be created.
.PHONY: build

# The default target that will be run if you just type 'make'.
# It depends on the 'build' target.
all: build

# The 'build' target executes the fvm flutter build command.
build:
	@echo "Building Flutter web application with WASM..."
	fvm flutter build web --wasm
	@echo "Build complete."
