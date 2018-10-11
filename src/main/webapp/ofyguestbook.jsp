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
     <link href="/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="bootstrap/js/bootstrap.min.js"></script>
	<style type="text/css">
   body { background: #191919 !important; } /* Adding !important forces the browser to overwrite the default style applied by Bootstrap */
</style>
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
<div align="center"><img src="/corgibread.jpg">s</div>


<p>Messages in Guestbook '${fn:escapeXml(guestbookName)}'.</p>
        
<%
//for (Greeting greeting : greetings) {
for (int i = 0; i < 5; i++) {
  	Greeting greeting = greetings.get(i);
  
  	pageContext.setAttribute("greeting_title", greeting.getTitle());
    pageContext.setAttribute("greeting_content", greeting.getContent());
    pageContext.setAttribute("greeting_date", greeting.getDate());
    pageContext.setAttribute("greeting_user", greeting.getUser());

%>
    <div align="center">
    <div class="card" style="width: 50rem;">
  <img class="card-img-top" src="/corgibackground.jpg" alt="Card image cap" width="250" height="50">
  <div class="card-body">
    <h5 class="card-title">${fn:escapeXml(greeting_title)} at ${fn:escapeXml(greeting_date)}</h5>
    <p class="card-text">${fn:escapeXml(greeting_content)}</p>
    <!-- <a href="#" class="btn btn-primary">Go somewhere</a> -->
  </div>
</div>
</div>

<%
	}
}
if (user != null) {
%>
	<form action="/post" method="post">
	  <div><input type="submit" value="Post" /></div>
	</form>
	
<%
}
%>
	<form action="/posts" method="post">
	  <div><input type="submit" value="View all posts" /></div>
	  <input type="hidden" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/>
	</form>
	
	
  </body>
</html>

