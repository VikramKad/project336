<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.myapp.pkg.ApplicationDB"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
    // Retrieve parameters from the request
    String originalScheduleId = request.getParameter("original_schedule_id");
    String originalStationId = request.getParameter("original_station_id");
    String scheduleId = request.getParameter("schedule_id");
    String stationId = request.getParameter("station_id");
    String trainId = request.getParameter("train_id");
    String lineId = request.getParameter("line_id");
    String arrivalDatetime = request.getParameter("arrival_datetime");
    String departureDatetime = request.getParameter("departure_datetime");

    // Validate inputs
    if (originalScheduleId == null || originalStationId == null || originalScheduleId.isEmpty() || originalStationId.isEmpty()) {
        out.print("Error: Both original Schedule ID and Station ID are required.");
        return;
    }

    // Prepare SQL update query
    StringBuilder updateQuery = new StringBuilder("UPDATE train_schedules SET ");
    boolean first = true;

    if (scheduleId != null && !scheduleId.isEmpty()) {
        updateQuery.append("schedule_id = ?, ");
        first = false;
    }
    if (stationId != null && !stationId.isEmpty()) {
        updateQuery.append("station_id = ?, ");
        first = false;
    }
    if (trainId != null && !trainId.isEmpty()) {
        updateQuery.append("train_id = ?, ");
        first = false;
    }
    if (lineId != null && !lineId.isEmpty()) {
        updateQuery.append("line_id = ?, ");
        first = false;
    }
    if (arrivalDatetime != null && !arrivalDatetime.isEmpty()) {
        updateQuery.append("arrival_datetime = ?, ");
        first = false;
    }
    if (departureDatetime != null && !departureDatetime.isEmpty()) {
        updateQuery.append("departure_datetime = ?, ");
        first = false;
    }

    if (!first) {
        // Remove the last comma and space, and add WHERE clause
        updateQuery.delete(updateQuery.length() - 2, updateQuery.length());
        updateQuery.append(" WHERE schedule_id = ? AND station_id = ?");
    }

    // Now execute the query
    Connection con = null;
    PreparedStatement ps = null;

    try {
        ApplicationDB db = new ApplicationDB();
        con = db.getConnection();
        ps = con.prepareStatement(updateQuery.toString());

        // Set the dynamic values
        int paramIndex = 1;
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        // Set the parameters if they are provided
        if (scheduleId != null && !scheduleId.isEmpty()) ps.setString(paramIndex++, scheduleId);
        if (stationId != null && !stationId.isEmpty()) ps.setString(paramIndex++, stationId);
        if (trainId != null && !trainId.isEmpty()) ps.setString(paramIndex++, trainId);
        if (lineId != null && !lineId.isEmpty()) ps.setString(paramIndex++, lineId);
        
        // Set formatted arrival datetime if available
        if (arrivalDatetime != null && !arrivalDatetime.isEmpty()) {
            try {
                java.util.Date arrivalDate = dateFormat.parse(arrivalDatetime);
                ps.setTimestamp(paramIndex++, new java.sql.Timestamp(arrivalDate.getTime()));
            } catch (Exception e) {
                out.print("Invalid arrival datetime format.");
                return;
            }
        }

        // Set formatted departure datetime if available
        if (departureDatetime != null && !departureDatetime.isEmpty()) {
            try {
                java.util.Date departureDate = dateFormat.parse(departureDatetime);
                ps.setTimestamp(paramIndex++, new java.sql.Timestamp(departureDate.getTime()));
            } catch (Exception e) {
                out.print("Invalid departure datetime format.");
                return;
            }
        }

        // Set the original schedule ID and station ID for WHERE clause
        ps.setString(paramIndex++, originalScheduleId);
        ps.setString(paramIndex++, originalStationId);

        // Execute the update
        int rowsUpdated = ps.executeUpdate();
        if (rowsUpdated > 0) {
            out.print("Schedule updated successfully.");
        } else {
            out.print("No matching schedule found or update failed.");
        }
    } catch (SQLException e) {
        out.print("SQL Error: " + e.getMessage());
    } finally {
        try {
            if (ps != null) ps.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            out.print("Error closing resources: " + e.getMessage());
        }
    }
%>
