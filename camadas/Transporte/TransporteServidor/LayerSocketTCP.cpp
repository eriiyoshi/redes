/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   LayerSocket.cpp
 * Author: gustavo
 * 
 * Created on May 28, 2017, 6:28 PM
 */

#include "LayerSocketTCP.h"

int LayerSocketTCP::LIMIT = 4000;

LayerSocketTCP::LayerSocketTCP(int portReceiver, int portSender) {
    this->portReceiver = portReceiver;
    this->portSender = portSender;

    printf("Inicializando recebimento na porta %d\n",portReceiver);        
    initReceiver();
    printf("Concluido");
}
/*
LayerSocket::LayerSocket(const LayerSocket& orig) {
}*/

LayerSocketTCP::~LayerSocketTCP() {
}

void LayerSocketTCP::initReceiver() {
    serv_addr.sin_addr.s_addr = INADDR_ANY; //localhost
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(portReceiver);
    
/*    struct sockaddr_in socket_cli_addr;
    socket_cli_addr.sin_addr.s_addr = inet_addr("127.0.0.1"); //localhost
    socket_cli_addr.sin_family = AF_INET;
    socket_cli_addr.sin_port = htons(portReceiver);
*/    
    socketReceiverFD = socket(AF_INET, SOCK_STREAM, 0);
    int sockeReceiverBind = bind(socketReceiverFD, (struct sockaddr *) &serv_addr, sizeof(serv_addr));
    int socketReceiverListen = listen(socketReceiverFD, 20);
//    int socketReceiverAccept = accept(socketReceiverFD, (struct sockaddr *) &socket_cli_addr, sizeof(socket_cli_addr));
    //int socketReceiverAccept = accept(socketReceiverFD, (struct sockaddr *) NULL, NULL);
}

void LayerSocketTCP::initSender() {
    printf("Inicializando envio pela porta %d\n", portSender);

    inet_pton(AF_INET, "127.0.0.1", &cli_addr.sin_addr);
    cli_addr.sin_family = AF_INET;
    cli_addr.sin_port = htons(portSender);
        
    socketSenderFD = socket(AF_INET, SOCK_STREAM, 0);
    int sockeSenderConnect = connect(socketSenderFD, (struct sockaddr *) &cli_addr, sizeof(cli_addr));

    printf("Concluido\n");

}

void LayerSocketTCP::send(char* message) {
    int numBytes = ::send(socketSenderFD, message, strlen(message), 0);
    printf("\nEnviou: %d\n", numBytes);
}

int LayerSocketTCP::receive(char* buffer) {
    int addrlen = sizeof(serv_addr);
    int new_socket = accept(socketReceiverFD, (struct sockaddr *)& serv_addr, (socklen_t*)&addrlen);
    
    return read(new_socket, buffer, LIMIT);    
}

void LayerSocketTCP::close(){
    ::close(socketSenderFD);
    ::close(socketReceiverFD);
}
