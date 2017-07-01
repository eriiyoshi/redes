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

int LayerSocketTCP::LIMIT = 50000;

LayerSocketTCP::LayerSocketTCP(int portReceiver, int portSender) {
    this->portReceiver = portReceiver;
    this->portSender = portSender;

    //printf("Inicializando recebimento na porta %d\n",portReceiver);        
    //initReceiver();
    //printf("Concluido");
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
    
    struct sockaddr client;
    
    socketReceiverFD = socket(AF_INET, SOCK_STREAM, 0);
    int sockeReceiverBind = bind(socketReceiverFD, (struct sockaddr *) &serv_addr, sizeof(serv_addr));
    int socketReceiverListen = listen(socketReceiverFD, 20);
    int c = sizeof(struct sockaddr_in);
    socketClient = accept(socketReceiverFD, (struct sockaddr*)&client, (socklen_t*)&c);
}

void LayerSocketTCP::initSender() {
    //printf("Inicializando envio pela porta %d\n", portSender);

    inet_pton(AF_INET, "127.0.0.1", &cli_addr.sin_addr);
    cli_addr.sin_family = AF_INET;
    cli_addr.sin_port = htons(portSender);
        
    socketSenderFD = socket(AF_INET, SOCK_STREAM, 0);
    int sockeSenderConnect = connect(socketSenderFD, (struct sockaddr *) &cli_addr, sizeof(cli_addr));

    //printf("Concluido\n");

}

void LayerSocketTCP::send(char* message) {
    int numBytes = ::send(socketSenderFD, message, strlen(message), 0);
    //printf("\nEnviou: %d\n", numBytes);
}

int LayerSocketTCP::receive(char* buffer) {
    int addrlen = sizeof(serv_addr);
    //int new_socket = recv(socketReceiverFD, buffer, LIMIT, 0);
    int new_socket = recv(socketClient, buffer, LIMIT, 0);
    //printf("\nRecebeu: %d\n", new_socket);
    
    return new_socket;//read(new_socket, buffer, LIMIT);    
}

void LayerSocketTCP::close(){
    ::close(socketSenderFD);
    ::close(socketReceiverFD);
}

void LayerSocket::formatMessage(int type, int sourcePort, int destinationPort, int window, char* message, char* binaryMessage){
    
    int sequenceNumber = rand()%(1<<10);
    int acknowledgementNumber = sequenceNumber+24+strlen(message);
    int dataOffset = 0;
    int reserved = 0;
    int urg = 0;
    int ack = type > 1 ? 1 : 0;
    int psh = 0;
    int rst = 0;
    int syn = type < 3 && type > 0 ? 1 : 0;
    int fin = 0;
    int checksum = 0;
    int urgentPointer = 0;
    int options = 0;
    int padding = 0;
    char data[50000];
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
    char str_data[50000];
    
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
    //toBin(data, str_data);
    strcpy(str_data, data);
    
    strcpy(binaryMessage, str_sourcePort);
    strcat(binaryMessage, str_destinationPort);
    strcat(binaryMessage, str_sequenceNumber);
    strcat(binaryMessage, str_acknowledgementNumber);
    strcat(binaryMessage, str_dataOffset);
    strcat(binaryMessage, str_reserved);
    strcat(binaryMessage, str_urg);
    strcat(binaryMessage, str_ack);
    strcat(binaryMessage, str_psh);
    strcat(binaryMessage, str_rst);
    strcat(binaryMessage, str_syn);
    strcat(binaryMessage, str_fin);
    strcat(binaryMessage, str_window);
    strcat(binaryMessage, str_checksum);
    strcat(binaryMessage, str_urgentPointer);
    strcat(binaryMessage, str_options);
    strcat(binaryMessage, str_padding);
    strcat(binaryMessage, str_data);
    
    //printf("Verificando mensagem: \n%s", binaryMessage);
}

void LayerSocket::printMessage(char* message){
    
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
    char str_data[50000];
    
    strcpy(str_sourcePort, "");
    for(int i=0; i<16; i++){
        char aux[2];
        aux[0] = message[i];
        aux[1] = '\0';
        strcat(str_sourcePort, aux);
    }
    printf("\nSource Port: %d", toInt(str_sourcePort));
    
    strcpy(str_destinationPort, "");
    for(int i=16; i<32; i++){
        char aux[2];
        aux[0] = message[i];
        aux[1] = '\0';
        strcat(str_destinationPort, aux);
    }
    printf("\nDestination Port: %d", toInt(str_destinationPort));
    
    strcpy(str_sequenceNumber, "");
    for(int i=32; i<64; i++){
        char aux[2];
        aux[0] = message[i];
        aux[1] = '\0';
        strcat(str_sequenceNumber, aux);
    }
    printf("\nSequence Number: %d", toInt(str_sequenceNumber));
    
    strcpy(str_acknowledgementNumber, "");
    for(int i=64; i<96; i++){
        char aux[2];
        aux[0] = message[i];
        aux[1] = '\0';
        strcat(str_acknowledgementNumber, aux);
    }
    printf("\nAcknowledgement Number: %d", toInt(str_acknowledgementNumber));
    
    strcpy(str_dataOffset, "");
    for(int i=96; i<100; i++){
        char aux[2];
        aux[0] = message[i];
        aux[1] = '\0';
        strcat(str_dataOffset, aux);
    }
    printf("\nData Offset: %d", toInt(str_dataOffset));
    
    strcpy(str_reserved, "");
    for(int i=100; i<106; i++){
        char aux[2];
        aux[0] = message[i];
        aux[1] = '\0';
        strcat(str_reserved, aux);
    }
    printf("\nReserved: %d", toInt(str_reserved));
    
    strcpy(str_urg, "");
    for(int i=106; i<107; i++){
        char aux[2];
        aux[0] = message[i];
        aux[1] = '\0';
        strcat(str_urg, aux);
    }
    printf("\nURG: %d", toInt(str_urg));
    
    strcpy(str_ack, "");
    for(int i=107; i<108; i++){
        char aux[2];
        aux[0] = message[i];
        aux[1] = '\0';
        strcat(str_ack, aux);
    }
    printf("\nACK: %d", toInt(str_ack));
    
    strcpy(str_psh, "");
    for(int i=108; i<109; i++){
        char aux[2];
        aux[0] = message[i];
        aux[1] = '\0';
        strcat(str_psh, aux);
    }
    printf("\nPSH: %d", toInt(str_psh));
    
    strcpy(str_rst, "");
    for(int i=109; i<110; i++){
        char aux[2];
        aux[0] = message[i];
        aux[1] = '\0';
        strcat(str_rst, aux);
    }
    printf("\nRST: %d", toInt(str_rst));
        
    strcpy(str_syn, "");
    for(int i=110; i<111; i++){
        char aux[2];
        aux[0] = message[i];
        aux[1] = '\0';
        strcat(str_syn, aux);
    }
    printf("\nSYN: %d", toInt(str_syn));
    
    strcpy(str_fin, "");
    for(int i=111; i<112; i++){
        char aux[2];
        aux[0] = message[i];
        aux[1] = '\0';
        strcat(str_fin, aux);
    }
    printf("\nFIN: %d", toInt(str_fin));
    
    strcpy(str_window, "");
    for(int i=112; i<128; i++){
        char aux[2];
        aux[0] = message[i];
        aux[1] = '\0';
        strcat(str_window, aux);
    }
    printf("\nWindow: %d", toInt(str_window));
    
    strcpy(str_checksum, "");
    for(int i=128; i<144; i++){
        char aux[2];
        aux[0] = message[i];
        aux[1] = '\0';
        strcat(str_checksum, aux);
    }
    printf("\nChecksum: %d", toInt(str_checksum));
    
    strcpy(str_urgentPointer, "");
    for(int i=144; i<160; i++){
        char aux[2];
        aux[0] = message[i];
        aux[1] = '\0';
        strcat(str_urgentPointer, aux);
    }
    printf("\nUrgent Pointer: %d", toInt(str_urgentPointer));
    
    strcpy(str_options, "");
    for(int i=160; i<184; i++){
        char aux[2];
        aux[0] = message[i];
        aux[1] = '\0';
        strcat(str_options, aux);
    }
    printf("\nOptions: %d", toInt(str_options));
        
    strcpy(str_padding, "");
    for(int i=184; i<192; i++){
        char aux[2];
        aux[0] = message[i];
        aux[1] = '\0';
        strcat(str_window, aux);
    }
    printf("\nPadding: %d", toInt(str_padding));
    
    /*strcpy(str_data, "");
    for(int i=192; i<224; i++){
        char aux[2];
        aux[0] = message[i];
        aux[1] = '\0';
        strcat(str_data, aux);
    }*/
    char data[50000];
    //toChar(str_data, data);
    strcpy(data, str_data);
    printf("\nData: %s", data);
    
}

void LayerSocket::getDataFromMessage(char* message, char* data){
    
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
    char str_data[50000];
    
    strcpy(str_sourcePort, "");
    for(int i=0; i<16; i++){
        char aux[2];
        aux[0] = message[i];
        aux[1] = '\0';
        strcat(str_sourcePort, aux);
    }
    
    strcpy(str_destinationPort, "");
    for(int i=16; i<32; i++){
        char aux[2];
        aux[0] = message[i];
        aux[1] = '\0';
        strcat(str_destinationPort, aux);
    }
    
    strcpy(str_sequenceNumber, "");
    for(int i=32; i<64; i++){
        char aux[2];
        aux[0] = message[i];
        aux[1] = '\0';
        strcat(str_sequenceNumber, aux);
    }
    
    strcpy(str_acknowledgementNumber, "");
    for(int i=64; i<96; i++){
        char aux[2];
        aux[0] = message[i];
        aux[1] = '\0';
        strcat(str_acknowledgementNumber, aux);
    }
    
    strcpy(str_dataOffset, "");
    for(int i=96; i<100; i++){
        char aux[2];
        aux[0] = message[i];
        aux[1] = '\0';
        strcat(str_dataOffset, aux);
    }
    
    strcpy(str_reserved, "");
    for(int i=100; i<106; i++){
        char aux[2];
        aux[0] = message[i];
        aux[1] = '\0';
        strcat(str_reserved, aux);
    }
    
    strcpy(str_urg, "");
    for(int i=106; i<107; i++){
        char aux[2];
        aux[0] = message[i];
        aux[1] = '\0';
        strcat(str_urg, aux);
    }
    
    strcpy(str_ack, "");
    for(int i=107; i<108; i++){
        char aux[2];
        aux[0] = message[i];
        aux[1] = '\0';
        strcat(str_ack, aux);
    }
    
    strcpy(str_psh, "");
    for(int i=108; i<109; i++){
        char aux[2];
        aux[0] = message[i];
        aux[1] = '\0';
        strcat(str_psh, aux);
    }
    
    strcpy(str_rst, "");
    for(int i=109; i<110; i++){
        char aux[2];
        aux[0] = message[i];
        aux[1] = '\0';
        strcat(str_rst, aux);
    }
        
    strcpy(str_syn, "");
    for(int i=110; i<111; i++){
        char aux[2];
        aux[0] = message[i];
        aux[1] = '\0';
        strcat(str_syn, aux);
    }
    
    strcpy(str_fin, "");
    for(int i=111; i<112; i++){
        char aux[2];
        aux[0] = message[i];
        aux[1] = '\0';
        strcat(str_fin, aux);
    }
    
    strcpy(str_window, "");
    for(int i=112; i<128; i++){
        char aux[2];
        aux[0] = message[i];
        aux[1] = '\0';
        strcat(str_window, aux);
    }
    
    strcpy(str_checksum, "");
    for(int i=128; i<144; i++){
        char aux[2];
        aux[0] = message[i];
        aux[1] = '\0';
        strcat(str_checksum, aux);
    }
    
    strcpy(str_urgentPointer, "");
    for(int i=144; i<160; i++){
        char aux[2];
        aux[0] = message[i];
        aux[1] = '\0';
        strcat(str_urgentPointer, aux);
    }
    
    strcpy(str_options, "");
    for(int i=160; i<184; i++){
        char aux[2];
        aux[0] = message[i];
        aux[1] = '\0';
        strcat(str_options, aux);
    }
        
    strcpy(str_padding, "");
    for(int i=184; i<192; i++){
        char aux[2];
        aux[0] = message[i];
        aux[1] = '\0';
        strcat(str_window, aux);
    }
    
    strcpy(str_data, "");
    //for(int i=192; i<224; i++){
    for(int i=192; i<strlen(message); i++){
        char aux[2];
        aux[0] = message[i];
        aux[1] = '\0';
        strcat(str_data, aux);
    }
    //toChar(str_data, data);
    strcpy(data, str_data);
}

void LayerSocket::toBin(int number, int num_bits, char* binary){
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

void LayerSocket::toBin(char* data, char* binary){
    
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

int LayerSocket::toInt(char* binary){
    
    int i = 0;
    int number = 0;
    for(i=0; i<strlen(binary); i++){
        if(binary[i] == '1')
            number += (1<<(strlen(binary)-1-i));
    }
    
    return number;
    
}

void LayerSocket::toChar(char* binary, char* str){
    
    strcpy(str, "");
    for(int i=0; i<strlen(binary)/8; i++){
        int sum = 0;
        for(int j=0; j<8; j++){
            if(binary[8*i+j] == '1')
                sum += 1<<(7-j);
        }
        char aux[2];
        aux[0] = (char) sum;
        aux[1] = '\0';
        strcat(str, aux);
    }
}