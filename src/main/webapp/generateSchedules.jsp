<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.myapp.pkg.ApplicationDB, java.time.format.DateTimeFormatter"%>
<%
String stationType = request.getParameter("stationType");
String stationId = request.getParameter("stationId");

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;
ResultSet headerRs = null;

try {
    // Establish database connection
    ApplicationDB db = new ApplicationDB();
    con = db.getConnection();

    // Prepare the header query based on station type
    String headerQuery = "";
    String relatedStationsQuery = "";

    if ("origin".equals(stationType)) {
        headerQuery = "SELECT station_id, departure_datetime, schedule_id " +
                      "FROM train_schedules " +
                      "WHERE station_id = ? " +
                      "ORDER BY departure_datetime LIMIT 1";
        
        relatedStationsQuery = "SELECT DISTINCT ts.station_id, ts.arrival_datetime " +
                                "FROM train_schedules ts " +
                                "JOIN train_schedules header ON ts.schedule_id = header.schedule_id " +
                                "WHERE header.station_id = ? " +
                                "AND ts.arrival_datetime > header.departure_datetime " +
                                "ORDER BY ts.arrival_datetime";
    } else if ("destination".equals(stationType)) {
        headerQuery = "SELECT station_id, arrival_datetime, schedule_id " +
                      "FROM train_schedules " +
                      "WHERE station_id = ? " +
                      "ORDER BY arrival_datetime LIMIT 1";
        
        relatedStationsQuery = "SELECT DISTINCT ts.station_id, ts.departure_datetime " +
                                "FROM train_schedules ts " +
                                "JOIN train_schedules header ON ts.schedule_id = header.schedule_id " +
                                "WHERE header.station_id = ? " +
                                "AND ts.departure_datetime < header.arrival_datetime " +
                                "ORDER BY ts.departure_datetime";
    } else {
        out.println("<p>Invalid station type.</p>");
        return;
    }

    // Prepare and execute header query
    ps = con.prepareStatement(headerQuery);
    ps.setString(1, stationId);
    headerRs = ps.executeQuery();

    // Render the entire output as an HTML table
    out.println("<table border='1'>");
    out.println("<thead>");
    out.println("<tr><th colspan='2'>Station Details</th></tr>");
    out.println("</thead>");
    out.println("<tbody>");

    // Render header information
    if (headerRs.next()) {
        out.println("<tr>");
        out.println("<td>Station ID:</td>");
        out.println("<td>" + headerRs.getString("station_id") + "</td>");
        out.println("</tr>");
        
        out.println("<tr>");
        out.println("<td>" + ("origin".equals(stationType) ? "Departure" : "Arrival") + " Time:</td>");
        out.println("<td>" + headerRs.getString("origin".equals(stationType) ? "departure_datetime" : "arrival_datetime") + "</td>");
        out.println("</tr>");

        // Prepare and execute related stations query
        ps = con.prepareStatement(relatedStationsQuery);
        ps.setString(1, stationId);
        rs = ps.executeQuery();

        // Add table header for related stations
        out.println("<tr>");
        out.println("<th>Related Stations</th>");
        out.println("<th>" + ("origin".equals(stationType) ? "Arrival" : "Departure") + " Time</th>");
        out.println("</tr>");

        // Populate related stations
        boolean hasRelatedStations = false;
        while (rs.next()) {
            hasRelatedStations = true;
            out.println("<tr>");
            out.println("<td>" + rs.getString(1) + "</td>");
            out.println("<td>" + rs.getString(2) + "</td>");
            out.println("</tr>");
        }

        // If no related stations found
        if (!hasRelatedStations) {
            out.println("<tr>");
            out.println("<td colspan='2'>No related stations found</td>");
            out.println("</tr>");
        }
    } else {
        out.println("<tr>");
        out.println("<td colspan='2'>No schedules found for the given station</td>");
        out.println("</tr>");
    }

    out.println("</tbody>");
    out.println("</table>");

} catch (SQLException e) {
    out.println("<p>Database error: " + e.getMessage() + "</p>");
    e.printStackTrace();
} finally {
    // Close resources
    try {
        if (rs != null) rs.close();
        if (headerRs != null) headerRs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    } catch (SQLException e) {
        out.println("<p>Error closing database resources: " + e.getMessage() + "</p>");
    }
}
%>