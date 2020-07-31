section .text
global _start

extern helloworld
extern javascripto
extern hellworld
extern println
extern exit
extern minhas_frases

_start:
	;mov rsi, helloworld
	;call println

	;mov rsi, javascripto
	;call println

	;mov rsi, hellworld
	;call println

	; Primeira
	mov rsi, [minhas_frases]
	call println
	mov rsi, [minhas_frases + 8]
	call println
	mov rsi, [minhas_frases + 16]
	call println

	call exit
