<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.myapp.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Railway System</title>
</head>
<body>
	<h1>Railway System</h1>
	<p>Select an Option</p>
	<button onClick="window.location.href='LoginPage.jsp'">Login</button>
	<button onClick="window.location.href='trainSchedulePage.jsp'">Schedules</button>
</body>
</html>