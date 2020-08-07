section .text

; Importados do strings.asm
extern modo_leitura
extern linebreak

; Importados da libc e ligados como GCC
extern printf
extern free
extern malloc
extern fopen
extern fread

; Lista de syscalls do linux https://filippo.io/linux-syscall-table/

SYSCALL_WRITE equ 1
SYSCALL_EXIT  equ 60
STDOUT equ 1

global exit
exit:
	; Sai do programa
	; Chama syscall exit
        mov rax, SYSCALL_EXIT
        mov rdi, 0		; Exit Code = 0, success
        syscall

global print
print:
        ; Imprime uma string em STDOUT
        ; Recebe string em RSI
        push rax
        push rsi
        call strlen     ; Tamanho da string em RAX
        pop rsi
                        	; Chamar syscall write em stdout
        mov rdi, STDOUT 	; File Description = STDOUT
        mov rdx, rax    	; Tamanho da string
        mov rax, SYSCALL_WRITE  ; Syscall Write
        syscall
        pop rax
        ret

global println
println:
        ; Imprime uma string em STDOUT e uma quebra de linha
        ; Recebe string em RSI
        push rsi
        call print              ; Imprime string recebida em RSI
        mov rsi, linebreak      ; Coloca quebra de linha em RSI
        call print              ; Imprime Quebra de Linha
        pop rsi
        ret

global eprintf
eprintf:
	; Imprime uma string em STDOUT usando printf da libc

        push rbp
        mov rbp, rsp
        call printf
        pop rbp
	ret	

global strlen
strlen:
        ; Calcula o comprimento da string até o primeiro 0x00
        ; String para se calcular rsi
        ; Tamanho retorna em rax
        push rbx   ; Salva valor original de RBX na Stack
        mov rbx, 0 ; Armazenar contagem de letras no RBX
loopstart:
        mov rax, 0      ; Reseta RAX para armazenar o byte
        lodsb           ; Lê o byte em RSI e grava em AL (8 bits da direita de RAX)
        test ax, ax     ; Verifica se AL = 0 -- CACHORRO / DOG
        jz loopout      ; Se AL == 0, vá para loopout
        inc rbx
        jmp loopstart   ; Volte para o começo do loop
loopout:
        mov rax, rbx
        pop rbx         ; Restaura valor original de RBX da Stack
        ret

global allocate
allocate:
	;	Aloca uma porção de memória de RDI bytes
	;	usando a função malloc da libc
	;	Endereço de memória retornado em RAX
        push rbp
        mov rbp, rsp
        mov rax, 0
        call malloc
        pop rbp
	ret

global deallocate
deallocate:
	;	Desaloca uma porção de memória no endereço RDI
	;	alocada com a função allocate usando a função
	;	free da libc
	;	Nenhum retorno
        push rbp
        mov rbp, rsp
        call free
        pop rbp
	ret

global abrirarquivo
abrirarquivo:
	;	Abre um arquivo usando função fopen da libc
	;	Nome do arquivo em rdi
	;	Sempre somente-leitura
	;	Retorna "handler" do arquivo em RAX
	push rbp
	mov rbp, rsp
	mov rsi, modo_leitura	
	call fopen
	pop rbp
	ret

global lerdados
lerdados:
	;	Le dados de um arquivo aberto com abrirarquivo
	;	Posicao de memoria de leitura em RDI
	;	Tamanho em RSI (numero de bytes)
	;	"Handler" do arquivo em RDX
	;	Retorna numero de bytes lidos em RAX
	push rbp
	mov rbp, rsp
	mov rcx, rdx
	mov rdx, 1	; Um elemento de RCX bytes
	call fread
	pop rbp
	ret

