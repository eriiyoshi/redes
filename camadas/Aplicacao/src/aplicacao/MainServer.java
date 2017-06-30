/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package aplicacao;

import java.io.FileReader;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author gustavo
 */
public class MainServer {

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

        Layer layer02 = null;

        try {
            int underPortReceiver = 9007;
            int underPortSender = 9006;
            int overPortReceiver = 9008;
            int overPortSender = 9009;
            
            if(args.length == 4){
                underPortReceiver = Integer.valueOf(args[0]);
                underPortSender = Integer.valueOf(args[1]);
                overPortReceiver = Integer.valueOf(args[2]);
                overPortSender = Integer.valueOf(args[3]);
            }
            
            //layer02 = new Layer(9007, 9006, 9008, 8009);
            layer02 = new Layer(underPortReceiver, underPortSender, overPortReceiver, overPortSender);
            System.out.println("Estabelecendo conexão na porta " + underPortReceiver);
            layer02.initUnderReceiver();
            System.out.println("Conexão estabelecida");

            Thread.sleep(1000);

            System.out.println("Estabelecendo conexão na porta " + underPortSender);
            layer02.initUnderSender();
            System.out.println("Conexão estabelecida");

            //while(true){
            System.out.println("");
            System.out.println("Aguardando dados do cliente");

            String message = layer02.receiveFromUnder();
            System.out.println("Mensagem recebida");

            String[] strs = message.split(" ");

            String file = "index.html";

            if (strs != null && strs.length > 2) {
                if (strs[0].equals("GET")) {
                    file = strs[1].replaceAll("/", "");
                }
            }

            char[] content = new char[10000];
            FileReader fileReader = new FileReader(file);

            int nBytes = fileReader.read(content, 0, 10000);
            fileReader.close();

            String pageContent = new String(content);

            System.out.println("Enviando mensagem:");
            System.out.println(pageContent);
            layer02.sendToUnder(pageContent);

            System.out.println("Mensagem enviada");
            System.out.println("");

            //}
        } catch (IOException ex) {
            Logger.getLogger(LayerSocket.class.getName()).log(Level.SEVERE, null, ex);
        } catch (InterruptedException ex) {
            Logger.getLogger(MainServer.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                layer02.close();
            } catch (IOException ex) {
                //Logger.getLogger(Aplicacao.class.getName()).log(Level.SEVERE, null, ex);
            }

        }
    }

}
