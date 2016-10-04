IMGNAME=posh.img
BINDIR=$(CURDIR)/bin
SRCDIR=$(CURDIR)/src
LIBDIR=$(CURDIR)/lib

all: img

img:
	nasm -f bin -I $(LIBDIR)/ -o $(BINDIR)/bootloader.bin $(SRCDIR)/bootloader.asm
	nasm -f bin -I $(LIBDIR)/ -o $(BINDIR)/kernel.bin $(SRCDIR)/kernel.asm
	cat $(BINDIR)/bootloader.bin $(BINDIR)/kernel.bin > posh.img

run: img
	qemu-system-i386 -fda $(IMGNAME)

clean:
	rm $(CURDIR)/$(IMGNAME)
	rm $(BINDIR)/*.bin
