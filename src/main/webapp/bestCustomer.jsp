<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*, com.myapp.pkg.ApplicationDB"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<%
    // SQL query to get the username with the highest total of fares paid
    String query = "SELECT username, SUM(total_fare) AS total_fare_sum FROM reservations GROUP BY username ORDER BY total_fare_sum DESC LIMIT 1";
    
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        // Get the database connection
        ApplicationDB db = new ApplicationDB();
        con = db.getConnection();

        // Prepare the SQL query
        ps = con.prepareStatement(query);

        // Execute the query
        rs = ps.executeQuery();

        // Check if there is a result
        if (rs.next()) {
            String bestCustomer = rs.getString("username");
            double totalFareSum = rs.getDouble("total_fare_sum");
            out.print(bestCustomer + " with sum of " + totalFareSum);
        } else {
            out.print("No records found.");
        }
    } catch (SQLException e) {
        out.print("Error: " + e.getMessage());
    } finally {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            out.print("Error closing resources: " + e.getMessage());
        }
    }
%>
