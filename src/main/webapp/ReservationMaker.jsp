<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.myapp.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>    
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<% 
	String username = (String) session.getAttribute("username");
	out.print("<p>Thank you for training with us, " + username + "</p>");
	%>
	
	<%
    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();
    Statement stmt = con.createStatement();

    String lineQuery = "SELECT DISTINCT line_id, line_name FROM transit_lines ORDER BY line_id";
    ResultSet lines = stmt.executeQuery(lineQuery);

    String action = request.getParameter("action");
    if (action == null) action = "step1";
    %>

    <% if ("step1".equals(action)) { %>
        <form method="post">
            <label for="line">Select Line:</label>
            <select name="line" id="line" required>
                <% while (lines.next()) { %>
                    <option value="<%= lines.getString("line_id") %>"><%= lines.getString("line_name") %></option>
                <% } %>
            </select>
            <br><br>

            <label for="date">Select Date:</label>
            <input type="date" id="date" name="date" required>
            <br><br>

            <input type="hidden" name="action" value="step2">
            <input type="submit" value="Next">
        </form>
    <% } %>

<% if ("step2".equals(action)) {
String line = request.getParameter("line");
String date = request.getParameter("date");

// First query stays the same to get stations on the line
String stationQuery = "SELECT t.station_id, t.stop_number, s.name " +
                     "FROM transit_lines t " +
                     "JOIN stations s ON t.station_id = s.station_id " +
                     "WHERE t.line_id = ? " +
                     "ORDER BY t.stop_number";
                     
PreparedStatement ps = con.prepareStatement(stationQuery);
ps.setString(1, line);
ResultSet stations = ps.executeQuery();
%>
<form method="post">
<label for="origin">Select Origin Station:</label>
<select name="origin" id="origin" required>
<% while (stations.next()) { %>
<option value="<%= stations.getString("station_id") %>"><%= stations.getString("name") %></option>
<% } %>
</select>
<br><br>

<label for="destination">Select Destination Station:</label>
<select name="destination" id="destination" required>
<% stations.beforeFirst(); %>
<% while (stations.next()) { %>
<option value="<%= stations.getString("station_id") %>"><%= stations.getString("name") %></option>
<% } %>
</select>
<br><br>

<input type="hidden" name="action" value="step3">
<input type="hidden" name="line" value="<%= line %>">
<input type="hidden" name="date" value="<%= date %>">
<input type="submit" value="Next">
</form>
<% } %>

	<% if ("step3".equals(action)) {	
	    String line = request.getParameter("line");
	    String date = request.getParameter("date");
	    String origin = request.getParameter("origin");
	
	    String scheduleQuery = "SELECT schedule_id, departure_datetime FROM train_schedules WHERE line_id = ? AND station_id = ? AND DATE(departure_datetime) = ?";
	    PreparedStatement ps = con.prepareStatement(scheduleQuery);
	    ps.setString(1, line);
	    ps.setString(2, origin);
	    ps.setString(3, date);
	    ResultSet schedules = ps.executeQuery();
	
	    if (!schedules.next()) {
	        String availableDatesQuery = "SELECT DISTINCT DATE(departure_datetime) AS available_date FROM train_schedules WHERE line_id = ? AND station_id = ? AND DATE(departure_datetime) != '9999-12-31'ORDER BY available_date;";
	        PreparedStatement psAvailableDates = con.prepareStatement(availableDatesQuery);
	        psAvailableDates.setString(1, line);
	        psAvailableDates.setString(2, origin);
	        ResultSet availableDates = psAvailableDates.executeQuery();
	%>
	        <p>No trains are scheduled on the selected date: <%= date %>.</p>
	        <p>Please select one of the following available dates:</p>
	        <ul>
	        <% while (availableDates.next()) { %>
	            <li><%= availableDates.getString("available_date") %></li>
	        <% } %>
	        
	        </ul>
	        <form method="post">
	            <label for="date">Select a different date:</label>
	            <input type="date" id="date" name="date" required>
	            <input type="hidden" name="action" value="step2">
	            <input type="hidden" name="line" value="<%= line %>">
	            <input type="hidden" name="origin" value="<%= origin %>">
	            <input type="submit" value="Next">
	        </form>
	<% 
	    } else {
	%>

		        <form method="post">
		            <label for="schedule">Select Departure Time:</label>
		            <select name="schedule" id="schedule" required>
		                <% 
		                do { 
		                %>
		                    <option value="<%= schedules.getString("schedule_id") %>">
		                        <%= schedules.getString("departure_datetime") %>
		                    </option>
		                <% } while (schedules.next()); %>
		            </select>
		            <input type="hidden" name="action" value="step4">
		            <input type="hidden" name="line" value="<%= line %>">
		            <input type="hidden" name="date" value="<%= date %>">
		            <input type="hidden" name="origin" value="<%= origin %>">
		            <input type="hidden" name="destination" value="<%= request.getParameter("destination") %>">
		            
		            <input type="submit" value="Next">
		        </form>
	
	
	<% } 
	}
	%>
	
	<% if ("step4".equals(action)) { %>
	<form method="post">
	    <label>Round Trip:</label>
	    <select name="round_trip">
	        <option value="0">No</option>
	        <option value="1">Yes</option>
	    </select><br>
	
	    <label>Senior:</label>
	    <select name="senior">
	        <option value="0">No</option>
	        <option value="1">Yes</option>
	    </select><br>
	
	    <label>Child:</label>
	    <select name="child">
	        <option value="0">No</option>
	        <option value="1">Yes</option>
	    </select><br>
	
	    <label>Disabled:</label>
	    <select name="disabled">
	        <option value="0">No</option>
	        <option value="1">Yes</option>
	    </select><br>
	
	   <input type="hidden" name="schedule_id" value="<%= request.getParameter("schedule") %>">

	    <input type="hidden" name="origin_station_id" value="<%= request.getParameter("origin") %>">
	    <input type="hidden" name="destination_station_id" value="<%= request.getParameter("destination") %>">
	
	    <button type="submit" name="action" value="step5">Calculate Fare</button><br>
	</form>
	
	<% } %>
	
	
	<% if ("step5".equals(action)) {
		String origin = request.getParameter("origin_station_id");
		String destination = request.getParameter("destination_station_id");
		boolean isRoundTrip = "1".equals(request.getParameter("round_trip"));
		boolean isSenior = "1".equals(request.getParameter("senior"));
		boolean isChild = "1".equals(request.getParameter("child"));
		boolean isDisabled = "1".equals(request.getParameter("disabled"));
		int stopsTraveled = 0;
		String schedID = request.getParameter("schedule_id");
		
		String lineID = null;
	    
	    String lq = "SELECT line_id FROM train_schedules WHERE schedule_id = ?";
        PreparedStatement lineStmt = con.prepareStatement(lq);
        lineStmt.setString(1, schedID);
        ResultSet rs = lineStmt.executeQuery();
        
        if (rs.next()) {
            lineID = rs.getString("line_id"); 
        }
    //    out.println(lineID);
        
        int totalStops = 0;
        String stopQuery = "SELECT MAX(stop_number) AS total_stops FROM transit_lines WHERE line_id = ?";
        PreparedStatement stopStmt = con.prepareStatement(stopQuery);
        stopStmt.setString(1, lineID);
        ResultSet stopRs = stopStmt.executeQuery();
        if (stopRs.next()) {
            totalStops = stopRs.getInt("total_stops"); 
        }
        
        
      // out.println(totalStops);

		if (origin != null && destination != null && !origin.isEmpty() && !destination.isEmpty()) {
		    try {
		        stopsTraveled = Math.abs(Integer.parseInt(destination) - Integer.parseInt(origin));
		    } catch (NumberFormatException e) {
		        request.setAttribute("errorMessage", "Error: Invalid origin or destination input.");
		    }
		} else {
		    request.setAttribute("errorMessage", "Error: Missing origin or destination.");
		}
	

		totalStops = totalStops - 1; 
		float baseFare = 10.0f; 
		float fare = baseFare * ((float) stopsTraveled / totalStops);

		if (isChild) {
		    fare *= 0.75; 
		} else if (isSenior) {
		    fare *= 0.65;
		}
		
		if (isDisabled) {
		    fare *= 0.50; 
		}

		if (isRoundTrip) {
		    fare *= 2; 
		}
		%>
	
		<% if (request.getAttribute("errorMessage") != null) { %>
		    <p style="color: red;"><%= request.getAttribute("errorMessage") %></p>
		<% } %>
	
		<form action="ReservationMaker.jsp" method="post">
		    <label>Fare: </label>
		    <input type="text" name="fare" value="<%= String.format("%.2f", fare) %>" readonly><br>
	
		    <input type="hidden" name="action" value="finalize">
		    <input type="hidden" name="line" value="<%= request.getParameter("line") %>">
		    <input type="hidden" name="date" value="<%= request.getParameter("date") %>">
		    <input type="hidden" name="origin" value="<%= origin %>">
		    <input type="hidden" name="destination" value="<%= destination %>">
		    <input type="hidden" name="schedule_id" value="<%= request.getParameter("schedule_id") %>">
		    
		    
	
	
	        <input type="hidden" name="round_trip" value="<%= "1".equals(request.getParameter("round_trip")) %>">
	        <input type="hidden" name="senior" value="<%= "1".equals(request.getParameter("senior")) %>">
	        <input type="hidden" name="child" value="<%= isChild %>">
	        <input type="hidden" name="disabled" value="<%= isDisabled %>">
	        <input type="hidden" name="lineID" value="<%= lineID %>">
		    <button type="submit" name="action" value="finalize">Finalize Reservation</button>
		</form>
		<% } %>


   <% 
	if ("finalize".equals(action)) { 

	    String roundTrip = request.getParameter("round_trip");
	    String senior = request.getParameter("senior");
	    String child = request.getParameter("child");
	    String disabled = request.getParameter("disabled");
	    String fare = request.getParameter("fare");
	    String scheduleId = request.getParameter("schedule_id");
	    String originStation = request.getParameter("origin");
	    String destinationStation = request.getParameter("destination");
	    
	    String lineID = request.getParameter("lineID");
	    
	
	    int isRoundTrip = "true".equalsIgnoreCase(roundTrip) ? 1 : 0;
	    int isSenior = "true".equalsIgnoreCase(senior) ? 1 : 0;
	    int isChild = "true".equalsIgnoreCase(child) ? 1 : 0;
	    int isDisabled = "true".equalsIgnoreCase(disabled) ? 1 : 0;
	    
/* 	    out.println("<p>Round Trip: " + isRoundTrip + "</p>");
	    out.println("<p>Senior: " + isSenior + "</p>");
	    out.println("<p>Child: " + isChild + "</p>");
	    out.println("<p>Disabled: " + isDisabled + "</p>");
	    out.println("<p>Fare: " + fare + "</p>");
	    out.println("<p>Schedule ID: " + scheduleId + "</p>");
	    out.println("<p>Line ID: " + lineID + "</p>");
	    out.println("<p>Origin Station: " + originStation + "</p>");
	    out.println("<p>Destination Station: " + destinationStation + "</p>"); */
	    
	    

	    try {
	    
	    	String query = "INSERT INTO reservations (made_datetime, username, round_trip, schedule_id, line_id, origin_station_id, destination_station_id, passenger_senior, passenger_child, passenger_disabled, total_fare) VALUES (NOW(), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	        PreparedStatement pstmt = con.prepareStatement(query);
	        
	        pstmt.setString(1, username); // Username
	        pstmt.setInt(2, isRoundTrip); // Round trip
	        pstmt.setString(3, scheduleId); // Schedule ID
	        pstmt.setString(4, lineID);
	        pstmt.setString(5, originStation); // Origin station
	        pstmt.setString(6, destinationStation); // Destination station
	        pstmt.setInt(7, isSenior); // Senior
	        pstmt.setInt(8, isChild); // Child
	        pstmt.setInt(9, isDisabled); // Disabled
	        pstmt.setFloat(10, Float.parseFloat(fare)); // Fare

	        pstmt.executeUpdate();

	        out.println("Reservation finalized successfully!");
			
	       %>
	       <br>
	       <button onClick="window.location.href='CustomerHome.jsp'">Go back to Homepage</button>
	       
	       <%
	        
	    } catch (SQLException e) {
	        out.println("Error finalizing reservation: " + e.getMessage());
	    } catch (NumberFormatException e) {
	        out.println("Error parsing input values: " + e.getMessage());
	    }
	}
	%>

   

    <% 
    stmt.close();
    con.close();
    %>

    
    
</body>
</html>