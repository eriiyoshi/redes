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
import java.io.DataInputStream;
import java.io.DataOutputStream;
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
    
    private static int LIMIT = 50000;
    
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
        //System.out.println("Inicializando envio para porta "+portSender);        
        
        socketSender = new Socket(InetAddress.getLocalHost(), portSender);
        socketSender.setSoTimeout(0);
        //System.out.println("Concluido");        

    }
    
    public String receive() throws IOException{
        
        DataInputStream input = new DataInputStream(client.getInputStream());
        //BufferedReader buffer = new BufferedReader(input);
        byte[] bytes = new byte[LIMIT];
        
        int numBytes = input.read(bytes, 0, LIMIT); //bytes, 0, LIMIT);
        
        System.out.println("===============================");
        System.out.println("Recebidos "+ numBytes + " bytes na porta " + portReceiver);
        System.out.println("");
        
        StringBuilder strBuilder = new StringBuilder();
        
        for(int i=0; i<numBytes; i++){
            strBuilder.append((char) bytes[i]);
        }
        
        System.out.println(strBuilder.toString());
        
        return strBuilder.toString();
    }
    
    public void send(String message) throws IOException{
        
        DataOutputStream output = new DataOutputStream(socketSender.getOutputStream());
        //BufferedWriter buffer = new BufferedWriter(output);
        byte[] bytes = message.getBytes();
        
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
    
    public static String toBin(String str){
        StringBuilder builder = new StringBuilder();
        for(char c : str.toCharArray()){
            builder.append(
                String.format("%08d", Integer.valueOf(Integer.toBinaryString((int) c)))
            );
        }
        
        return builder.toString();
    }
    
    public static String toChar(String str){
        StringBuilder builder = new StringBuilder();
        
        for(int i=0; i<str.length()/8; i++){
            int sum = 0;
            for(int j=0; j<8; j++){
                if(str.charAt(8*i+j) == '1')
                    sum += 1<<(7-j);
            }
            builder.append((char) sum);
        }
      
        return builder.toString();
    }
    
}
