<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<script>
	function searchQuestions() {
        // Get the keyword entered by the user
        var keyword = document.getElementById("keyword").value;
        
        // Check if the keyword is empty
        if (keyword.trim() === "") {
            alert("Please enter a keyword to search.");
            return;
        }
        
        // Create an AJAX request to send the keyword to the server
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "searchQuestions.jsp", true);  // Make sure the server-side page is correct
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        
        // Send the keyword as a parameter to the server
        var params = "keyword=" + encodeURIComponent(keyword);
        xhr.send(params);

        // Handle the response from the server
        xhr.onreadystatechange = function() {
            if (xhr.readyState == 4 && xhr.status == 200) {
                // Replace the table content with the response from the server
                document.getElementById("questionsTableBody").innerHTML = xhr.responseText;
            }
        };
    }
</script>
<body>
	<button onClick="window.location.href='CustomerHome.jsp'">Return to customer home</button>
	<br>
	<input type="text" id="keyword" name="keyword" placeholder="Enter Word(s)">
	<button type="button" onClick="searchQuestions()">Search Question (Use % to return all questions)</button>
	<br>
	<h2>Customer Questions</h2>

<!-- Table to display the questions data -->
<table border="1">
    <thead>
        <tr>
            <th>Question ID</th>
            <th>Customer Username</th>
            <th>Question Text</th>
            <th>Representative Username</th>
            <th>Answer Text</th>
        </tr>
    </thead>
    <tbody id="questionsTableBody">
        <!-- Data will be populated dynamically by the searchQuestions function -->
    </tbody>
</table>
	
</body>
</html>