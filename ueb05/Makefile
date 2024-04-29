SIZE := 100
JPEG := $(wildcard *.jpg)
TGA := $(wildcard *.tga)
PPM := $(wildcard *.ppm)
RM := $(JPEG:%.jpg=%.ppm) $(TGA:%.tga=%.ppm)
PPM := $(filter-out $(RM), $(PPM))
PNGSTRING := $(JPEG:%.jpg=%.png) $(TGA:%.tga=%.png) $(PPM:%.ppm=%.png)
.PHONY: all tar clean png help 
.SILENT:
.SECONDARY:
all : tar
tar || png-files.tar.gz: $(PNGSTRING)
	tar -czf png-files.tar.gz $(PNGSTRING)
help :
	echo "Makefile to scale and convert jpg, tga and ppm files to png.\n"
	echo "VARIABLES"
	echo "  SIZE  - specifies the largest image size (default=100)\n"
	echo "TARGETS"
	echo "  all   - default target, does the same as tar target"
	echo "  tar   - create tar archive"
	echo "  png   - scale and convert all jpg and tga files to png"
	echo "  help  - display this help and exit"
	echo "  clean - remove all generated files"
%.ppm : %.jpg
	jpegtopnm -quiet $< > $*.ppm
%.ppm : %.tga
	tgatoppm  $< > $*.ppm
%.scaled : %.ppm
	pnmscale -xysize $(SIZE) $(SIZE) $< > $*.scaled
%.png : %.scaled 
	pnmtopng $< > $*.png
png : $(PNGSTRING)
clean : 
	rm -f $(RM)
	rm -f *.scaled
	rm -f $(PNGSTRING)
	rm -f png-files.tar.gz
