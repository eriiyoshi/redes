
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.URLConnection;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
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
public class HTTPServer {

    private static final Logger logger = Logger.getLogger("HTTPServer");

    private byte[] content;
    private byte[] header;
    private String mimeType;
    
    //private final int port;
    private String encoding;

    private ServerSocket socket;
    private int port;
    private int portFisica;
    private String arquivo;

    public HTTPServer(int port, int portFisica, String arquivo) throws IOException {
        this.port = port;
        this.portFisica = portFisica;
        this.arquivo = arquivo;
        socket = new ServerSocket(port);

        this.mimeType = URLConnection.getFileNameMap().getContentTypeFor(arquivo);
        this.encoding = "UTF-8";
        this.content = Files.readAllBytes(Paths.get(arquivo));
        
        String header = "HTTP/1.0 200 OK\r\n"
                + "Server: OneFile 2.0\r\n"
                + "Content-length: " + this.content.length + "\r\n"
                + "Content-type: " + mimeType + "; charset=" + encoding + "\r\n\r\n";
        this.header = header.getBytes(Charset.forName("US-ASCII"));
        
        System.out.println(header);
    }

    public String recebeMensagemDaFisica() {
        try {
            ExecutorService pool = Executors.newFixedThreadPool(100);

            
            Socket cliente = socket.accept();
            pool.submit(new HTTPHandler(cliente));
            
            
            ObjectInputStream dadoCliente = new ObjectInputStream(cliente.getInputStream());
            return dadoCliente.readUTF();

        } catch (IOException ex) {
            Logger.getLogger(HTTPServer.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }

    public boolean enviaPaginaParaFisica() {
        try {

            String dadosDaPagina = lePagina();

            Socket fisica = new Socket(socket.getInetAddress(), portFisica);

            ObjectOutputStream dadoFisica = new ObjectOutputStream(fisica.getOutputStream());
            dadoFisica.flush();
            dadoFisica.writeUTF(dadosDaPagina);
            dadoFisica.close();
            fisica.close();

            return true;

        } catch (IOException ex) {
            Logger.getLogger(HTTPServer.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    private String lePagina() {

        StringBuffer stringBuffer = new StringBuffer();

        try {
            for (String linha : Files.readAllLines(Paths.get(arquivo), StandardCharsets.UTF_8)) {
                stringBuffer.append(linha);
            }

            return stringBuffer.toString();
        } catch (IOException ex) {
            Logger.getLogger(HTTPServer.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }

    }

    public static void main(String[] args) {

        try {
            int port = Integer.valueOf(args[0]);
            int portFisica = Integer.valueOf(args[1]);
            String arquivo = args[2];

            System.out.print("Conectando servidor na porta " + port + "...");
            HTTPServer server = new HTTPServer(port, portFisica, arquivo);
            System.out.print("Ok\n");

            Thread.sleep(10000);
            
            System.out.print("Recebendo mensagem do cliente...");
            server.recebeMensagemDaFisica();
            System.out.println("Ok\n");

            System.out.print("Enviando página para o cliente...");
            server.enviaPaginaParaFisica();
            System.out.print("Ok\n");

        } catch (IOException ex) {
            Logger.getLogger(HTTPServer.class.getName()).log(Level.SEVERE, null, ex);
        } catch (InterruptedException ex) {
            Logger.getLogger(HTTPServer.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    private class HTTPHandler implements Callable<Void> {

        private final Socket connection;

        HTTPHandler(Socket connection) {
            this.connection = connection;
        }

        @Override
        public Void call() throws IOException {
            try {
                OutputStream out = new BufferedOutputStream(
                        connection.getOutputStream()
                );
                InputStream in = new BufferedInputStream(
                        connection.getInputStream()
                );
                // read the first line only; that's all we need
                StringBuilder request = new StringBuilder(80);
                while (true) {
                    int c = in.read();
                    if (c == '\r' || c == '\n' || c == -1) {
                        break;
                    }
                    request.append((char) c);
                }
                // If this is HTTP/1.0 or later send a MIME header
                if (request.toString().indexOf("HTTP/") != -1) {
                    out.write(header);
                }
                out.write(content);
                out.flush();
            } catch (IOException ex) {
                logger.log(Level.WARNING, "Error writing to client", ex);
            } finally {
                connection.close();
            }
            return null;
        }
    }

}
