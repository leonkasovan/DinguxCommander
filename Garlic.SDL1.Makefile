#
#	DinguxCommander Makefile for RG35xx garlic
#

CXX := /opt/miyoo/bin/arm-miyoo-linux-uclibcgnueabi-g++
CXXFLAGS := -Os -marm -mtune=cortex-a9 -mfpu=neon-fp16 -mfloat-abi=softfp -march=armv7-a
SDL_CONFIG := $(shell $(CXX) -print-sysroot)/usr/bin/sdl-config
CXXFLAGS += $(shell $(SDL_CONFIG) --cflags)

CXXFLAGS += -DPATH_DEFAULT=\"/mnt\"
CXXFLAGS += -DFILE_SYSTEM=\"/dev/block/mmcblk1\"
CXXFLAGS += -DGARLIC
CXXFLAGS += -DCMDR_KEY_UP=SDLK_w
CXXFLAGS += -DCMDR_KEY_RIGHT=SDLK_d
CXXFLAGS += -DCMDR_KEY_DOWN=SDLK_s
CXXFLAGS += -DCMDR_KEY_LEFT=SDLK_q
CXXFLAGS += -DCMDR_KEY_OPEN=SDLK_a		# A
CXXFLAGS += -DCMDR_KEY_PARENT=SDLK_b		# B
CXXFLAGS += -DCMDR_KEY_OPERATION=SDLK_x		# X
CXXFLAGS += -DCMDR_KEY_SYSTEM=SDLK_y		# Y
CXXFLAGS += -DCMDR_KEY_PAGEUP=SDLK_h		# L1 / L2 = SDLK_j
CXXFLAGS += -DCMDR_KEY_PAGEDOWN=SDLK_l		# R1 / R2 = SDLK_k
CXXFLAGS += -DCMDR_KEY_SELECT=SDLK_n		# SELECT
CXXFLAGS += -DCMDR_KEY_TRANSFER=SDLK_m		# START
CXXFLAGS += -DCMDR_KEY_MENU=SDLK_u		# MENU (added)
CXXFLAGS += -DOSK_KEY_SYSTEM_IS_BACKSPACE=ON
CXXFLAGS += -DSCREEN_WIDTH=640
CXXFLAGS += -DSCREEN_HEIGHT=480
CXXFLAGS += -DPPU_X=1.666666
CXXFLAGS += -DPPU_Y=1.666666
CXXFLAGS += -DAUTOSCALE=0
CXXFLAGS += -DSCREEN_BPP=16
CXXFLAGS += -DFONTS='{"FreeSans.ttf",18}'
#CXXFLAGS += -DFONTS='{"FreeSans.ttf",18},{"DroidSansFallback.ttf",15},{"/mnt/mmc/CFW/skin/font.ttf",14}'
#CXXFLAGS += -DLOW_DPI_FONTS='{"Fiery_Turk.ttf",8},{"/mnt/mmc/CFW/skin/font.ttf",9}'

RESDIR := res
CXXFLAGS += -DRESDIR="\"$(RESDIR)\""

LINKFLAGS += -s
LINKFLAGS += $(shell $(SDL_CONFIG) --libs) -lSDL_image -lSDL_ttf

CMD := @
SUM := @echo

OUTDIR := ./output

EXECUTABLE := $(OUTDIR)/DinguxCommander

OBJS :=	main.o commander.o config.o dialog.o fileLister.o fileutils.o keyboard.o panel.o resourceManager.o \
	screen.o sdl_ttf_multifont.o sdlutils.o text_edit.o utf8.o text_viewer.o image_viewer.o  window.o \
	SDL_rotozoom.o

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
