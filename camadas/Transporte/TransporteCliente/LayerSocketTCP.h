/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   LayerSocket.h
 * Author: gustavo
 *
 * Created on May 28, 2017, 6:28 PM
 */

#ifndef LAYERSOCKETTCP_H
#define LAYERSOCKETTCP_H

#include <sys/socket.h>
#include <sys/types.h> 
#include <netinet/in.h>
#include <stdio.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include "LayerSocket.h"

class LayerSocketTCP : public LayerSocket {
public:
    LayerSocketTCP(int portReceiver, int portSender);
    //LayerSocket(const LayerSocket& orig);
    virtual ~LayerSocketTCP();
    
    void initReceiver();
    void initSender();
    int receive(char* buffer);
    void send(char* message);
    void close();
    
    static int LIMIT;
protected:
    //void formatMessage(int type, int sourcePort, int destinationPort, char* message, char* binaryMessage);
    //void printMessage(char* message);
    //void getDataFromMessage(char* message, char* data);
/*    int portSender;
    int portReceiver;
    
    struct sockaddr_in serv_addr;
    struct sockaddr_in cli_addr;
    
    int socketReceiverFD;
    int socketSenderFD;
*/        
};

#endif /* LAYERSOCKETTCP_H */

