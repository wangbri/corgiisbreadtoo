package guestbook;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.ObjectifyService;
import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SubscribeServlet extends HttpServlet {

    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
      
        ObjectifyService.register(MailingList.class);
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();

        // We have one entity group per Guestbook with all Greetings residing
        // in the same entity group as the Guestbook to which they belong.
        // This lets us run a transactional ancestor query to retrieve all
        // Greetings for a given Guestbook.  However, the write rate to each
        // Guestbook should be limited to ~1/second.
        if(!inDataStore(user)) {
        	String guestbookName = req.getParameter("guestbookName");
            Key guestbookKey = KeyFactory.createKey("Guestbook", guestbookName);
           
            Entity mailing = new Entity("MailingList", guestbookKey);

            mailing.setProperty("user", user);

            ofy().save().entity(mailing).now();
        }        
        resp.sendRedirect("ofyguestbook.jsp");
    }
    
    public boolean inDataStore(User user) {
    	ObjectifyService.register(MailingList.class);
    	List<MailingList> mailing = ObjectifyService.ofy().load().type(MailingList.class).list();  
    	if (!mailing.isEmpty()) {
    		for (int i = 0; i < mailing.size(); i++) {
    			if((mailing.get(i).getEmail()).equals(user.getEmail())) {
    				return true;
    			}
    		}    	
    	}
    	return false;
    }
}