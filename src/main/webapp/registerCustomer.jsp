<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.myapp.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
    <title>Register Customer Account</title>
</head>
<body>
    <div class="form-container">
        <h2>Create New Account</h2>
        
        <%
        if (request.getMethod().equalsIgnoreCase("POST")) {
            try {
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                String firstName = request.getParameter("firstName");
                String lastName = request.getParameter("lastName");
                String email = request.getParameter("email");
                
                if (username == null || password == null || firstName == null || 
                    lastName == null || email == null || username.trim().isEmpty() || 
                    password.trim().isEmpty() || firstName.trim().isEmpty() || 
                    lastName.trim().isEmpty() || email.trim().isEmpty()) {
                    out.println("<div class='error'>All fields are required</div>");
                } else {
                    ApplicationDB db = new ApplicationDB();
                    Connection con = db.getConnection();
                    
                    String checkUser = "SELECT username FROM accounts WHERE username = ?";
                    PreparedStatement checkStmt = con.prepareStatement(checkUser);
                    checkStmt.setString(1, username);
                    ResultSet checkResult = checkStmt.executeQuery();
                    
                    if (checkResult.next()) {
                        out.println("<div class='error'>Username already exists!</div>");
                    } else {
                        con.setAutoCommit(false);
                        
                        try {
                            String insertAccount = "INSERT INTO accounts (username, password, first_name, last_name) VALUES (?, ?, ?, ?)";
                            PreparedStatement psAccount = con.prepareStatement(insertAccount);
                            psAccount.setString(1, username);
                            psAccount.setString(2, password);
                            psAccount.setString(3, firstName);
                            psAccount.setString(4, lastName);
                            psAccount.executeUpdate();
                            
                            String insertCustomer = "INSERT INTO customers (username, email) VALUES (?, ?)";
                            PreparedStatement psCustomer = con.prepareStatement(insertCustomer);
                            psCustomer.setString(1, username);
                            psCustomer.setString(2, email);
                            psCustomer.executeUpdate();
                            
                            con.commit();
                            response.sendRedirect("AccountCreated.jsp");
                            
                        } catch (SQLException e) {
                            con.rollback();
                            throw e;
                        } finally {
                            con.setAutoCommit(true);
                        }
                    }
                    con.close();
                }
            } catch (Exception e) {
                out.println("<div class='error'>Error: " + e.getMessage() + "</div>");
            }
        }
        %>
        
        <form method="post" action="registerCustomer.jsp">
            <div class="form-field">
                <label for="username">Username:</label>
                <input type="text" id="username" name="username" required>
            </div>
            
            <div class="form-field">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required>
            </div>
            
            <div class="form-field">
                <label for="firstName">First Name:</label>
                <input type="text" id="firstName" name="firstName" required>
            </div>
            
            <div class="form-field">
                <label for="lastName">Last Name:</label>
                <input type="text" id="lastName" name="lastName" required>
            </div>
            
            <div class="form-field">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" required>
            </div>
            
            <input type="submit" value="Create Account">
        </form>
        
        <p>Already have an account? <a href="loginPage.jsp">Login here</a></p>
    </div>
</body>
</html>