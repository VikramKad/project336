<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.myapp.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>    

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Train Schedules</title>
</head>
<style>
</style>
<body>

	<%
	
	
	
	// GET STATIONS HERE SIMILAR TO HOW WE ARE GETTING SCHEDULE
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		
		PreparedStatement ps = con.prepareStatement("SELECT * FROM stations;");
		ResultSet rs = ps.executeQuery();
		ArrayList<String> stations = new ArrayList<String>();
		ArrayList<Integer> stationIds = new ArrayList<Integer>();
		
		while (rs.next()) {
			stations.add(rs.getString("name"));
			stationIds.add(rs.getInt("station_id"));
		}
		
		rs.close();
		ps.close();
		con.close();
	%>

	<h2>Train Schedules</h2>
	<form method="GET" target="responseIframe" action="trainScheduleHandler.jsp"></form>
		<label for="originDropdown">Train Origin</label>
		<select id="originDropdown" name="origin">
			<option value="">--Select Origin--</option>
			<% for (String station : stations) { %>
				<option value="<%= station %>"><%= station %></option>
			<% } %>
		</select>
	
		<label for="destDropdown">Train Destination</label>
		<select id="destDropdown" name ="destination">
			<option value="">--Select Destination--</option>
			<% for (String station : stations) { %>
				<option value="<%= station %>"><%= station %></option>
			<% } %>
		</select>
	
		<label for="date">Travel Date</label>
        <input type="date" id="date" name="date" required />

	
		<button type="button" onClick="fetchSchedules()">Check Schedule</button>
	
		<label for="sortDropdown">Sort By</label>
		<select id="sortDropdown" name="sort">
			<option value="">Arrival</option>
			<option value="">Departure</option>
			<option value="">Fare</option>
		</select>
	
	
	<!-- populate response div with train schedules from db query -->
	<div id="response">
	<h3>Schedules Found</h3>
	</div>
	
	<script>
		window.fetchSchedules = function() {
			const origin = document.getElementById('originDropdown').value;
		   	const destination = document.getElementById('destDropdown').value;
		    const date = document.getElementById('date').value;
		    const sort = document.getElementById('sortDropdown').value;

		    const url = 'trainScheduleHandler.jsp?origin=' + encodeURIComponent(origin) +
            '&destination=' + encodeURIComponent(destination) + 
            '&date=' + encodeURIComponent(date) +
            '&sort=' + encodeURIComponent(sort);
		    
		    // console.log(url);
		    fetch(url)
		    	.then(response => response.text())
		        .then(data => {
		       		document.getElementById('response').innerHTML = data;
		    	})
		        .catch(error => {
		       		console.error('Error:', error);
		     	});
		    }
 
	</script>
</body>
</html>