<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*, com.myapp.pkg.ApplicationDB"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<%
    try {
        // Get form parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String lastName = request.getParameter("last_name");
        String firstName = request.getParameter("first_name");
        String ssn = request.getParameter("ssn");

        // Check if the data exists
        if (username != null && password != null && lastName != null && firstName != null && ssn != null) {
            // Database connection setup
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            
            // SQL query to insert the new representative
            String query = "INSERT INTO accounts (username, password, last_name, first_name) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, lastName);
            ps.setString(4, firstName);

            String query2 = "INSERT INTO representatives VALUES (?,?)";
            PreparedStatement ps2 = con.prepareStatement(query2);
            ps2.setString(1,username);
            ps2.setString(2,ssn);
            
            // Execute the insert
            int rowsAffected = ps.executeUpdate();
            ps2.executeUpdate();

            if (rowsAffected > 0) {
                out.print("Representative added successfully.");
            } else {
                out.print("Error adding representative.");
            }

            ps.close();
            db.closeConnection(con);
        } else {
            out.print("Missing fields.");
        }
    } catch (Exception e) {
        out.print("Error: " + e.getMessage());
    }
%>
