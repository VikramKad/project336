<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.myapp.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

 <script>
        function deleteRep() {
            // Get the value of the username input field
            var username = document.getElementById("username").value;

            // Check that there is a username
            if (username === '') {
                alert("Please enter a username to delete.");
                return;
            }

            // Make an AJAX call to delete the representative
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "DeleteRepresentative.jsp", true); // You will call DeleteRepresentative.jsp or a Servlet here
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

            // Send the username to the server
            xhr.send("username=" + encodeURIComponent(username));

            // Handle the response from the server
            xhr.onload = function() {
                if (xhr.status === 200) {
                    alert(xhr.responseText);  // Show the server's response
                    window.location.href = "EditCustomerRepresentatives.jsp"; // Redirect after deletion
                } else {
                    alert("Error: " + xhr.status);
                }
            };
        }
        
        function addRep() {
            // Get the value of the input fields
            var username = document.getElementById("username").value;
            var password = document.getElementById("password").value;
            var last_name = document.getElementById("last_name").value;
            var first_name = document.getElementById("first_name").value;
            var ssn = document.getElementById("ssn").value;

            // Check that all fields are filled
            if (username === '' || password === '' || last_name === '' || first_name === '' || ssn === '') {
                alert("Please input all fields to add.");
                return;
            }

            console.log("Sending data to server...");

            // Make an AJAX call to add the representative
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "AddRepresentative.jsp", true); // This should point to the correct server-side script
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

            // Send the form data to the server
            xhr.send("username=" + encodeURIComponent(username) +
                     "&password=" + encodeURIComponent(password) +
                     "&last_name=" + encodeURIComponent(last_name) +
                     "&first_name=" + encodeURIComponent(first_name) +
                     "&ssn=" + encodeURIComponent(ssn));

            // Handle the response from the server
            xhr.onload = function() {
                if (xhr.status === 200) {
                    alert(xhr.responseText);  // Show the server's response
                    window.location.href = "EditCustomerRepresentatives.jsp"; // Redirect after addition
                } else {
                    alert("Error: " + xhr.status);
                }
            };
        }
        
        function updateRep() {
            // Get the value of the input fields
            var username = document.getElementById("username").value;
            var new_username = document.getElementById("new_username").value; // New username
            var password = document.getElementById("password").value;
            var last_name = document.getElementById("last_name").value;
            var first_name = document.getElementById("first_name").value;
            var ssn = document.getElementById("ssn").value;

            // Check that there is a username
            if (username === '') {
                alert("Please enter a username to update.");
                return;
            }

            // Collect the data to send (only non-empty fields)
            var data = "username=" + encodeURIComponent(username);

            // Include new_username if provided
            if (new_username !== '') {
                data += "&new_username=" + encodeURIComponent(new_username);
            }

            if (password !== '') {
                data += "&password=" + encodeURIComponent(password);
            }
            if (last_name !== '') {
                data += "&last_name=" + encodeURIComponent(last_name);
            }
            if (first_name !== '') {
                data += "&first_name=" + encodeURIComponent(first_name);
            }
            if (ssn !== '') {
                data += "&ssn=" + encodeURIComponent(ssn);
            }

            // Make an AJAX call to update the representative data
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "UpdateRepresentative.jsp", true); // This should point to the server-side script for updating
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

            // Send the form data to the server
            xhr.send(data);

            // Handle the response from the server
            xhr.onload = function() {
                if (xhr.status === 200) {
                    alert(xhr.responseText);  // Show the server's response
                    window.location.href = "EditCustomerRepresentatives.jsp"; // Redirect after update
                } else {
                    alert("Error: " + xhr.status);
                }
            };
        }
   
    </script>
		<button onClick="window.location.href='AdminHome.jsp'">Return to admin home</button> <br><br>


        <input type="text" id="username" name="username" placeholder="Enter username">
        <input type="text" id="password" name="password" placeholder="Enter password">
        <input type="text" id="last_name" name="last_name" placeholder="Enter last_name">
        <input type="text" id="first_name" name="first_name" placeholder="Enter first_name">
        <input type="text" id="ssn" name="ssn" placeholder="Enter ssn">
        <button type="button" onclick="deleteRep()">Delete</button>
        <button type="button" onclick="addRep()">Add</button>
        <button type="button" onclick="updateRep()">Update</button>
        <input type="text" id="new_username" name="new_username" placeholder="new_username (update only)">
    
	<%
		try {
	
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		

			String query = "SELECT a.username, a.password, a.last_name, a.first_name, r.ssn FROM accounts a, representatives r WHERE a.username = r.username";
			//Run the query against the database.
			PreparedStatement ps = con.prepareStatement(query);
			ResultSet result = ps.executeQuery();
			
			//Make an HTML table to show the results in:
			out.print("<table>");

			//make a row
			out.print("<tr>");
			//make a column
			out.print("<td>");
			//print out column header
			out.print("username");
			out.print("</td>");
			//make a column
			out.print("<td>");
			//print out column header
			out.print("password");
			out.print("</td>");
			//make a column
			out.print("<td>");
			//print out column header
			out.print("last_name");
			out.print("</td>");
			//make a column
			out.print("<td>");
			//print out column header
			out.print("first_name");
			out.print("</td>");
			//make a column
			out.print("<td>");
			//print out column header
			out.print("ssn");
			out.print("</td>");
			out.print("</tr>");

			//parse out the results
			while (result.next()) {
				//make a row
				out.print("<tr>");
				//make a column
				out.print("<td>");
				//Print out data using field name
				out.print(result.getString("username"));
				out.print("</td>");
				out.print("<td>");
				//Print out data using field name
				out.print(result.getString("password"));
				out.print("</td>");
				out.print("<td>");
				//Print out data using field name
				out.print(result.getString("last_name"));
				out.print("</td>");
				out.print("<td>");
				//Print out data using field name
				out.print(result.getString("first_name"));
				out.print("</td>");
				out.print("<td>");
				//Print out data using field name
				out.print(result.getString("ssn"));
				out.print("</td>");
				out.print("</tr>");

			}
			out.print("</table>");

			//close the connection.
			db.closeConnection(con);
		} catch (Exception e) {
			out.print(e);
		}
	%>
</body>
</html>