<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Generate Reservations On</title>
    <script>
        function generateReservationsOn() {
            // Get the values entered by the user
            var transitLine = document.getElementById("transitLine").value;
            var date = document.getElementById("date").value;

            // Check if both fields are filled
            if (transitLine.trim() === "" || date.trim() === "") {
                alert("Please fill in both the Transit Line and Date.");
                return;
            }

            // Create an AJAX request to send the data to generateReservationsOn.jsp
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "generateReservationsOn.jsp", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

            // Send the data
            var params = "transitLine=" + encodeURIComponent(transitLine) + 
                         "&date=" + encodeURIComponent(date);
            xhr.send(params);

            // Handle the server response
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    // Display the result in the browser (a list of usernames)
                    document.getElementById("reservationResults").innerHTML = xhr.responseText;
                }
            };
        }
        
        function generateSchedules() {
            var stationType = document.querySelector('input[name="stationType"]:checked');
            var stationId = document.getElementById("stationId").value;
        	
            // Check if station type is selected and station ID is provided
            if (!stationType) {
                alert("Please select a Station Type (Origin or Destination).");
                return;
            }
        	
            if (stationId.trim() === "") {
                alert("Please enter a Station ID.");
                return;
            }
        	
            // Create an AJAX request to send the data to generateSchedules.jsp
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "generateSchedules.jsp", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

            // Send the data
            var params = "stationType=" + encodeURIComponent(stationType.value) +
                         "&stationId=" + encodeURIComponent(stationId);
            xhr.send(params);

            // Handle the server response
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    // Display the result in the results div
                    document.getElementById("scheduleResults").innerHTML = xhr.responseText;
                }
            };
        }
    </script>
</head>

<body>
    <form method="post" action="Logout.jsp">
        <input type="submit" value="Log Out">
    </form>
    
    <button onClick="window.location.href='ManageTrainSchedules.jsp'">Manage Train Schedules</button>
    <br>
    <button onClick="window.location.href='QuestionsAnswers.jsp'">Q&A</button>
    <br>
    <button onClick="generateReservationsOn()">Generate Reservations On:</button>
    
    <!-- Transit Line Input -->
    <input type="text" id="transitLine" name="transitLine" placeholder="Transit Line">
    
    <!-- Date Input -->
    <label for="date">Select Date:</label>
    <input type="date" id="date" name="date">
    <br><br>

    <div id="reservationResults">
        <!-- The results will be displayed here -->
    </div>
    <br><br>

	<button onClick="generateSchedules()">Generate Schedules On:</button>
    <!-- Radio buttons for Station Type -->
    <label for="origin">Origin</label>
    <input type="radio" id="origin" name="stationType" value="origin">
    
    <label for="destination">Destination</label>
    <input type="radio" id="destination" name="stationType" value="destination">
    
    <!-- Station ID Input -->
    <input type="text" id="stationId" name="stationId" placeholder="Station ID">
    <br><br>
    <div id="scheduleResults">
        <!-- The results will be displayed here -->
    </div>
</body>
</html>
