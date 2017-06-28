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
        
    socketReceiverFD = socket(AF_INET, SOCK_STREAM, 0);
    int sockeReceiverBind = bind(socketReceiverFD, (struct sockaddr *) &serv_addr, sizeof(serv_addr));
    int socketReceiverListen = listen(socketReceiverFD, 20);
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

void LayerSocketTCP::formatMessage(int type, int sourcePort, int destinationPort, int window, char* message, char* binaryMessage){
    
    int sequenceNumber = rand()%(1<<16);
    int acknowledgementNumber = sequenceNumber+24+strlen(message);
    int dataOffset = 0;
    int reserved = 0;
    int urg = 0;
    int ack = type > 1 ? 1 : 0;
    int psh = 0;
    int rst = 0;
    int syn = type < 3 ? 1 : 0;
    int fin = 0;
    int checksum = 0;
    int urgentPointer = 0;
    int options = 0;
    int padding = 0;
    char data[10000];
    strcpy(data, message);
    
    char datagram[500];
    char str_sourcePort[30];
    char str_destinationPort[30];
    char str_sequenceNumber[50];
    char str_acknowledgementNumber[50];
    char str_dataOffset[10];
    char str_reserved[10];
    char str_urg[5];
    char str_ack[5];
    char str_psh[5];
    char str_rst[5];
    char str_syn[5];
    char str_fin[5];
    char str_window[30];
    char str_checksum[30];
    char str_urgentPointer[30];
    char str_options[30];
    char str_padding[10];
    char str_data[10000];
    
    toBin(sourcePort, 16, str_sourcePort);
    toBin(destinationPort, 16, str_destinationPort);
    toBin(sequenceNumber, 32, str_sequenceNumber);
    toBin(acknowledgementNumber, 32, str_acknowledgementNumber);
    toBin(dataOffset, 4, str_dataOffset);
    toBin(reserved, 6, str_reserved);
    toBin(urg, 1, str_urg);
    toBin(ack, 1, str_ack);
    toBin(psh, 1, str_psh);
    toBin(rst, 1, str_rst);
    toBin(syn, 1, str_syn);
    toBin(fin, 1, str_fin);
    toBin(window, 16, str_window);
    toBin(checksum, 16, str_checksum);
    toBin(urgentPointer, 16, str_urgentPointer);
    toBin(options, 24, str_options);
    toBin(padding, 8, str_padding);
    toBin(data, strlen(data), str_data);
     
}

void toBin(int number, int num_bits, char* binary){
    int i=0;
    strcpy(binary, "");
    for(i=num_bits-1; i>=0; i--){
        if(number >= 1<<i){
            strcat(binary, "1");
            number = number - (1<<i);
        }
        else{
            strcat(binary, "0");
        }
    }   
}

void toBin(char* data, char* binary){
    
    int i=0;
    int j=0;
    strcpy(binary, "");
    for(i=0; i<strlen(data); i++){
        int number = data[i]; 
        for(j=7; j>=0; j--){
            if(number >= 1<<j){
                strcat(binary, "1");
                number = number - (1<<j);
            }
            else{
                strcat(binary, "0");
            }
        }
    }
    
}

int toInt(char* binary){
    
    int i = 0;
    int number = 0;
    for(i=0; i<strlen(binary); i++){
        if(binary[i] == '1')
            number += (1<<i);
    }
    
}