/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package aplicacao;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.nio.charset.StandardCharsets;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author gustavo
 */
public class LayerSocket {
    
    private ServerSocket socketReceiver;
    private Socket socketSender;
    private Socket client;
    
    private int portSender;
    private int portReceiver;
    
    private static int LIMIT = 4000;
    
    public LayerSocket(int portReceiver, int portSender) throws IOException{
        this.portReceiver = portReceiver;
        this.portSender = portSender;
    }
    
    public void initReceiver() throws IOException{
        socketReceiver = new ServerSocket(portReceiver);
        socketReceiver.setSoTimeout(0);
        
        client = socketReceiver.accept();
    }
    
    public void initSender() throws IOException{
        System.out.println("Inicializando envio para porta "+portSender);        
        
        socketSender = new Socket(InetAddress.getLocalHost(), portSender);
        socketSender.setSoTimeout(0);
        System.out.println("Concluido");        

    }
    
    public String receive() throws IOException{
        
        BufferedReader input = new BufferedReader(new InputStreamReader(client.getInputStream()));
        //BufferedReader buffer = new BufferedReader(input);
        char[] bytes = new char[LIMIT];
        
        int numBytes = input.read(bytes, 0, LIMIT); //bytes, 0, LIMIT);
        
        System.out.println("===============================");
        System.out.println("Recebidos "+ numBytes + " bytes na porta " + portReceiver);
        System.out.println("");
        for(char c : bytes){
            System.out.print((char) c);
        }
        
        return new String(bytes);
    }
    
    public void send(String message) throws IOException{
        
        PrintWriter output = new PrintWriter(socketSender.getOutputStream());
        //BufferedWriter buffer = new BufferedWriter(output);
        char[] bytes = message.toCharArray();
        
        output.write(bytes);
        output.flush();
        
        System.out.println("==============================");
        System.out.println("Enviados "+ bytes.length + " bytes pela porta " + portSender);
        System.out.println("");
    }
    
    public void close() throws IOException{
        if(socketSender != null)
            socketSender.close();
        if(socketReceiver != null)
            socketReceiver.close();    
    }
    
}
