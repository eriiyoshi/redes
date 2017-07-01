/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package aplicacao;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author gustavo
 */
public class MainClient {

    /*
              8008b
    9007r     8007r
    9006s     8006s

    9007s     8007s
    9006r     8006r
    9005r     8005r
    9004s     8004s

    9005s     8005s
    9004r     8004r
    9003r     8003r
    9002s     8002s

    9003s     8003s
    9002r     8002r
    9001r     8001s
    8000s <-> 8000r
     */
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here

        System.out.println("Aplicação - Cliente");
        
        Layer layer01 = null;

        try {
            int underPortReceiver = 8007;
            int underPortSender = 8006;
            int overPortReceiver = 8008;
            int overPortSender = 8008;
            
            if(args.length == 4){
                underPortReceiver = Integer.valueOf(args[0]);
                underPortSender = Integer.valueOf(args[1]);
                overPortReceiver = Integer.valueOf(args[2]);
                overPortSender = Integer.valueOf(args[3]);
            }
            
            //layer01 = new Layer(8007, 8006, 8008, 8008);
            layer01 = new Layer(underPortReceiver, underPortSender, overPortReceiver, overPortSender);
                        
            System.out.println("Estabelecendo conexão na porta " + underPortReceiver);            
            layer01.initUnderReceiver();
            System.out.println("Conexão estabelecida");
            
            Thread.sleep(1000);

            System.out.println("Estabelecendo conexão na porta " + underPortSender);
            layer01.initUnderSender();
            System.out.println("Conexão estabelecida");

            System.out.println("Estabelecendo conexão na porta " + overPortReceiver);
            layer01.initOverReceiver();
            System.out.println("Conexão estabelecida");

            String browser = layer01.receiveFromOver();
            System.out.println(browser);

            //while(true){
            /*String request = "GET /index.html HTTP/1.1\n"
                    + "User-Agent: curl/7.16.3 libcurl/7.16.3 OpenSSL/0.9.7l zlib/1.2.3\n"
                    + "Host: localhost\n"
                    + "Accept-Language: en, pt";
            */

            System.out.println("");
            System.out.println("Enviando mensagem");
            layer01.sendToUnder(browser);

            System.out.println("Mensagem enviada");

            System.out.println("Aguardando dados do cliente");

            String pageContent = layer01.receiveFromUnder();

            FileWriter fileWriter = new FileWriter("client.html");
            fileWriter.write(pageContent);
            fileWriter.close();

            java.awt.Desktop.getDesktop().open(new File("client.html"));

            System.out.println("Mensagem recebida");
            System.out.println("");

            //}
        } catch (IOException ex) {
            Logger.getLogger(LayerSocket.class.getName()).log(Level.SEVERE, null, ex);
        } catch (InterruptedException ex) {
            Logger.getLogger(MainServer.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                layer01.close();
            } catch (IOException ex) {
                //Logger.getLogger(Aplicacao.class.getName()).log(Level.SEVERE, null, ex);
            }

        }
    }

}
