<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.myapp.pkg.ApplicationDB"%>
<%@ page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Train Schedules</title>
<script>
    // Function to delete a schedule based on schedule_id and station_id
    function deleteSchedule() {
        var scheduleId = document.getElementById("original_schedule_id").value;
        var stationId = document.getElementById("original_station_id").value;

        if (scheduleId === "" || stationId === "") {
            alert("Please provide both Schedule ID and Station ID.");
            return;
        }

        var xhr = new XMLHttpRequest();
        xhr.open("POST", "deleteSchedule.jsp", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

        var params = "original_schedule_id=" + encodeURIComponent(scheduleId) + "&original_station_id=" + encodeURIComponent(stationId);
        xhr.send(params);

        xhr.onreadystatechange = function() {
            if (xhr.readyState == 4 && xhr.status == 200) {
                var response = xhr.responseText;
                alert(response);  // Show result of the deletion
                location.reload();  // Reload to reflect changes
            }
        };
    }
    
    // Function to edit a schedule
    function editSchedule() {
        var originalScheduleId = document.getElementById("original_schedule_id").value;
        var originalStationId = document.getElementById("original_station_id").value;
        var scheduleId = document.getElementById("edit_schedule_id").value;
        var stationId = document.getElementById("edit_station_id").value;
        var trainId = document.getElementById("edit_train_id").value;
        var lineId = document.getElementById("edit_line_id").value;
        var arrivalDatetime = document.getElementById("edit_arrival_datetime").value;
        var departureDatetime = document.getElementById("edit_departure_datetime").value;

        if (originalScheduleId === "" || originalStationId === "") {
            alert("Please provide both Schedule ID and Station ID to identify which to update.");
            return;
        }

        var xhr = new XMLHttpRequest();
        xhr.open("POST", "editSchedule.jsp", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

        var params = "original_schedule_id=" + encodeURIComponent(originalScheduleId) + 
                     "&original_station_id=" + encodeURIComponent(originalStationId) + 
                     "&schedule_id=" + encodeURIComponent(scheduleId) + 
                     "&station_id=" + encodeURIComponent(stationId) + 
                     "&train_id=" + encodeURIComponent(trainId) + 
                     "&line_id=" + encodeURIComponent(lineId) + 
                     "&arrival_datetime=" + encodeURIComponent(arrivalDatetime) + 
                     "&departure_datetime=" + encodeURIComponent(departureDatetime);

        xhr.send(params);

        xhr.onreadystatechange = function() {
            if (xhr.readyState == 4 && xhr.status == 200) {
                var response = xhr.responseText;
                alert(response);  // Show success or error message
                location.reload();  // Reload to reflect changes
            }
        };
    }
</script>
</head>
<body>

<!-- Button to navigate to the representative home -->
<button onClick="window.location.href='RepresentativeHome.jsp'">Return to representative home</button>

<br><br>

<!-- Input fields to enter schedule_id and station_id -->
<input type="text" id="original_schedule_id" name="original_schedule_id" placeholder="Enter Schedule ID">
<input type="text" id="original_station_id" name="original_station_id" placeholder="Enter Station ID">
<button type="button" onclick="deleteSchedule()">Delete Schedule</button>
<button type="button" onclick="editSchedule()">Edit Schedule</button>

<br><br>

<!-- Input fields to edit schedule_id, train_id, line_id, station_id, arrival_datetime, and departure_dateime -->
<input type="text" id="edit_schedule_id" name="edit_schedule_id" placeholder="Enter New Schedule ID">
<input type="text" id="edit_train_id" name="edit_train_id" placeholder="Enter New Train ID">
<input type="text" id="edit_line_id" name="edit_line_id" placeholder="Enter New Line ID">
<input type="text" id="edit_station_id" name="edit_station_id" placeholder="Enter New Station ID">
<input type="text" id="edit_arrival_datetime" name="edit_arrival_datetime" placeholder="Enter New Arrival Datetime">
<input type="text" id="edit_departure_datetime" name="edit_departure_datetime" placeholder="Enter New Departure Datetime">

<br><br>

<h2>Train Schedules</h2>

<!-- Table to display train schedule data -->
<table border="1">
    <thead>
        <tr>
            <th>Schedule ID</th>
            <th>Train ID</th>
            <th>Line ID</th>
            <th>Station ID</th>
            <th>Arrival DateTime</th>
            <th>Departure DateTime</th>
        </tr>
    </thead>
    <tbody>
        <% 
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            String query = "SELECT schedule_id, train_id, line_id, station_id, arrival_datetime, departure_datetime FROM train_schedules";
            
            try {
                ApplicationDB db = new ApplicationDB();
                con = db.getConnection();
                ps = con.prepareStatement(query);
                rs = ps.executeQuery();
                
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                
                while (rs.next()) {
                    String scheduleId = rs.getString("schedule_id");
                    String trainId = rs.getString("train_id");
                    String lineId = rs.getString("line_id");
                    String stationId = rs.getString("station_id");
                    java.sql.Timestamp arrivalDateTime = rs.getTimestamp("arrival_datetime");
                    java.sql.Timestamp departureDateTime = rs.getTimestamp("departure_datetime");

                    String formattedArrival = (arrivalDateTime != null) ? dateFormat.format(arrivalDateTime) : "N/A";
                    String formattedDeparture = (departureDateTime != null) ? dateFormat.format(departureDateTime) : "N/A";
        %>
        <tr>
            <td><%= scheduleId %></td>
            <td><%= trainId %></td>
            <td><%= lineId %></td>
            <td><%= stationId %></td>
            <td><%= formattedArrival %></td>
            <td><%= formattedDeparture %></td>
        </tr>
        <% 
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
    </tbody>
</table>

</body>
</html>
