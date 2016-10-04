;;; bootloader.asm
;;; Tasks
;;; loads kernel to 0x0500:0x0000
;;; jumps to kernel and begins execution

	org 0x7C00
	bits 16

start:
	;; store the boot disk which is put in dl at boot
	mov [b_disk], dl
	
	;; print splash text
	mov 	si, splash
print_splash:
	mov 	al, [si]			; al holds character to print
	inc 	si					; increment string pointer
	or 		al, al				; check if al is 0
	jz 		reset_disk			; if it is print is over

	;; set up print char bios call
	mov 	ah, 0x0E			; print char at current cursor position
	mov 	bh, 0x00			; page number
	mov 	bl, 0x08			; properties
	int 	0x10				; execute
	jmp 	print_splash		; loop
	
reset_disk:
	;; reset the floopy controller until it loads
	mov		ah, 0x00 			; reset floppy controller
	mov		dl, [b_disk]		; stored drive number (should be 0)
	int		0x13				; execute
	jc		reset_disk			; if failed try again

load_kernel:
	mov		bx, 0x0500			; Read data to this offset
	mov		es, bx				; move base address to this offset
	mov		bx, 0x0000			; save offset [es:bx]
	mov		ah, 0x02			; read disk to memory
	mov		dl, [b_disk]		; the first floppy disk stored at b_disk
	mov		ch, 0x00			; first track/cylinder
	mov 	cl, 0x02			; read starting with second sector (byte 513)
	mov		dh, 0x00			; read head
	mov		al, 0x01			; read 1 sector
	int 	0x13				; execute
	jc		load_kernel			; if failed loop and try again
	jmp		0x0500:0x0000		; jump to loaded kernel
		
splash:
	db "Loading POSH Kernel", 0

b_disk:
	db 0
	
padding:	
	times 510 - ($ - $$) db 0
	;; boot signature
	db 0x55
	db 0xAA
