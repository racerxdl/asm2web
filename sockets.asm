; Structs e Dados
section .data

; strings.asm
extern socket_deu_ruim
extern socket_deu_bom
extern sockopt_deu_bom
extern sockopt_deu_ruim
extern bindar_deu_bom
extern bindar_deu_ruim
extern escutar_deu_bom
extern escutar_deu_ruim
extern peraeconexao_deu_bom
extern peraeconexao_deu_ruim

; functions.asm
extern alo_kernel
extern eprintf

AF_INET equ 2
SOCK_STREAM equ 1

INADDR_ANY equ 0

SOL_SOCKET equ 1
SO_REUSEADDR equ 2
SO_REUSEPORT equ 15

SYSCALL_CLOSE		equ  3
SYSCALL_SOCKET		equ 41
SYSCALL_ACCEPT		equ 43
SYSCALL_SHUTDOWN	equ 48
SYSCALL_BIND   		equ 49
SYSCALL_LISTEN		equ 50
SYSCALL_SETSOCKOPT	equ 54
SYSCALL_EXIT		equ 60


PORTA equ 8094

struc sockaddr_in
        sin_family resb 2
	sin_port resb 2 
	s_addr resb 4
	sin_zero resb 8
endstruc

global address

address istruc sockaddr_in
	at sin_family , dw AF_INET
	at sin_port , dw 0
	at s_addr , dd 0
iend

global addrlen
addrlen:
	dd 16

global serverfd
serverfd:
	dq 0

global optseilaoq
optseilaoq:
	dd 1

global optseilaoqlen
optseilaoqlen:
	dd 4

global clientfd
clientfd:
	dq 0

; CODIGOS
section .text

global peraeconexao
peraeconexao:
	mov rdi, [serverfd]
	mov rsi, address
	mov rdx, addrlen
	mov rax, SYSCALL_ACCEPT
	call alo_kernel
	mov [clientfd], rax
	test rax, rax
	jl peraeconexao_deuruim
        ; jmp peraeconexao_deubom        ; Desnecessario pois peraeconexao_deubom
        ; vem logo em seguida

peraeconexao_deubom:
        ; Retorna pra quem chamou
        mov rdi, peraeconexao_deu_bom
        mov rsi, [clientfd]
        mov rdx, 0
        mov eax, 0
        call eprintf
        ret

peraeconexao_deuruim:
        ; :(
        mov rdi, peraeconexao_deu_ruim
        mov rsi, 0
        mov rdx, 0
        mov eax, 0
        call eprintf
        ; DIE
        mov rax, SYSCALL_EXIT
        mov rdi, 9999
        call alo_kernel

	

global criarsocket
criarsocket:
	; Cria um socket usando a syscall socket
	; retorno em RAX
	mov rdi, AF_INET
	mov rsi, SOCK_STREAM
	mov rdx, 0
	mov rax, SYSCALL_SOCKET
	call alo_kernel
	mov [serverfd], rax
	
	test rax, rax
	jz criarsocket_deuruim
	; jmp criarsocket_deubom	; Desnecessario pois criarsocket_deubom
	; vem logo em seguida

criarsocket_deubom:
	; Retorna pra quem chamou
	mov rdi, socket_deu_bom
        mov rsi, [serverfd]
        mov rdx, 0
        mov eax, 0
        call eprintf
	ret

criarsocket_deuruim:
	; :(
        mov rdi, socket_deu_ruim
        mov rsi, 0
        mov rdx, 0
        mov eax, 0
        call eprintf	
	; DIE
	mov rax, SYSCALL_EXIT 
	mov rdi, 9999
	call alo_kernel

global sockarserver
sockarserver:
	; Configurar socket para escutar na porta 8081 forçadamente
	mov rdi, [serverfd]
	mov rsi, SOL_SOCKET
	mov rdx, SO_REUSEADDR
        ;or rdx, SO_REUSEPORT
	mov r10, optseilaoq
	mov r8, [optseilaoqlen]
	mov rax, SYSCALL_SETSOCKOPT
	call alo_kernel
	test rax, rax
	jnz sockarserver_deuruim
	; jmp sockarserver_deubom ; ; Desnecessario sockarserver_deubom
        ; vem logo em seguida

sockarserver_deubom:
        ; Retorna pra quem chamou
        mov rdi, sockopt_deu_bom
        mov rsi, 0
        mov rdx, 0
        mov eax, 0
        call eprintf
        ret

sockarserver_deuruim:
        ; :(
        mov rdi, sockopt_deu_ruim
        mov rsi, 0
        mov rdx, 0
        mov eax, 0
        call eprintf
        ; DIE
        mov rax, SYSCALL_EXIT
        mov rdi, 9999
        call alo_kernel

global bindar
bindar:
	; Executa bind para porta PORTA
	mov rdi, PORTA
	call htons
	mov [address + sin_port], ax
	mov [address + s_addr], dword INADDR_ANY
	
	mov rdi, [serverfd]
	mov rsi, address
	mov rdx, [addrlen]
	mov rax, SYSCALL_BIND
	call alo_kernel
        test rax, rax
        jnz bindar_deuruim
        ; jmp bindar_deubom ; ; Desnecessario bindar_deubom
        ; vem logo em seguida

bindar_deubom:
        ; Retorna pra quem chamou
        mov rdi, bindar_deu_bom
        mov rsi, 0
        mov rdx, 0
        mov eax, 0
        call eprintf
        ret
bindar_deuruim:
        ; :(
        mov rdi, bindar_deu_ruim
        mov rsi, 0
        mov rdx, 0
        mov eax, 0
        call eprintf
        ; DIE
        mov rax, SYSCALL_EXIT
        mov rdi, 9999
        call alo_kernel 

global htons
htons:
	; Recebe um int16 no RDI e retorna os bytes invertidos em RAX
	mov rax, rdi
	xchg  ah, al
	ret

global escutar
escutar:
	mov rdi, [serverfd]
	mov rsi, 3
	mov rax, SYSCALL_LISTEN
	call alo_kernel
	test rax, rax
        jnz escutar_deuruim
        ; jmp escutar_deubom ; ; Desnecessario escutar_deubom
        ; vem logo em seguida

escutar_deubom:
        ; Retorna pra quem chamou
        mov rdi, escutar_deu_bom
        mov rsi, 0
        mov rdx, 0
        mov eax, 0
        call eprintf
        ret
escutar_deuruim:
        ; :(
        mov rdi, escutar_deu_ruim
        mov rsi, 0
        mov rdx, 0
        mov eax, 0
        call eprintf
        ; DIE
        mov rax, SYSCALL_EXIT
        mov rdi, 9999
        call alo_kernel

global fechacarai
fechacarai:
	; Shutdown cliente	
	mov rdi, [clientfd]
	mov rsi, 0
	mov rax, SYSCALL_SHUTDOWN
	call alo_kernel

	; Fecha conexao com cliente
	mov rdi, [clientfd]
	mov rax, SYSCALL_CLOSE
	call alo_kernel

	; Shutdown server
	mov rdi, [serverfd]
	mov rsi, 0
	mov rax, SYSCALL_SHUTDOWN
	call alo_kernel

	; Fecha conexao com servidor
	mov rdi, [serverfd]
	mov rax, SYSCALL_CLOSE
	call alo_kernel

	ret

