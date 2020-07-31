section .text

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

global minhas_frases
minhas_frases:
	dq helloworld
	dq javascripto
	dq hellworld


