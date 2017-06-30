/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   Layer.cpp
 * Author: gustavo
 * 
 * Created on May 28, 2017, 10:41 PM
 */

#include "Layer.h"

int Layer::TCP = 1;
int Layer::UDP = 2;
int Layer::LIMIT = 4000;

Layer::Layer(int tcp1udp2, int underPortReceiver, int underPortSender, int overPortReceiver, int overPortSender) {
    this->underPortSender = underPortSender;
    this->underPortReceiver = underPortReceiver;
    this->overPortSender = overPortSender;
    this->overPortReceiver = overPortReceiver;

    if(tcp1udp2 == 2){
        printf("UDP\n");
        over = new LayerSocketUDP(overPortReceiver, overPortSender);
        under = new LayerSocketUDP(underPortReceiver, underPortSender);
    }
    else{
        printf("TCP\n");
        over = new LayerSocketTCP(overPortReceiver, overPortSender);
        under = new LayerSocketTCP(underPortReceiver, underPortSender);
    }

}

Layer::Layer() : Layer(1, 8000, 8000, 8001, 8001) {
    
}

/*
Layer::Layer(const Layer& orig) {
}
*/
Layer::~Layer() {
}

void Layer::sendToOver(char* message){
    over->send(message);
    //printf("\nChegooooou");
    return;
}

int Layer::receiveFromOver(char* buffer){
    over->receive(buffer);
}

void Layer::sendToUnder(char* message){
    under->send(message);
}

int Layer::receiveFromUnder(char* buffer){
    under->receive(buffer);
}

void Layer::close(){
    over->close();
    under->close();
}

int Layer::getOverPortSender() {
    return overPortSender;
}

int Layer::getUnderPortSender() {
    return underPortSender;
}

int Layer::getOverPortReceiver() {
    return overPortReceiver;
}

int Layer::getUnderPortReceiver() {
    return underPortReceiver;
}

void Layer::initReceivers(){
    over->initReceiver();
    under->initReceiver();
}

void Layer::initSenders(){
    over->initSender();
    under->initSender();
}

void Layer::initOverReceiver(){
    over->initReceiver();
}

void Layer::initOverSender(){
    over->initSender();
}

void Layer::initUnderReceiver(){
    under->initReceiver();
}

void Layer::initUnderSender(){
    under->initSender();
}

LayerSocket* Layer::getOver(){
    return over;
}

LayerSocket* Layer::getUnder(){
    return under;
}