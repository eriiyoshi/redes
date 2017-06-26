/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package aplicacao;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author gustavo
 */
public class Aplicacao {

    /*
    8007s     8007s
    8006s     8006s

    8007s     8007s
    8006r     8006r
    8005r     8005r
    8004s     8004s

    8005s     8005s
    8004r     8004r
    8003r     8003r
    8002s     8002s

    8003s     8003s
    8002r     8002r
    8001r     8001s
    8000s <-> 8000r
    */
    
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        
        Layer layer01 = null;
        Layer layer02 = null;
        Layer layer03 = null;
        Layer layer04 = null;
            
        
        try {
            int port = 8000;
            System.out.println("Aplicação - Servidor");
            
            System.out.println("Estabelecendo conexão na porta " + port);
            layer01 = new Layer(38001, 38000, 38002, 38003);
            layer02 = new Layer(38003, 38002, 38004, 38005);
            layer03 = new Layer(38005, 38004, 38006, 38007);
            layer04 = new Layer(38007, 38006, 38000, 38001);
            
            layer01.initSenders();
            layer02.initSenders();
            layer03.initSenders();
            layer04.initSenders();
                        
            System.out.println("Conexão estabelecida");
            
            //while(true){
            
                System.out.println("");
                System.out.println("Aguardando dados do cliente");
                
                layer01.sendToOver("");
                layer02.receiveFromUnder();
                
                layer02.sendToOver("");
                layer03.receiveFromUnder();
                
                layer03.sendToOver("");
                layer04.receiveFromUnder();
                
                layer04.sendToUnder("");
                layer03.receiveFromOver();
                
                layer03.sendToUnder("");
                layer02.receiveFromOver();
                
                layer02.sendToUnder("");
                layer01.receiveFromOver();
                                
                System.out.println("");
                System.out.println("Mensagem recebida");
            
            //}
        } catch (IOException ex) {
            Logger.getLogger(LayerSocket.class.getName()).log(Level.SEVERE, null, ex);
        }
        finally{
            try {
                layer01.close();
                layer02.close();
                layer03.close();
                layer04.close();
            } catch (IOException ex) {
                //Logger.getLogger(Aplicacao.class.getName()).log(Level.SEVERE, null, ex);
            }
            
        }
    }
    
}
