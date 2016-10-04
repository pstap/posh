;;; real_mode_print.asm
;;; functions for printing in real mode
	
print_string:
	;; print a zero terminated string pointed to by si
	;; Store current registers
	push ax
	push bx
	push si

	;; start printing
	mov		al, [si]			; al holds character to print
	inc		si					; increment si to point to the next character
	or		al, al				; check if character is a 0
	jz		.end_print			; if 0 end the print
	call	.print_char			; fall through to print_char
	jmp		print_string		; loop

	.print_char:
	;; print a single character
	mov		ah, 0x0E 			; print char to current cursor position
	mov		bh, 0x00			; page number
	mov		bl, 0x08			; properties
	int 	0x10				; returns nothing
	ret

	.end_print:
	;; restore registers and return
	pop si
	pop bx
	pop ax
	ret

new_line:
	;; moves cursor to the next line, first column
	push ax
	push bx
	push cx
	push dx
 
    mov     ah, 0x03  ;; get cursor position
    mov     bh, 0x00  ;; page number
    int     0x10      ;; ch = start scan line, cl = end scan line, dh = row, dl = column
 
    mov     ah, 0x02  ;; set cursor position
    inc     dh        ;; Increment the row
    mov     dl, 0x00  ;; Set column to 0 (far left)
    int     0x10      ;; returns nothing
 
	;; restore registers
	pop dx
	pop cx
	pop bx
	pop ax
 
    ret

;;; Store characters for printing hex
hex_chars:	db "0123456789ABCDEF"
