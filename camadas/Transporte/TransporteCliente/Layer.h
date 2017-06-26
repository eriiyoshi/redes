/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   Layer.h
 * Author: gustavo
 *
 * Created on May 28, 2017, 10:41 PM
 */

#ifndef LAYER_H
#define LAYER_H

#include "LayerSocket.h"
#include "LayerSocketTCP.h"
#include "LayerSocketUDP.h"

class Layer {
public:
    Layer();
    Layer(int tcp1udp2, int underPortReceiver, int underPortSender, int overPortReceiver, int overPortSender);
    //Layer(const Layer& orig);
    virtual ~Layer();
    
    void sendToOver(char* message);
    int receiveFromOver(char* buffer);
    void sendToUnder(char* message);
    int receiveFromUnder(char* buffer);
    void close();
    int getOverPortSender();
    int getUnderPortSender();
    int getOverPortReceiver();
    int getUnderPortReceiver();
    void initReceivers();
    void initSenders();
    void initOverReceiver();
    void initOverSender();
    void initUnderReceiver();
    void initUnderSender();
    
    static int LIMIT;
    static int TCP;
    static int UDP;

private:
    int overPortSender;
    int overPortReceiver;
    int underPortSender;
    int underPortReceiver;
        
    LayerSocket* over;
    LayerSocket* under;
};

#endif /* LAYER_H */

