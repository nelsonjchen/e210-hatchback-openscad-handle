OPENSCAD ?= openscad

SCAD := e210_hatchback_trunk_floor_handle.scad
MODEL := e210_hatchback_trunk_floor_handle
AGENTS_DIR := agents

STL := $(MODEL).stl
PREVIEW_PNG := $(AGENTS_DIR)/$(MODEL)_preview.png
TOP_PNG := $(AGENTS_DIR)/$(MODEL)_top.png
SIDE_PNG := $(AGENTS_DIR)/$(MODEL)_side.png

IMG_SIZE ?= 1400,1000
PREVIEW_CAMERA ?= 26.8,17.0,21.8,58,0,38,115
TOP_CAMERA ?= 26.8,17.0,21.8,0,0,0,115
SIDE_CAMERA ?= 26.8,17.0,21.8,90,0,0,115

.PHONY: all stl png preview top side clean help

all: stl png

stl: $(STL)

png: preview top side

preview: $(PREVIEW_PNG)

top: $(TOP_PNG)

side: $(SIDE_PNG)

$(STL): $(SCAD)
	$(OPENSCAD) -o $@ $<

$(AGENTS_DIR):
	mkdir -p $@

$(PREVIEW_PNG): $(SCAD) | $(AGENTS_DIR)
	$(OPENSCAD) -o $@ --imgsize=$(IMG_SIZE) --camera=$(PREVIEW_CAMERA) $<

$(TOP_PNG): $(SCAD) | $(AGENTS_DIR)
	$(OPENSCAD) -o $@ --imgsize=$(IMG_SIZE) --camera=$(TOP_CAMERA) $<

$(SIDE_PNG): $(SCAD) | $(AGENTS_DIR)
	$(OPENSCAD) -o $@ --imgsize=$(IMG_SIZE) --camera=$(SIDE_CAMERA) $<

clean:
	rm -f $(STL) $(PREVIEW_PNG) $(TOP_PNG) $(SIDE_PNG)

help:
	@printf '%s\n' \
		'Targets:' \
		'  make stl      Build the ignored STL artifact' \
		'  make png      Build preview/top/side PNG renders in agents/' \
		'  make all      Build STL and PNG renders' \
		'  make clean    Remove generated artifacts' \
		'' \
		'Overrides:' \
		'  make png IMG_SIZE=2000,1400' \
		'  make preview PREVIEW_CAMERA=x,y,z,rx,ry,rz,dist'
