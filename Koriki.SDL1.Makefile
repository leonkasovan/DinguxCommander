# Makefile for building C source code

# Compiler and flags
# CC = gcc
RES_DIR := /userdata/system/App/Commander_Italic/res/
CXXFLAGS += -Os -marm -march=armv7-a -mtune=cortex-a9 -mfpu=neon-fp16 -mfloat-abi=hard
CXXFLAGS += -DUSE_SDL
CXXFLAGS += -DKORIKI
CXXFLAGS += `pkg-config sdl --cflags --libs` -lSDL_image -lSDL_ttf -lfreetype
CXXFLAGS += -DPATH_DEFAULT=\"/mnt\"
CXXFLAGS += -DFILE_SYSTEM=\"/dev/mmcblk1p1\"
CXXFLAGS += -DOSK_KEY_SYSTEM_IS_BACKSPACE=ON
CXXFLAGS += -DPPU_X=1.666666
CXXFLAGS += -DPPU_Y=1.666666
CXXFLAGS += -DAUTOSCALE=0
CXXFLAGS += -DRES_DIR="\"$(RES_DIR)\""

# Directories
SRC_DIR = src
OUTPUT_DIR = output

# Source files and output files
SRC_FILES = src/main.cpp src/commander.cpp src/config.cpp src/dialog.cpp src/fileLister.cpp src/fileutils.cpp src/keyboard.cpp src/panel.cpp src/resourceManager.cpp src/screen.cpp src/sdl_ttf_multifont.cpp src/sdlutils.cpp src/text_edit.cpp src/utf8.cpp src/text_viewer.cpp src/image_viewer.cpp  src/controller_buttons.cpp src/window.cpp src/SDL_rotozoom.c 
OBJ_FILES = $(patsubst $(SRC_DIR)/%.cpp, $(OUTPUT_DIR)/%.o, $(SRC_FILES))
EXECUTABLE = $(OUTPUT_DIR)/DinguxCommander_SDL1

# Default target
all: $(EXECUTABLE)

# Rule to build object files from source files
$(OUTPUT_DIR)/%.o: $(SRC_DIR)/%.cpp
	@mkdir -p $(OUTPUT_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Rule to build the executable
$(EXECUTABLE): $(OBJ_FILES)
	$(CXX) -o $@ $^ $(CXXFLAGS) 

# Clean target to remove generated files
clean:
	rm -rf $(OUTPUT_DIR)

# Phony target to avoid conflicts with files named clean
.PHONY: clean
