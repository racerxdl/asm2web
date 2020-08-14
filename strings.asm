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

global lendorequest
lendorequest:
	db `Estou lendo request\n`, 0

global recebinbytes
recebinbytes:
	db `Eu recebi %d bytes\n`, 0

global enviandoheader
enviandoheader:
	db `Enviando header\n`, 0

global enviandoconteudo
enviandoconteudo:
	db `Enviando conteudo\n`,0


global socket_deu_ruim
socket_deu_ruim:
	db `Deu ruim pra abrir o socket. Malz ae :(\n`, 0

global socket_deu_bom
socket_deu_bom:
	db `Ae meu chapa, deu bom com o socket. Tae: %d\n`, 0

global sockopt_deu_bom
sockopt_deu_bom:
	db `AE. Server sockou gostoso. \n`, 0	

global sockopt_deu_ruim
sockopt_deu_ruim:
	db `Ae meu chapa, server sockou errado.\n`, 0

global bindar_deu_bom
bindar_deu_bom:
	db `BINDEI!\n`, 0

global bindar_deu_ruim
bindar_deu_ruim:
	db `Num deu pra binda nao :(\n`, 0


global escutar_deu_bom
escutar_deu_bom:
	db `AE, to te ouvindo.\n`, 0

global escutar_deu_ruim
escutar_deu_ruim:
	db `Ow, fala direito, nao to te ouvindo.\n`, 0

global peraeconexao_deu_bom
peraeconexao_deu_bom:
	db `AE, ALGUEM TA AQUI. %d\n`, 0

global peraeconexao_deu_ruim
peraeconexao_deu_ruim:
	db `VISH\n`, 0



global httpstatusheader
httpstatusheader:
	db `HTTP/1.1 %d\r\n`, 0

global htmlcontent
htmlcontent:
	db `Content-Type: text/html\r\n`, 0

global linhavazia
linhavazia:
	db `\r\n`, 0



