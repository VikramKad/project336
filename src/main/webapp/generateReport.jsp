<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*, com.myapp.pkg.ApplicationDB"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<%@ page import="java.text.DecimalFormat"%>
<%
    // Retrieve category and type from the request
    String category = request.getParameter("category");  // Either "reservation" or "revenue"
    String type = request.getParameter("type");          // Either "transitLine" or "customerUsername"
    
    String query = "";
    if ("reservation".equals(category)) {
        if ("transitLine".equals(type)) {
            query = "SELECT line_id, COUNT(reservation_number) AS reservation_count FROM reservations GROUP BY line_id ORDER BY reservation_count DESC";
        } else if ("customerUsername".equals(type)) {
            query = "SELECT username, COUNT(reservation_number) AS reservation_count FROM reservations GROUP BY username ORDER BY reservation_count DESC";
        }
    } else if ("revenue".equals(category)) {
        if ("transitLine".equals(type)) {
            query = "SELECT line_id, SUM(total_fare) AS total_revenue FROM reservations GROUP BY line_id ORDER BY total_revenue DESC";
        } else if ("customerUsername".equals(type)) {
            query = "SELECT username, SUM(total_fare) AS total_revenue FROM reservations GROUP BY username ORDER BY total_revenue DESC";
        }
    }
    
    // Create a DecimalFormat instance to limit the number of decimals
    DecimalFormat df = new DecimalFormat("#.00");
    
    // Database connection setup
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
        
        // Prepare the result as a StringBuilder to return to the client
        StringBuilder result = new StringBuilder();
        
        // Process the result set
        while (rs.next()) {
            String identifier = "";
            String value = "";  // Use String to handle formatting of decimals
            
            if ("reservation".equals(category)) {
                identifier = rs.getString(1);  // line_id or username
                value = String.valueOf(rs.getInt(2));  // reservation_count as String
            } else if ("revenue".equals(category)) {
                identifier = rs.getString(1);  // line_id or username
                double revenue = rs.getDouble(2);  // total_revenue as double
                value = df.format(revenue);  // Format the revenue to 2 decimal places
            }
            
            result.append(identifier).append(": ").append(value).append("\n");
        }
        
        // Output the result (this will populate the ReportTextBox)
        out.print(result.toString());
        
    } catch (SQLException e) {
        out.print("Error: " + e.getMessage());
    } finally {
        try {
            // Close the resources
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            out.print("Error closing resources: " + e.getMessage());
        }
    }
%>
