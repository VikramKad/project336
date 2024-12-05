<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.myapp.pkg.*"%>
<%@ page import="com.myapp.pkg.TrainScheduleObject" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Train Schedules</title>
</head>
<body>

<!-- Handles getting train schedule from database based on user selections for origin, destination, and date. -->

	<%
		List<TrainScheduleObject> schedules = new ArrayList<>();
	    StringBuilder responseHtml = new StringBuilder();
		
		try {
			if (request.getParameter("date") == null || request.getParameter("origin") == null || request.getParameter("destination") == null || request.getParameter("date") == "" || request.getParameter("origin") == "" || request.getParameter("destination") == "") {
				session.setAttribute("error", "Please select an origin, destination, and date.");
				throw new Exception("Missing required parameters.");
			}
			
			ApplicationDB db = new ApplicationDB();
			Connection con = db.getConnection();
			
			String origin = request.getParameter("origin");
			String destination = request.getParameter("destination");
			String date = request.getParameter("date");
			
			String query = "SELECT * FROM train_schedules;"; // query for database here
			PreparedStatement ps = con.prepareStatement(query);
			// ps.setString(1, origin);
			// ps.setString(2, destination);
			// ps.setString(3, date);
			ResultSet rs = ps.executeQuery();
			
			
			while (rs.next()) {
				// add each schedule item to list for display
				// "schedule" below may need to be changed depending on how it's stored in db
				TrainScheduleObject obj = new TrainScheduleObject(rs.getInt("origin_station_id"),
						rs.getInt("destination_station_id"),
						rs.getInt("train_id"),
						rs.getString("transit_line"),
						rs.getString("departure_time"),
						rs.getString("arrival_time"),
						rs.getDouble("fare")
						);
				schedules.add(obj);
			}
			
			rs.close();
			ps.close();
			con.close();
			
		}
		catch (Exception e) {
			e.printStackTrace();
		}

		if (schedules.isEmpty()) {
        	responseHtml.append("<p>No schedules found for the selected route and date.</p>");
        }
		
		else {
        	responseHtml.append("<ul>");
        	for (TrainScheduleObject schedule : schedules) {
            	responseHtml.append("<li>").append(schedule.getScheduleHtml()).append("</li>");
        	}
        	
        responseHtml.append("</ul>");
    }

    // Output response HTML
    out.print(responseHtml.toString());
	%>


</body>
</html>