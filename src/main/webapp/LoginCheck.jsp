<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.myapp.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

	
	
	<%
	try{
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		String inputUsername = request.getParameter("user");
		String inputPassword = request.getParameter("Password");
	
		if(inputUsername != null && inputPassword !=null){
			String query = "SELECT * FROM Accounts WHERE username = ? AND password = ?";
			PreparedStatement ps = con.prepareStatement(query);
			ps.setString(1, inputUsername);
			ps.setString(2,inputPassword);
			
			ResultSet rs = ps.executeQuery();
			
			if (rs.next()){
				out.print("<h3>Succesful Login!</h3>");
			}
			else{
				request.setAttribute("errorMessage", "Invalid username or password.");
 				RequestDispatcher rd = request.getRequestDispatcher("LoginPage.jsp");
	            rd.forward(request, response); 	
			}
			
			rs.close();
			ps.close();
		} else{
			out.print("<h3>Please re enter credentials</h3>");
		}

	
	}catch (Exception ex) {
        out.print("An error occurred: " + ex.getMessage());
    }
	%>
	<br>
	<form method="post" action="Logout.jsp">
    <input type="submit" value="Log Out">
</form>
</body>
</html>