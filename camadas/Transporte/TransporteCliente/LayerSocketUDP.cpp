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

#include "LayerSocketUDP.h"

int LayerSocketUDP::LIMIT = 4000;

LayerSocketUDP::LayerSocketUDP(int portReceiver, int portSender) {
    this->portReceiver = portReceiver;
    this->portSender = portSender;

    printf("Inicializando recebimento na porta %d\n",portReceiver);        
    initReceiver();
    printf("Concluido");
}
/*
LayerSocket::LayerSocket(const LayerSocket& orig) {
}*/

LayerSocketUDP::~LayerSocketUDP() {
}

void LayerSocketUDP::initReceiver() {
    serv_addr.sin_addr.s_addr = inet_addr("127.0.0.1"); //localhost
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(portReceiver);
        
    socketReceiverFD = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
    int sockeReceiverBind = bind(socketReceiverFD, (struct sockaddr *) &serv_addr, sizeof(serv_addr));
    int socketReceiverListen = listen(socketReceiverFD, 20);
    
}

void LayerSocketUDP::initSender() {
    printf("Inicializando envio pela porta %d\n", portSender);
    cli_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
    cli_addr.sin_family = AF_INET;
    cli_addr.sin_port = htons(portSender);
        
    socketSenderFD = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
    //int sockeSenderConnect = connect(socketSenderFD, (struct sockaddr *) &cli_addr, sizeof(cli_addr));
    printf("Concluido\n");
}

void LayerSocketUDP::send(char* message) {
    socklen_t addrlen = sizeof(cli_addr);
    int numBytes = ::sendto(socketSenderFD, message, strlen(message), 0, (struct sockaddr *) &cli_addr, addrlen);
    printf("\nEnviou: %d\n", numBytes);
}

int LayerSocketUDP::receive(char* buffer) {
    int ret = recv(socketReceiverFD, buffer, LIMIT, 0);//, (struct sockaddr *) &serv_addr, (socklen_t *) addrlen);
    return ret;
}

void LayerSocketUDP::close(){
    ::close(socketSenderFD);
    ::close(socketReceiverFD);
}
