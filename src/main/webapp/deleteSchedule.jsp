<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.myapp.pkg.ApplicationDB"%>
<%
    // Retrieve schedule_id and station_id from request parameters
    String scheduleId = request.getParameter("original_schedule_id");  // Match parameter name from JS
    String stationId = request.getParameter("original_station_id");    // Match parameter name from JS

    // Validate the input parameters
    if (scheduleId == null || stationId == null || scheduleId.isEmpty() || stationId.isEmpty()) {
        out.print("Error: Missing or invalid schedule_id or station_id.");
        return;
    }

    // Establish database connection and delete the schedule
    Connection con = null;
    PreparedStatement ps = null;

    try {
        // Get the database connection from ApplicationDB
        ApplicationDB db = new ApplicationDB();
        con = db.getConnection();

        // SQL query to delete the record from train_schedules based on schedule_id and station_id
        String deleteQuery = "DELETE FROM train_schedules WHERE schedule_id = ? AND station_id = ?";
        
        // Prepare the SQL statement
        ps = con.prepareStatement(deleteQuery);
        ps.setString(1, scheduleId);
        ps.setString(2, stationId);
        
        // Execute the delete operation
        int rowsAffected = ps.executeUpdate();
        
        if (rowsAffected > 0) {
            out.print("Schedule with Schedule ID: " + scheduleId + " and Station ID: " + stationId + " has been deleted.");
        } else {
            out.print("No schedule found with the given Schedule ID and Station ID.");
        }
        
    } catch (SQLException e) {
        out.print("Error: " + e.getMessage());
    } finally {
        try {
            // Close database resources
            if (ps != null) ps.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            out.print("Error closing resources: " + e.getMessage());
        }
    }
%>
