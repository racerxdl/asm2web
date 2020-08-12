; Seção .text contém todos os códigos os quais
; queremos executar. Esta seção é somente leitura
section .text
global main


; Importado de outros arquivos .asm
; nesta pasta
extern helloworld
extern javascripto
extern hellworld
extern linebreak
extern minhas_frases
extern formathell
extern indexhtml
extern lendoarquivo

; Importado do functions.asm
extern eprintf
extern allocate
extern deallocate
extern println
extern exit
extern abrirarquivo
extern lerdados

; Importado do sockets.asm
extern criarsocket
extern sockarserver
extern htons
extern bindar
extern escutar
extern peraeconexao

endereco:
	db `Endereco do malloc eh %p\n`, 0

main:
	;mov rsi, helloworld
	;call println

	;mov rsi, javascripto
	;call println

	;mov rsi, hellworld
	;call println

	; Primeira
	;mov rsi, [minhas_frases]
	;call println
	;mov rsi, [minhas_frases + 8]
	;call println
	;mov rsi, [minhas_frases + 16]
	;call println

	; Aloca uma variável de 16 bytes
	mov rdi, 16
	call allocate
	
	; Armazena o endereço da nova variável em tmpend
	mov [tmpend], rax
	
	; Imprime o endereço que acabamos de alocar
	mov rdi, endereco
	mov rsi, [tmpend]
	mov rax, 0
	call eprintf

	; Imprime uma string formatada
	mov rdi, formathell ; Primeiro argumento (campo format)
	mov rsi, 100        ; Segundo argumento
	mov rdx, hellworld  ; Terceiro argumento
	mov eax, 0
	call eprintf
	
	; Imprime uma quebra de linha
	mov rdi, linebreak
	mov rsi, 0
	mov rdx, 0
	mov eax, 0
	call eprintf

	; Libera a variavel alocada com malloc
	; a qual o endereço foi gravado em tmpend
	mov rdi, [tmpend]
	call deallocate

	; Imprime que está carregando o arquivo index.html
	mov rdi, lendoarquivo
	mov rsi, indexhtml
	mov rdx, 0
	mov eax, 0
	call eprintf

	; Abre o arquivo index.html
	mov rdi, indexhtml
	call abrirarquivo
	
	; Salva o "handler" do arquivo aberto em RAX
	mov [arquivoaberto], rax

	; Cria variavel de 1024 bytes para armazenar o conteudo do arquivo
	mov rdi, 1024
	call allocate
	mov [tmpend], rax

	; Le dados
	mov rdi, [tmpend]
	mov rsi, 1023
	mov rdx, [arquivoaberto]
	call lerdados			

	; Imprime dados lidos
	mov rdi, [tmpend]
	mov rsi, 0
	mov rdx, 0
	mov eax, 0
	call eprintf

	; Criar server socket
	call criarsocket

	; Sockar forçadamente a porta e o endereço (setsockopt)
	call sockarserver

	; Bindar a porta
	call bindar

	; Escutar na porta
	call escutar

	; Esperar conexao
	call peraeconexao

	; Sai do programa
	call exit

; Variaveis na seção .data
; A seção .data contém dados de leitura / gravação
; Porém não executáveis (códigos na seção .data não
; serão executados)

section .data
tmpend:
        dq 0
arquivoaberto:
	dq 0
