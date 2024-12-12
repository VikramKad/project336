<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.myapp.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View Reservations</title>
</head>
<body>
<%
String username = (String) session.getAttribute("username");
out.print("<p>Welcome, " + username + "</p>");
%>
<br>
Customer Home
<br>

<%
ApplicationDB db = new ApplicationDB();
Connection con = db.getConnection();
Statement stmt = con.createStatement();

// Modified query to get only the first stop of each schedule
String reservationQuery =
    "SELECT r.reservation_number, r.made_datetime, " +
    "s.name AS origin_name, r.total_fare, " +
    "ts.departure_datetime " +
    "FROM reservations r " +
    "JOIN stations s ON r.origin_station_id = s.station_id " +
    "JOIN train_schedules ts ON r.schedule_id = ts.schedule_id " +
    "WHERE r.username = ? " +
    "AND ts.station_id = r.origin_station_id " +
    "ORDER BY r.made_datetime DESC";

try {
    PreparedStatement pstmt = con.prepareStatement(reservationQuery);
    pstmt.setString(1, username);
    ResultSet rs = pstmt.executeQuery();
%>

<script>
function confirmCancel(reservationNumber) {
    if (confirm("Are you sure you want to cancel this reservation?")) {
        document.getElementById("cancelForm" + reservationNumber).submit();
    }
}
</script>

<div class="container mt-4">
    <h2>Your Reservations</h2>
    <table class="table table-striped">
        <thead>
            <tr>
                <th>Reservation #</th>
                <th>Date Made</th>
                <th>Departure Date</th>
                <th>Departure Time</th>
                <th>Origin Station</th>
                <th>Total Fare</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <% while (rs.next()) { %>
                <tr>
                    <td><%= rs.getInt("reservation_number") %></td>
                    <td><%= rs.getTimestamp("made_datetime") %></td>
                    <td><%= rs.getTimestamp("departure_datetime").toLocalDateTime().toLocalDate() %></td>
                    <td><%= rs.getTimestamp("departure_datetime").toLocalDateTime().toLocalTime() %></td>
                    <td><%= rs.getString("origin_name") %></td>
                    <td>$<%= String.format("%.2f", rs.getFloat("total_fare")) %></td>
                    <td>
                        <form id="cancelForm<%= rs.getInt("reservation_number") %>"
                              action="CancelReservation.jsp" method="post" style="display: inline;">
                            <input type="hidden" name="reservation_number"
                                   value="<%= rs.getInt("reservation_number") %>">
                            <button type="button" class="btn btn-danger btn-sm"
                                    onclick="confirmCancel(<%= rs.getInt("reservation_number") %>)">
                                Cancel
                            </button>
                        </form>
                    </td>
                </tr>
            <% } %>
        </tbody>
    </table>
</div>

<%
    rs.close();
    stmt.close();
} catch (SQLException e) {
    out.println("Error: " + e.getMessage());
}
%>

<button onClick="window.location.href='CustomerHome.jsp'">Back to Home</button>

</body>
</html>