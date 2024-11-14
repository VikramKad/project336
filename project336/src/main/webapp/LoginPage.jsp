<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.myapp.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
    
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Log In to Train System</title>
</head>
<body>

	<form method="post" action= "LoginCheck.jsp">
		<table>
			<tr>    
				<td>Username</td><td><input type="text" name="user"></td>
			</tr>
			<tr> 
				<td>Password</td><td><input type="text" name="Password"></td>
			</tr>
		</table>
		<input type="submit" value="Log In">
	</form>
	
	<!-- Error message -->
	<%
	String errorMessage = (String) request.getAttribute("errorMessage");
	if (errorMessage != null) {
	    out.print("<p style='color:red;'>" + errorMessage + "</p>");
	}
	%>

	
</body>
</html>