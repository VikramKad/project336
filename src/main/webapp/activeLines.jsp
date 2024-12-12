<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.myapp.pkg.ApplicationDB"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<%
    // SQL query to get the top 5 lines with the most reservations
    String query = "SELECT line_id, COUNT(line_id) AS reservation_count " +
                   "FROM reservations " +
                   "GROUP BY line_id " +
                   "ORDER BY reservation_count DESC " +
                   "LIMIT 5";
    
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

        // Collect the top 5 active lines and their counts
        StringBuilder result = new StringBuilder();

        while (rs.next()) {
            String lineId = rs.getString("line_id");
            int count = rs.getInt("reservation_count");
            result.append("Line ID: " + lineId + " (Reservations: " + count + ") ");
        }

        // Return the result
        out.print(result.toString().trim());  // Use trim to clean up any extra whitespace
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
