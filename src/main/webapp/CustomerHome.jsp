<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.myapp.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>    
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Customer Home</title>
</head>
<body>
	<% 
	String username = (String) session.getAttribute("username");
	out.print("<p>Welcome, " + username + "</p>");
	%>
	<br>
	Customer Home
	<br>
	<button onClick="window.location.href='trainSchedulePage.jsp'">Schedules</button>
	<br>
	<button onClick="window.location.href='viewReservations.jsp'">View and Cancel Reservations</button>
	<br>

	<button onClick="window.location.href='ReservationMaker.jsp'">Make a Reservation</button>
    <br>
    <button onClick="window.location.href='CustomerBrowseQuestions.jsp'">Browse Questions</button>
    <!-- Form to send a question -->
    <form method="post" action="sendQuestions.jsp" style="display: inline;">
        <label for="question">Enter your question:</label>
        <input type="text" id="question" name="question" placeholder="Type your question here" style="width: 300px;" required>
        <button type="submit">Submit</button>
    </form>
    <form method="post" action="Logout.jsp">
	   <input type="submit" value="Log Out">
	</form>
    
</body>
</html>