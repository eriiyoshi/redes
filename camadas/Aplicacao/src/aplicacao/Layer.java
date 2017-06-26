/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package aplicacao;

import java.io.IOException;

/**
 *
 * @author gustavo
 */
public class Layer {
    
    private int overPortSender;
    private int overPortReceiver;
    private int underPortSender;
    private int underPortReceiver;
        
    private LayerSocket over;
    private LayerSocket under;
    
    public Layer(int underPortReceiver, int underPortSender, int overPortReceiver, int overPortSender) throws IOException{
        this.underPortSender = underPortSender;
        this.underPortReceiver = underPortReceiver;
        this.overPortSender = overPortSender;
        this.overPortReceiver = overPortReceiver;
        
        this.under = under;
        this.over = over;
        
        over = new LayerSocket(overPortReceiver, overPortSender);
        under = new LayerSocket(underPortReceiver, underPortSender);        
    }
    
    public void sendToOver(String message) throws IOException{
        over.send(message);
    }
    
    public String receiveFromOver() throws IOException{
        return over.receive();
    }

    public void sendToUnder(String message) throws IOException{
        under.send(message);
    }
    
    public String receiveFromUnder() throws IOException{
        return under.receive();
    }
    
    public void close() throws IOException{
        over.close();
        under.close();
    }

    public int getOverPortSender() {
        return overPortSender;
    }

    public int getUnderPortSender() {
        return underPortSender;
    }

    public int getOverPortReceiver() {
        return overPortReceiver;
    }

    public int getUnderPortReceiver() {
        return underPortReceiver;
    }

    public void initReceivers() throws IOException{
        over.initReceiver();
        under.initReceiver();
    }
    
    public void initSenders() throws IOException{
        over.initSender();
        under.initSender();
    }
    
    public void initUnderSender() throws IOException{
        under.initSender();
    }
    
    public void initUnderReceiver() throws IOException{
        under.initReceiver();
    }
    
    public void initOverSender() throws IOException{
        over.initSender();
    }
    
    public void initOverReceiver() throws IOException{
        over.initReceiver();
    }
    
}
