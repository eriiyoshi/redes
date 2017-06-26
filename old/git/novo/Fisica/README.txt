É necessário executar dois scripts em duas consoles diferentes:

Antes de executá-los, é necessário editar esses arquivos.

mainDestination.pl
	
	my $arqEntrada = "sender/arquivo.bin"; # Nome do arquivo a ser enviado
	my $arqFrame = "sender/sframe"; # Nome do arquivo que salvará os frames
	my $destinationAddress = "127.0.0.1"; # IP do Servidor
	my $port = 7890; # Porta de comunicação
	my $arqTMQ = "sender/rtmq"; 
	my $arqVazio = "sender/vazio"; # Arquivo vazio


mainSource.pl

	my $port = 7890; # Porta de comunicação
	my $arqFrame = "receiver/rframe"; # Nome do arquivo que salvará os frames
	my $arqTMQ = "receiver/tmq";
	my $arqSaida = "receiver/saida.bin"; # Nome do arquivo recebido
	my $tmq = 10;


Arquivos de frame com nome sem numeração correspondem a solicitação e envio de TMQ.
Arquivos de frame com nome com numeração correspondem a frames do arquivo enviado.

************************************************************************************

COMANDOS

Enviando saída para LOG

Cliente:

perl mainDestination.pl &> logDestination

Servidor:

perl mainSource.pl &> logSource


Enviando saída para console

Cliente:

perl mainDestination.pl

Servidor:

perl mainSource.pl

