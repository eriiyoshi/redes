/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   mainClient.cpp
 * Author: gustavo
 *
 * Created on June 8, 2017, 4:01 AM
 */

#include <cstdlib>
#include <unistd.h>
#include "Layer.h"

using namespace std;

/*
 * 
 */
int main(int argc, char** argv) {

    printf("\nTransporte - Cliente\n");
    
    char buffer[LayerSocketTCP::LIMIT];
    char buffer2[LayerSocketTCP::LIMIT];
    int numBytes = 0;
    
    int underPortReceiver = 8005;
    int underPortSender = 8004;
    int overPortReceiver = 8007;
    int overPortSender = 8006;

    if(argc == 5){
        underPortReceiver = atoi(argv[1]);
        underPortSender = atoi(argv[2]);
        overPortReceiver = atoi(argv[3]);
        overPortSender = atoi(argv[4]);
    }

    //Layer* layer01 = new Layer(2, 8005, 8004, 8007, 8006);
    Layer* layer01 = new Layer(1, underPortReceiver, underPortSender, overPortReceiver, overPortSender);
    
    /*sleep(1);
    layer01->initOverSender();
    sleep(1);
    layer01->initUnderSender();
    
    layer01->initUnderReceiver();
    layer01->initOverReceiver();
*/
    sleep(1);
    printf("\nEstabelecendo conexão com a porta %d", overPortSender);
    layer01->initOverSender();
    printf("\nConcluido");
    printf("\nEstabelecendo conexão com a porta %d", overPortReceiver);
    layer01->initOverReceiver();
    printf("\nConcluido");
    
    printf("\nEstabelecendo conexão com a porta %d", underPortReceiver);
    layer01->initUnderReceiver();
    printf("\nConcluido");
    sleep(1);
    printf("\nEstabelecendo conexão com a porta %d", underPortSender);
    layer01->initUnderSender();
    printf("\nConcluido");

    //-------------------------------------------------------------------

    printf("\n\n----------------------------------------\n\n");
    
    layer01->receiveFromOver(buffer);
    printf("Mensagem recebida: \n%s", buffer);
    
    char mensagem[LayerSocketTCP::LIMIT];
    char bufferAux[LayerSocketTCP::LIMIT];

    printf("\n\nEnviando SYN:\n");
    // SYN
    layer01->getUnder()->formatMessage(1, layer01->getUnderPortSender(), layer01->getUnderPortSender(), 512, "", mensagem);
    layer01->getUnder()->printMessage(mensagem);
    // TODO: Tratar falha no envio
    layer01->sendToUnder(mensagem);
   
    printf("\n\nMensagem Recebida:\n");
    // SYN-ACK
    layer01->receiveFromUnder(bufferAux);
    printf("defeito:%s", bufferAux);
    layer01->getUnder()->printMessage(bufferAux);
    
    printf("\n\nEnviando Mensagem:\n");
    // Envio
    // Mensagem
    // TODO: Dividir de acordo com window
    char binary[LayerSocketTCP::LIMIT];
    LayerSocket::toBin(buffer, binary);
    layer01->getUnder()->formatMessage(0, layer01->getUnderPortSender(), layer01->getUnderPortSender(), 512, binary, mensagem);
    //layer01->getUnder()->formatMessage(0, layer01->getUnderPortSender(), layer01->getUnderPortSender(), 512, buffer, mensagem);
    // TODO: Tratar falha no envio    
    layer01->sendToUnder(mensagem);
    
    printf("\n\nMensagem Recebida:\n");
    // ACK
    layer01->receiveFromUnder(bufferAux);
    layer01->getUnder()->printMessage(bufferAux);
    
    printf("\n\nMensagem Recebida:\n");
    // Recebimento
    // Mensagem
    layer01->receiveFromUnder(buffer);
    layer01->getUnder()->printMessage(buffer);

    printf("\n\nEnviando para aplicação:\n");
    char data[LayerSocketTCP::LIMIT];
    layer01->getUnder()->getDataFromMessage(buffer, binary);
    LayerSocket::toChar(binary, data);
    printf("%s", data);
    layer01->sendToOver(data);
    
    /*
    printf("\nMAIN->Recebido: %s", buffer);
    sprintf(buffer, "");
    
    layer01->receiveFromOver(buffer);
    layer01->sendToUnder("Mensagem 02");

    layer01->receiveFromUnder(buffer);
    layer01->sendToOver("Mensagem 02");

    printf("\nMAIN->Recebido: %s", buffer);
    */
    
    layer01->close();
        
    delete layer01;
    printf("\nFIM");
    
    return 0;
}

