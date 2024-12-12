<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.myapp.pkg.ApplicationDB"%>
<%
    // Database connection and query for monthly sales sum
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    
    try {
        // Get the database connection
        ApplicationDB db = new ApplicationDB();
        con = db.getConnection();

        // Query to calculate the sum of fares per month and format the date correctly
        String query = "SELECT DATE_FORMAT(made_datetime, '%Y-%m') AS month_year, SUM(total_fare) AS total_fare " +
                       "FROM reservations " +
                       "GROUP BY month_year " +
                       "ORDER BY month_year";

        ps = con.prepareStatement(query);
        rs = ps.executeQuery();
        
        StringBuilder result = new StringBuilder();
        result.append("YYYY-MM       Total Fare\n");  // Header
        
        // Loop through the result set and format the response
        while (rs.next()) {
            String monthYear = rs.getString("month_year");
            double totalFare = rs.getDouble("total_fare");
            result.append(monthYear).append("    ").append(totalFare).append("\n");
        }
        
        // Output the result to be used in the front-end
        out.print(result.toString());
    } catch (SQLException e) {
        out.print("Error fetching monthly sales: " + e.getMessage());
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
