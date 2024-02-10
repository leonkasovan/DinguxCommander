#
#	DinguxCommander Makefile for RG353P Recalbox SDL 2.0
#

CXX := /home/ark/recalbox-rg353x/output/host/bin/aarch64-buildroot-linux-gnu-gcc
CXXFLAGS := -Os
SDL_CONFIG := $(shell $(CXX) -print-sysroot)/usr/bin/sdl2-config
CXXFLAGS += -DUSE_SDL2
CXXFLAGS += -DRECALBOX
CXXFLAGS += $(shell $(SDL_CONFIG) --cflags)
CXXFLAGS += -DPATH_DEFAULT=\"/recalbox/share/roms\"
CXXFLAGS += -DFILE_SYSTEM=\"/dev/mmcblk2p1\"
CXXFLAGS += -DOSK_KEY_SYSTEM_IS_BACKSPACE=ON
CXXFLAGS += -DSCREEN_WIDTH=640
CXXFLAGS += -DSCREEN_HEIGHT=480
CXXFLAGS += -DPPU_X=1.666666
CXXFLAGS += -DPPU_Y=1.666666
CXXFLAGS += -DAUTOSCALE=0
CXXFLAGS += -DSCREEN_BPP=16
RES_DIR := res
CXXFLAGS += -DRES_DIR="\"$(RES_DIR)\""

LINKFLAGS += -s
LINKFLAGS += $(shell $(SDL_CONFIG) --libs) -lSDL2_image -lSDL2_ttf -lSDL2_gfx -lm -lstdc++

CMD := @
SUM := @echo

OUTDIR := ./output

EXECUTABLE := $(OUTDIR)/DinguxCommander_SDL2

OBJS :=	main.o commander.o config.o dialog.o fileLister.o fileutils.o keyboard.o panel.o resourceManager.o \
	screen.o sdl_ttf_multifont.o sdlutils.o text_edit.o utf8.o text_viewer.o image_viewer.o  window.o controller_buttons.o axis_direction.o \

DEPFILES := $(patsubst %.o,$(OUTDIR)/%.d,$(OBJS))

.PHONY: all clean

all: $(EXECUTABLE)

$(EXECUTABLE): $(addprefix $(OUTDIR)/,$(OBJS))
	$(SUM) "  LINK    $@"
	$(CMD)$(CXX) $(LINKFLAGS) -o $@ $^

$(OUTDIR)/%.o: src/%.cpp
	@mkdir -p $(@D)
	$(SUM) "  CXX     $@"
	$(CMD)$(CXX) $(CXXFLAGS) -MP -MMD -MF $(@:%.o=%.d) -c $< -o $@
	@touch $@ # Force .o file to be newer than .d file.

$(OUTDIR)/%.o: src/%.c
	@mkdir -p $(@D)
	$(SUM) "  CXX     $@"
	$(CMD)$(CXX) $(CXXFLAGS) -MP -MMD -MF $(@:%.o=%.d) -c $< -o $@
	@touch $@ # Force .o file to be newer than .d file.

clean:
	$(SUM) "  RM      $(OUTDIR)"
	$(CMD)rm -rf $(OUTDIR)

# Load dependency files.
-include $(DEPFILES)

# Generate dependencies that do not exist yet.
# This is only in case some .d files have been deleted;
# in normal operation this rule is never triggered.
$(DEPFILES):
