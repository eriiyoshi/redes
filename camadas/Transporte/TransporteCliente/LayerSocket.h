/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   LayerSocket.h
 * Author: gustavo
 *
 * Created on May 29, 2017, 1:34 AM
 */

#ifndef LAYERSOCKET_H
#define LAYERSOCKET_H

#include <sys/socket.h>
#include <sys/types.h> 
#include <netinet/in.h>
#include <stdio.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>

class LayerSocket {
public:
    LayerSocket();
    virtual ~LayerSocket();
    
    virtual void initReceiver();
    virtual void initSender();
    virtual int receive(char* buffer);
    virtual void send(char* message);
    virtual void close();
    virtual void formatMessage(int type, int sourcePort, int destinationPort, int window, char* message, char* binaryMessage);
    virtual void printMessage(char* message);
    virtual void getDataFromMessage(char* message, char* data);
    
    static void toBin(int number, int num_bits, char* binary);
    static void toBin(char* data, char* binary);
    static int toInt(char* binary);
    static void toChar(char* binary, char* str);
    
    static int LIMIT;
    
    
protected:
    int portSender;
    int portReceiver;
    
    struct sockaddr_in serv_addr;
    struct sockaddr_in cli_addr;
    
    int socketReceiverFD;
    int socketSenderFD;
    int socketClient;
            
};

#endif /* LAYERSOCKET_H */

