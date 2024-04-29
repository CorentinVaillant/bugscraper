LIBNAME=libmidi_input_handler

TARGET_OS := $(shell uname)
ifeq ($(TARGET),)
    TARGET := $(TARGET_OS)
endif

ifeq ($(TARGET),Linux)
    EXT := so
	TARGET_BUILD := x86_64-unknown-linux-gnu
else ifeq ($(TARGET),Darwin)
    EXT := dylib
else ifeq ($(TARGET),Windows_NT)
    EXT := dll
	TARGET_BUILD := x86_64-pc-windows-gnu
else
    $(error Unsupported target OS: $(TARGET))
endif



debug:
	@echo "building for $(TARGET_OS)"
	cargo build 
	@if [ -f "$(LIBNAME).$(EXT)" ]; then rm "$(LIBNAME).$(EXT)"; fi
	cp ./target/debug/$(LIBNAME).$(EXT) ./ -i 

release:
	@echo "building for $(shell uname)"
	cargo build --release
	@if [ -f "$(LIBNAME).$(EXT)" ]; then rm "$(LIBNAME).$(EXT)"; fi
	mv ./target/release/$(LIBNAME).$(EXT) ./ -i 


run :
	make debug
	lua ./main.lua

clean :
	cargo clean
	@rm ./libmidi_input_handler.so