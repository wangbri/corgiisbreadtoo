package guestbook;

import com.google.appengine.api.users.User;
import com.googlecode.objectify.Key;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
import com.googlecode.objectify.annotation.Parent;

@Entity
public class MailingList {

	@Parent Key<Guestbook> guestbookName;
	@Id Long id;
	@Index User user;
	
	public MailingList(User user, String guestbookName) {
		this.guestbookName = Key.create(Guestbook.class, guestbookName);
		this.user = user;
	}
	    
	public User getUser() {
        return user;
    }
    
	
	public String getEmail() {
		return user.getEmail();
	}
}
