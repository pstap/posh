;;; kernel.asm
;;; the posh kernel

	org 0x5000
	bits 16

	section .text
	
start:
	;; set up stack
	mov		esp, stack_end		; set up stack pointer
	call	new_line
	mov 	si, start_success	; point to this string
	call	print_string

%include "real_mode_print.asm"
	
	section .data
start_success:	db "POSH Kernel Loaded", 0
	section .bss
stack_begin:
	resb 4096					; reserve 4 KiB of stack space
stack_end:	
