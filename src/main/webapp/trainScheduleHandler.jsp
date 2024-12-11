<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.myapp.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="com.myapp.pkg.TrainScheduleObject" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Train Schedules</title>
    <style>
        
        .card {
            border: 2px solid #ddd;
            border-radius: 10px; 
            padding: 20px; 
            margin: 20px; 
            width: 300px; 
            background-color: #fff; 
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); 
            transition: transform 0.2s; 
        }

        
        .card:hover {
            transform: translateY(-5px); 
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15); 
        }

        
        .card h3 {
            font-size: 20px;
            margin: 0 0 10px;
        }

   
        .card p {
            font-size: 16px;
            font-weight: bold;
            color: #555;
        }
        
        .card li {
        	font-size: 16px;
            color: #555;
        }
        
        .card .extra-content {
            display: none;
            margin-top: 10px;
            color: #666;
            font-size: 14px;
        }
        
        .card.expanded .extra-content {
            display: block;
        }
    </style>
    
    <script>
		window.toggleCard = function(card) {
        	card.classList.toggle("expanded");
    	}
	</script>
	
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
			String sort = request.getParameter("sort");
			
			// Sort by
			String sortQuery = "";
			boolean sortFlag = false;
			if (sort.equalsIgnoreCase("arrival")) {
				sortQuery = "ORDER BY t2.arrival_datetime";
			} else if (sort.equalsIgnoreCase("departure")) {
				sortQuery = "ORDER BY t1.departure_datetime";
			} else if (sort.equalsIgnoreCase("fare")) {
				sortFlag = true; // doesn't exist in table, need different way to sort by fare or add to database
			}
			
			String originId = "";
			String idQuery = "SELECT s.station_id FROM stations s WHERE name = ?";
			PreparedStatement idPs = con.prepareStatement(idQuery);
			idPs.setString(1, origin);
			ResultSet originPs = idPs.executeQuery();
			while (originPs.next()) {
				originId = originPs.getString("station_id");
			}
			String destinationId = "";
			idPs.setString(1, destination);
			ResultSet destinationRs = idPs.executeQuery();
			while (destinationRs.next()) {
				destinationId = destinationRs.getString("station_id");
			}
			
			String query = "SELECT t1.train_id, t1.line_id, t1.station_id AS origin_id," +
	                "TIME(t1.departure_datetime) AS origin_departure," + 
	                "t2.station_id AS destination_station," + 
	                "TIME(t2.arrival_datetime) AS destination_arrival " + 
	                "FROM train_schedules t1 " + 
	                "JOIN train_schedules t2 " + 
	                "ON t1.train_id = t2.train_id " + 
	                "AND t1.schedule_id = t2.schedule_id " + 
	                "AND t1.line_id = t2.line_id " + 
	                "AND t1.departure_datetime < t2.arrival_datetime " + 
	                "WHERE t1.station_id = ? " + 
	                "AND t2.station_id = ? " +
	                "AND DATE(t1.departure_datetime) = ? " + 
	                sortQuery;
			
			PreparedStatement ps = con.prepareStatement(query);
			ps.setString(1, originId);
			ps.setString(2, destinationId);
			ps.setString(3, date);
			ResultSet rs = ps.executeQuery();
			
			while (rs.next()) {
				// add each schedule item to list for display
				// "schedule" below may need to be changed depending on how it's stored in db
				String originStation = new String(origin);
				String destStation = new String(destination);
				
				// get transit line name from line_id
				String line = "";
				String lQuery = "SELECT DISTINCT l.line_name FROM transit_lines l WHERE l.line_id = ?";
				PreparedStatement linePs = con.prepareStatement(lQuery);
				String lineId = rs.getString("line_id");
				linePs.setString(1, lineId);
				ResultSet lineRs = linePs.executeQuery();
				if (lineRs.next()) { line = lineRs.getString("line_name"); }
				String departure = rs.getString("origin_departure");
				String arrival = rs.getString("destination_arrival");
				String fare = "$5"; // needs to be changed
				
				String stopQuery = "SELECT s.name FROM transit_lines t JOIN stations s ON t.station_id = s.station_id WHERE line_id = ? AND CAST(s.station_id AS UNSIGNED) BETWEEN ? AND ?";
				PreparedStatement stopPs = con.prepareStatement(stopQuery);
				stopPs.setString(1, lineId);
				stopPs.setString(2, originId);
				stopPs.setString(3, destinationId);
				ResultSet stopRs = stopPs.executeQuery();
	
				ArrayList<String> stops = new ArrayList<>();
				while (stopRs.next()) {
					stops.add(stopRs.getString("name"));
				}
				
				TrainScheduleObject obj = new TrainScheduleObject(originStation, destStation, line, departure, arrival, date, fare, stops);
				schedules.add(obj);
			}
			
			TrainScheduleObject obj = new TrainScheduleObject("origin", "destination", "line", "departure", "arrival", date, "$10", new ArrayList<String>());
			schedules.add(obj);
			
			
			// if user sorts by fare
			//if (sortFlag == true) {
			//	Collections.sort(schedules, new TrainScheduleComparator());
			//}
			
			
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
        	responseHtml.append("<div>"); // class="schedule-container"
        	for (TrainScheduleObject schedule : schedules)  {
				
        	
            	responseHtml.append("<div class=\"card\" onClick=\"toggleCard(this)\">")
            				.append("<h3>Origin:   ").append(schedule.getOrigin()).append("</h3>")
            				.append("<h3>Destination:   ").append(schedule.getDestination()).append("</h3>")
            				.append("<p><span>Transit Line:   </span>").append(schedule.getTransitLine()).append("</p>")
            				.append("<p><span>Departure Time:   </span>").append(schedule.getDeparture()).append("</p>")
            				.append("<p><span>Arrival Time:   </span>").append(schedule.getArrival()).append("</p>");
            	
            	//responseHtml.append("<div class=\"extra-content\">")
            	//			.append("<ul>");
            	
				responseHtml.append("<p><span>Train Stops:</span>");
            	for (String stop : schedule.getStops()) {
            		responseHtml.append("<li>").append(stop).append("</li>");
            	}
            	
            	responseHtml.append("<p>").append("Fare:   ").append(schedule.getFare()).append("</p>")
            	.append("</ul>")
            	//.append("</div>")
            	.append("</div>");
        	}
		}
		
    	responseHtml.append("</div>");
    	// Output response HTML
    	out.print(responseHtml.toString());
	%>

</body>
</html>