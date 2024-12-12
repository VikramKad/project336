<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*, com.myapp.pkg.ApplicationDB"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<%
    String username = request.getParameter("username");

    if (username != null && !username.isEmpty()) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            // Get the database connection
            ApplicationDB db = new ApplicationDB();
            con = db.getConnection();

            // SQL query to delete the representative
            String query = "DELETE FROM accounts WHERE username = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, username);

            // Execute the delete query
            int rowsAffected = ps.executeUpdate();

            // Check if any row was deleted
            if (rowsAffected > 0) {
                out.print("Representative with username " + username + " has been deleted.");
            } else {
                out.print("No representative found with username " + username);
            }
        } catch (SQLException e) {
            out.print("Error: " + e.getMessage());
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                out.print("Error closing resources: " + e.getMessage());
            }
        }
    } else {
        out.print("Username parameter is missing.");
    }
%>
