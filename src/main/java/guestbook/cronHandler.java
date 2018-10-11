package guestbook;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.Properties;
import java.util.logging.Logger;

import javax.mail.Address;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.http.*;


@SuppressWarnings("serial")
public class cronHandler extends HttpServlet {
    private static final Logger _logger = Logger.getLogger(cronHandler.class.getName());
    public void doGet(HttpServletRequest req, HttpServletResponse resp)
    throws IOException {
        try {
            _logger.info("Cron Job has been executed");
            //Put your logic here
            //BEGIN
            resp.getWriter().println("Hello!");
            String user = "user";   // Newly created user on JAMES Server
            String password = "password"; // user password
            
            Properties properties = new Properties();
            properties.setProperty("mail.smtp.host", "localhost");
            properties.put("mail.transport.protocol", "smtp");
            properties.put("mail.smtp.host", "example.com");
            properties.put("mail.smtp.port", "25");
            properties.put("mail.smtp.username", user);
            properties.put("mail.smtp.password", password);
            Session session = Session.getDefaultInstance(properties, null);
            
            String from = "phyllis.ang@utexas.edu";
            String to = "phyllisayk@gmail.com";
                    

            try {
              Message msg = new MimeMessage(session);
              msg.setFrom(new InternetAddress(from, "Phyllis1"));
              msg.addRecipient(Message.RecipientType.TO,
                               new InternetAddress(to, "Phyllis2"));
              msg.setSubject("Your Example.com account has been activated");
              msg.setText("This is a test");
              Transport.send(msg);
            } catch (AddressException e) {
                resp.getWriter().println("Address Exception");
            } catch (MessagingException e) {
                resp.getWriter().println("Messaging Exception");
            } catch (UnsupportedEncodingException e) {
                resp.getWriter().println("UnsupportedEncoding Exception");
            }
            resp.getWriter().println("Finished Sending Message!");
            
            //END
        }
        catch (Exception ex) {
        //Log any exceptions in your Cron Job
        }
    }
    
    @Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
    throws ServletException, IOException {
        doGet(req, resp);
    }
    
    void addRecipients(Message.RecipientType type, Address[] addresses)
            throws MessagingException{
        
    }
}