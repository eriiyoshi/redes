
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.logging.Level;
import java.util.logging.Logger;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 *
 * @author Gustavo
 */
public class Client {

    private String domain;
    private int port;
    private int portFisica;
    private ServerSocket socket;
    public final static String MENSAGEM = "";
    
    public Client(String domain, int port, int portFisica) throws IOException {
        this.domain = domain;
        this.port = port;
        this.portFisica = portFisica;
        socket = new ServerSocket(port);
    }

    public boolean enviaMensagemParaFisica() {
        try {

            String dadosDaMensagem = MENSAGEM;
            
            Socket fisica = new Socket(socket.getInetAddress(), portFisica);

            ObjectOutputStream dadoFisica = new ObjectOutputStream(fisica.getOutputStream());
            dadoFisica.flush();
            dadoFisica.writeUTF(dadosDaMensagem);
            dadoFisica.close();
            fisica.close();
            
            return true;
            
        } catch (IOException ex) {
            Logger.getLogger(HTTPServer.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    public boolean recebePaginaDaFisica() {

        try {
            Socket fisica = socket.accept();

            ObjectInputStream dadoFisica = new ObjectInputStream(fisica.getInputStream());
            String dadoPagina = dadoFisica.readUTF();

            //TODO: Verificar se envia automaticamente para o browser  
            
        } catch (IOException ex) {
            Logger.getLogger(HTTPServer.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }

        return true;
    }
    
    public static void main(String[] args){
        
        try {
            String domain = "localhost";
            int port = Integer.valueOf(args[0]);
            int portFisica = Integer.valueOf(args[1]);

            Client client = new Client(domain, port, portFisica);
            
            client.enviaMensagemParaFisica();
            client.recebePaginaDaFisica();
            
        } catch (IOException ex) {
            Logger.getLogger(HTTPServer.class.getName()).log(Level.SEVERE, null, ex);
        }
        
    }

}
