global _start

section .text

_start:

	; syscalls (/usr/include/asm/unistd_32.h)
	; socketcall numbers (/usr/include/linux/net.h)

	; Set up for socket file descriptor
	; int socket(int domain, int type, int protocol) (man 2 socket)
	; socket(AF_INET, SOCK_STREAM, IPPROTO_IP) (parameters)

	mov eax, 102	; Syscall 102 - socketcall 
	mov ebx, 1 	; Socketcall type - sys_socket 1

	; Setting parameters for the socket

	push 0	; IPPROTO_IP 0=all (protocol)
	push 1	; SOCK_STREAM 1 (type)
	push 2	; AF_INET 2 (domain)

	mov ecx, esp	; Pointer to arguments array

	int 0x80	; Interrupt for socket

	mov edx, eax	; Saving file descriptor

	; Binding socket
	; int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
	; bind(sockfd, [AF_INET, 11111, INADDR_ANY], 16)

	mov ebx, 2	; Socketcall type - sysbind 2
	
	; Making sockaddr in a struct (sys/socket.h, netinet/in.h and bits/sockaddr.h)
