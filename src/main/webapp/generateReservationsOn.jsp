<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.myapp.pkg.ApplicationDB"%>
<%
    // Retrieve the transit line and date from the request
    String transitLine = request.getParameter("transitLine");
    String date = request.getParameter("date");

    // Validate the inputs
    if (transitLine == null || date == null || transitLine.isEmpty() || date.isEmpty()) {
        out.print("Error: Transit line and date are required.");
        return;
    }

    String query = "SELECT DISTINCT r.username FROM reservations r JOIN train_schedules ts ON r.schedule_id = ts.schedule_id AND r.line_id = ts.line_id WHERE r.line_id = ? AND DATE(ts.arrival_datetime) = ?";

    // Establish the database connection and execute the query
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        // Get the database connection from ApplicationDB
        ApplicationDB db = new ApplicationDB();
        con = db.getConnection();

        // Prepare the SQL statement
        ps = con.prepareStatement(query);
        ps.setString(1, transitLine);
        ps.setString(2, date);  // Use the date directly (assumes date format is 'yyyy-MM-dd')

        // Execute the query
        rs = ps.executeQuery();

        // Output the list of usernames
        out.print("<h3>List of Users with Reservations:</h3>");
        out.print("<ul>");
        while (rs.next()) {
            String username = rs.getString("username");
            out.print("<li>" + username + "</li>");
        }
        out.print("</ul>");
    } catch (SQLException e) {
        out.print("Error: " + e.getMessage());
    } finally {
        try {
            // Close resources
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            out.print("Error closing resources: " + e.getMessage());
        }
    }
%>
