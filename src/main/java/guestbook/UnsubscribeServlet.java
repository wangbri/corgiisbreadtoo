package guestbook;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.ObjectifyService;
import static com.googlecode.objectify.ObjectifyService.ofy;
import com.google.appengine.api.datastore.Entity;
import com.googlecode.objectify.Key;
import com.google.appengine.api.datastore.KeyFactory;

public class UnsubscribeServlet extends HttpServlet{

	 public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
	      
	        ObjectifyService.register(MailingList.class);
	        UserService userService = UserServiceFactory.getUserService();
	        User user = userService.getCurrentUser();
	        
//	        String guestbookName = req.getParameter("guestbookName");
//	        Key<Guestbook> guestbookKey = Key.create(Guestbook.class, guestbookName);
//	        Entity mail = ofy().load().

	        ArrayList<Long> idList = new ArrayList<Long>();
	    	List<MailingList> mailing = ObjectifyService.ofy().load().type(MailingList.class).list();  
	    	if (!mailing.isEmpty()) {
	    		for (int i = 0; i < mailing.size(); i++) {
	    			if((mailing.get(i).getEmail()).equals(user.getEmail())) {
	    				idList.add(mailing.get(i).id);
	    			}
	    		}    	
	    	}
	    	ofy().delete().type(MailingList.class).ids(idList).now();
	    	idList.remove(0);
//	        List<MailingList> myList = ofy().load().type(MailingList.class).list();
//	        ArrayList<Long> idList = new ArrayList<Long>();
//	        idList.add();
//	        ofy().delete().type(MailingList.class).ids(idList).now();
	 }
}
