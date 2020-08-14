section .data
; VARIAVEL

buffer_temp:
        dq 0

status_code:
        dq 0

tmp_html_buff:
        dq 0

tmp_html_size:
        dq 0

section .text
; CODIGO

; Importado do sockets.asm
extern clientfd

; Importado do functions.asm
extern alo_kernel
extern strlen
extern allocate
extern deallocate
extern println
extern formatastring
extern eprintf
extern strlen

; Importado do strings.asm
extern httpstatusheader
extern htmlcontent
extern linhavazia

extern lendorequest
extern recebinbytes
extern enviandoheader
extern enviandoconteudo

;;
SYSCALL_SENDTO equ 44
SYSCALL_READ   equ 0


global mandaheader
mandaheader:
	; Recebe status code em RDI
	; Cria buffer de 1024 bytes
	mov [status_code], rdi
	mov rdi, 1024
	call allocate
	mov [buffer_temp], rax

	; Enviar HTTP/1.1 STATUSCODE
        mov rdi, [buffer_temp]
        mov rsi, httpstatusheader
	mov rdx, [status_code]
	mov rcx, 0
        mov rax, 0
        call formatastring

	mov rsi, [buffer_temp]
	call strlen

	; RAX == numero de caracteres em buffer_temp
	mov rdi, [buffer_temp] ; Buffer
	mov rsi, rax           ; Tamanho do buffer
	call enviaodado

	; Enviar Content-Type: text/html
        mov rdi, [buffer_temp]
        mov rsi, htmlcontent
	mov rdx, 0
	mov rcx, 0
        mov rax, 0
        call formatastring
		
        mov rsi, [buffer_temp]
        call strlen

        ; RAX == numero de caracteres em buffer_temp
        mov rdi, [buffer_temp] ; Buffer
        mov rsi, rax           ; Tamanho do buffer
        call enviaodado

        ; Enviar linha vazia
        mov rdi, [buffer_temp]
        mov rsi, linhavazia
	mov rdx, 0
	mov rcx, 0
        mov rax, 0
        call formatastring

        mov rsi, [buffer_temp]
        call strlen

        ; RAX == numero de caracteres em buffer_temp
        mov rdi, [buffer_temp] ; Buffer
        mov rsi, rax           ; Tamanho do buffer
        call enviaodado

	; Libera o buffer alocado
	mov rdi, [buffer_temp]
	call deallocate
	mov [buffer_temp], dword 0
	ret

global enviaodado
enviaodado:
	; Chama a syscall sendto com buffer em RDI e o tamanho do buffer em RSI
	mov rdx, rsi
	mov rsi, rdi
	mov rdi, [clientfd]
	mov r10, 0
	mov r8, 0
	mov r9, 0
	mov rax, SYSCALL_SENDTO
	call alo_kernel
	ret

global temdadonaweb
temdadonaweb:
	; Recebe o buffer em RDI
	; Recebe o tamanho em RSI
	mov rdx, rsi ; Tamanho
	mov rsi, rdi
	mov rdi, [clientfd]
	mov rax, SYSCALL_READ
	call alo_kernel
	ret

global passa_o_html_ae
passa_o_html_ae:
        ; Recebe conteudo em RDI
	; Recebe tamanho do conteudo em RSI

	; Salva em variaveis temporarias os valores do buffer e tamanho
	mov [tmp_html_buff], rdi
	mov [tmp_html_size], rsi

	; Cria buffer de 10240 bytes
        mov rdi, 10240
        call allocate
        mov [buffer_temp], rax

	; Imprime mensagem lendo request
	mov rdi, lendorequest
	mov rsi, 0
	mov rax, 0
	call eprintf

	; Ler o request
	mov rdi, [buffer_temp]
	mov rsi, 10239
	call temdadonaweb
	
	; Printar quantos bytes recebeu
	mov rdi, recebinbytes
	mov rsi, rax
	mov rax, 0
	call eprintf

	; Printar o request
	mov rdi, [buffer_temp]
	mov rsi, 0
	mov rax, 0
	call eprintf

	; Printar que está mandando header
        mov rdi, enviandoheader
        mov rsi, 0
        mov rax, 0
        call eprintf	

	; Manda o header 200
	mov rdi, 200
	call mandaheader

        ; Printar que está mandando conteudo
        mov rdi, enviandoconteudo
        mov rsi, 0
        mov rax, 0
        call eprintf

        ; Printar o request
        mov rdi, [tmp_html_buff]
        mov rsi, 0
        mov rax, 0
        call eprintf

	; Manda conteudo
	mov rdi, [tmp_html_buff]
	mov rsi, [tmp_html_size]
	call enviaodado	

        ; Libera o buffer alocado
        mov rdi, [buffer_temp]
        call deallocate
        mov [buffer_temp], dword 0
	ret



