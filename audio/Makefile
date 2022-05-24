BLIP_FILES = $(wildcard *.blip) $(wildcard effects/*.blip)

%.ogg: %.blip
	bliplay -o $@.wav $<
	ffmpeg -i $@.wav -q 15 $@
	unlink $@.wav

.PHONY:
all: $(BLIP_FILES:.blip=.ogg)
