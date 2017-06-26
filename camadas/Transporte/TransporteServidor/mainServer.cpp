/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   mainServer.cpp
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
        
    int underPortReceiver = 9005;
    int underPortSender = 9004;
    int overPortReceiver = 9006;
    int overPortSender = 9007;
    
    if(argc == 5){
        underPortReceiver = atoi(argv[1]);
        underPortSender = atoi(argv[2]);
        overPortReceiver = atoi(argv[3]);
        overPortSender = atoi(argv[4]);
    }

    //Layer* layer02 = new Layer(2, 9005, 9004, 9007, 9006);
    Layer* layer02 = new Layer(1, underPortReceiver, underPortSender, overPortReceiver, overPortSender);

    sleep(1);
    printf("\nEstabelecendo conexão com a porta %d", overPortSender);
    layer02->initOverSender();
    printf("\nConcluido");
    printf("\nEstabelecendo conexão com a porta %d", overPortReceiver);
    layer02->initOverReceiver();
    printf("\nConcluido");
    
    printf("\nEstabelecendo conexão com a porta %d", underPortReceiver);
    layer02->initUnderReceiver();
    printf("\nConcluido");
    sleep(1);
    printf("\nEstabelecendo conexão com a porta %d", underPortSender);
    layer02->initUnderSender();
    printf("\nConcluido");
    
    layer02->receiveFromUnder(buffer);
    
    printf("\nMAIN->Recebido: %s", buffer);
    sprintf(buffer, "");
    
    layer02->sendToOver("Mensagem 02");
    layer02->receiveFromOver(buffer);

    printf("\nMAIN->Recebido: %s", buffer);

    layer02->sendToUnder("Mensagem 02");
    
    layer02->close();
        
    delete layer02;
    printf("\nFIM");
    
    return 0;
}

