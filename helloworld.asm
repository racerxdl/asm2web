section .text
global _start

_start:
	mov rsi, helloworld
	call println

	mov rsi, javascripto
	call println

	mov rsi, hellworld
	call println

	call exit
	
exit:
	mov rax, 60
	mov rdi, 0
	syscall


print:
	; Imprime uma string em STDOUT
	; Recebe string em RSI
	push rax
	push rsi
	call strlen	; Tamanho da string em RAX
	pop rsi
			; Chamar syscall write em stdout
	mov rdi, 1	; File Description = STDOUT
	mov rdx, rax	; Tamanho da string
	mov rax, 1	; Syscall Write
	syscall
	pop rax	
	ret

println:
	; Imprime uma string em STDOUT e uma quebra de linha
	; Recebe string em RSI
	push rsi
	call print 		; Imprime string recebida em RSI
	mov rsi, linebreak 	; Coloca quebra de linha em RSI
	call print		; Imprime Quebra de Linha
	pop rsi
	ret

strlen:
	; Calcula o comprimento da string até o primeiro 0x00
	; String para se calcular rsi
	; Tamanho retorna em rax
	push rbx   ; Salva valor original de RBX na Stack
	mov rbx, 0 ; Armazenar contagem de letras no RBX

loopstart:
	mov rax, 0	; Reseta RAX para armazenar o byte
	lodsb		; Lê o byte em RSI e grava em AL (8 bits da direita de RAX)
	test ax, ax 	; Verifica se AL = 0 -- CACHORRO / DOG
	jz loopout	; Se AL == 0, vá para loopout 
	inc rbx
	jmp loopstart   ; Volte para o começo do loop
loopout:
	mov rax, rbx
	pop rbx    	; Restaura valor original de RBX da Stack
	ret

linebreak:
	db `\n`, 0

helloworld:
	db `HELLO WORLD`, 0

javascripto:
	db `VO MATA O JAVASCRIPTO`, 0

hellworld:
	db `HELL IS BURNING INTO FLAMES\nAND WE ARE KILLING DEMONS`, 0
