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
    
    layer01->receiveFromOver(buffer);
    
    char mensagem[10000];
    
    // SYN
    layer01->getUnder()->formatMessage(1, layer01->getUnderPortSender(), layer01->getUnderPortSender(), 512, "", mensagem);
    
    layer01->sendToUnder(mensagem);
   
    // SYN-ACK
    layer01->receiveFromUnder(buffer);
    
    // Mensagem
    layer01->getUnder()->formatMessage(0, layer01->getUnderPortSender(), layer01->getUnderPortSender(), 512, "", mensagem);
    
    layer01->sendToUnder(mensagem);
   
    // SYN-ACK
    layer01->receiveFromUnder(buffer);
    
    
    printf("\nMAIN->Recebido: %s", buffer);
    sprintf(buffer, "");
    
    layer01->receiveFromOver(buffer);
    layer01->sendToUnder("Mensagem 02");

    layer01->receiveFromUnder(buffer);
    layer01->sendToOver("Mensagem 02");

    printf("\nMAIN->Recebido: %s", buffer);

    
    layer01->close();
        
    delete layer01;
    printf("\nFIM");
    
    return 0;
}

