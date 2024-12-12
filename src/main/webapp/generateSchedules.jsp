<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.myapp.pkg.ApplicationDB, java.time.format.DateTimeFormatter"%>
<%
String stationType = request.getParameter("stationType");
String stationId = request.getParameter("stationId");

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;
ResultSet relatedRs = null;

try {
    // Establish database connection
    ApplicationDB db = new ApplicationDB();
    con = db.getConnection();

    // Prepare the header query based on station type
    String headerQuery = "";
    String relatedStationsQuery = "";

    if ("origin".equals(stationType)) {
        headerQuery = "SELECT station_id, departure_datetime, schedule_id, train_id, line_id " +
                      "FROM train_schedules " +
                      "WHERE station_id = ? " +
                      "AND departure_datetime != '9999-12-31 23:59:59'";
        
        relatedStationsQuery = "SELECT DISTINCT ts.station_id, ts.arrival_datetime " +
                                "FROM train_schedules ts " +
                                "WHERE ts.schedule_id = ? " +
                                "AND ts.station_id != ? " +
                                "AND ts.arrival_datetime > ? " +
                                "AND ts.arrival_datetime != '9999-12-31 23:59:59' " +
                                "ORDER BY ts.arrival_datetime";
    } else if ("destination".equals(stationType)) {
        headerQuery = "SELECT station_id, arrival_datetime, schedule_id, train_id, line_id " +
                      "FROM train_schedules " +
                      "WHERE station_id = ? " +
                      "AND arrival_datetime != '0000-01-01 00:00:00'";
        
        relatedStationsQuery = "SELECT DISTINCT ts.station_id, ts.departure_datetime " +
                                "FROM train_schedules ts " +
                                "WHERE ts.schedule_id = ? " +
                                "AND ts.station_id != ? " +
                                "AND ts.departure_datetime < ? " +
                                "AND ts.departure_datetime != '0000-01-01 00:00:00' " +
                                "ORDER BY ts.departure_datetime";
    } else {
        out.println("<p>Invalid station type.</p>");
        return;
    }

    // Prepare and execute header query
    ps = con.prepareStatement(headerQuery);
    ps.setString(1, stationId);
    rs = ps.executeQuery();

    // Counter to track number of results
    int resultCount = 0;

    // Iterate through each result for the station
    while (rs.next()) {
        String scheduleId = rs.getString("schedule_id");
        String headerTime = "origin".equals(stationType) ? 
            rs.getString("departure_datetime") : 
            rs.getString("arrival_datetime");

        // Prepare and execute related stations query
        PreparedStatement relatedPs = con.prepareStatement(relatedStationsQuery);
        relatedPs.setString(1, scheduleId);
        relatedPs.setString(2, stationId);
        relatedPs.setString(3, headerTime);
        relatedRs = relatedPs.executeQuery();

        // Check if there are any related stations
        if (relatedRs.isBeforeFirst()) {
            resultCount++;
            
            // Prepare output
            out.println("<div class='schedule-result'>");
            out.println("<h3>Schedule Result " + resultCount + "</h3>");
            out.println("<table border='1'>");
            out.println("<thead>");
            out.println("<tr><th colspan='2'>Station Details</th></tr>");
            out.println("</thead>");
            out.println("<tbody>");

            // Station ID
            out.println("<tr>");
            out.println("<td>Station ID:</td>");
            out.println("<td>" + rs.getString("station_id") + "</td>");
            out.println("</tr>");

            // Train ID
            out.println("<tr>");
            out.println("<td>Train ID:</td>");
            out.println("<td>" + rs.getString("train_id") + "</td>");
            out.println("</tr>");

            // Line ID
            out.println("<tr>");
            out.println("<td>Line ID:</td>");
            out.println("<td>" + rs.getString("line_id") + "</td>");
            out.println("</tr>");

            // Time details based on station type
            out.println("<tr>");
            out.println("<td>" + ("origin".equals(stationType) ? "Departure" : "Arrival") + " Time:</td>");
            out.println("<td>" + headerTime + "</td>");
            out.println("</tr>");

            // Add table header for related stations
            out.println("<tr>");
            out.println("<th>Related Stations</th>");
            out.println("<th>" + ("origin".equals(stationType) ? "Arrival" : "Departure") + " Time</th>");
            out.println("</tr>");

            // Populate related stations
            while (relatedRs.next()) {
                out.println("<tr>");
                out.println("<td>" + relatedRs.getString(1) + "</td>");
                out.println("<td>" + relatedRs.getString(2) + "</td>");
                out.println("</tr>");
            }

            out.println("</tbody>");
            out.println("</table>");
            out.println("</div>");

            // Close related stations resources
            relatedRs.close();
            relatedPs.close();
        }
    }

    // If no results found
    if (resultCount == 0) {
        out.println("<p>No schedules found for the given station</p>");
    }

} catch (SQLException e) {
    out.println("<p>Database error: " + e.getMessage() + "</p>");
    e.printStackTrace();
} finally {
    // Close resources
    try {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    } catch (SQLException e) {
        out.println("<p>Error closing database resources: " + e.getMessage() + "</p>");
    }
}
%>