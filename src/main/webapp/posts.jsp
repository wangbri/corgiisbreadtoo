<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="guestbook.Greeting" %>
<%@ page import="java.util.Collections" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="com.googlecode.objectify.Objectify" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>

  <head>
   <link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
  </head>
  <body>
  
<%
    String guestbookName = request.getParameter("guestbookName");
    if (guestbookName == null) {
        guestbookName = "default";
    }

    pageContext.setAttribute("guestbookName", guestbookName);
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    
    if (user != null) {
      pageContext.setAttribute("user", user);

%>

<p>Hello, ${fn:escapeXml(user.nickname)}! (You can
<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>

<%
	} else {
%>

<p>Hello!
<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a> to include your name with greetings you post.</p>

<%
    }
%>

<%
    Key guestbookKey = KeyFactory.createKey("Guestbook", guestbookName);

    // Run an ancestor query to ensure we see the most up-to-date
    // view of the Greetings belonging to the selected Guestbook.

	Query query = new Query("Greeting", guestbookKey).addSort("user", Query.SortDirection.DESCENDING).addSort("date", Query.SortDirection.DESCENDING);

	ObjectifyService.register(Greeting.class);
	List<Greeting> greetings = ObjectifyService.ofy().load().type(Greeting.class).list();   
	Collections.sort(greetings); 
    
    if (greetings.isEmpty()) {
%>

<p>Guestbook '${fn:escapeXml(guestbookName)}' has no messages.</p>

<%
    } else {
%>

<p>Messages in Guestbook '${fn:escapeXml(guestbookName)}'.</p>
        
<%
for (Greeting greeting : greetings) {
  
  	pageContext.setAttribute("greeting_title", greeting.getTitle());
    pageContext.setAttribute("greeting_content", greeting.getContent());
    pageContext.setAttribute("greeting_date", greeting.getDate());
%>
<p><b>${fn:escapeXml(greeting_title)}</b> at: <b>${fn:escapeXml(greeting_date)}</b></p>
<%    
    if (greeting.getUser() == null) {
%>
<p>An anonymous person wrote:</p>

<%
    } else {
        pageContext.setAttribute("greeting_user", greeting.getUser());
%>

<p><b>${fn:escapeXml(greeting_user.nickname)}</b> wrote:</p>

<%
    }
%>

<blockquote>${fn:escapeXml(greeting_content)}</blockquote>
 
<%
    }
}
%>
	<form action="/" method="post">
	  <div><input type="submit" value="Go back" /></div>
	  <input type="hidden" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/>
	</form>
	
  </body>
</html>

