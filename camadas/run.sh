#!/bin/bash

#Aplicacao Servidor
gnome-terminal -x sh -c "java -jar Aplicacao/MainServer.jar 9007 9006 9008 9009"

#Aplicacao Cliente
gnome-terminal -x sh -c "java -jar Aplicacao/MainClient.jar 8007 8006 8008 8009"

#Transporte Servidor
gnome-terminal -x sh -c "Transporte/TransporteServidor/transporteservidor 9005 9004 9006 9007 512"

#Transporte Cliente
gnome-terminal -x sh -c "Transporte/TransporteCliente/transportecliente 8005 8004 8006 8007"

cd Fisica
#Fisica Servidor
gnome-terminal -x sh -c "perl mainServer.pl 127.0.0.1 8002 8003 127.0.0.1 9004 9005"

#Fisica Cliente
gnome-terminal -x sh -c "perl mainClient.pl 127.0.0.1 8003 8002 127.0.0.1 8004 8005"

cd ..
