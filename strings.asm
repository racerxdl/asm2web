section .rodata

global indexhtml
indexhtml:
	db `index.html`, 0

global lendoarquivo
lendoarquivo:
	db `Lendo arquivo %s\n`, 0

global linebreak
linebreak:
        db `\n`, 0

global helloworld
helloworld:
        db `HELLO WORLD`, 0

global javascripto
javascripto:
        db `VO MATA O JAVASCRIPTO`, 0

global hellworld
hellworld:
        db `HELL IS BURNING INTO FLAMES\nAND WE ARE KILLING DEMONS`, 0

global formathell
formathell:
	db `This is a number %d. This is a string %s\n`, 0

global minhas_frases
minhas_frases:
	dq helloworld
	dq javascripto
	dq hellworld


global modo_leitura
modo_leitura:
	db `r`, 0
