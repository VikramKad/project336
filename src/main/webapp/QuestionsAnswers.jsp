<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.myapp.pkg.ApplicationDB"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Questions Table</title>
<script>
    // Function to search questions based on the entered keyword
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
    
    // Function to answer a question
    function answerQuestions() {
        // Get the selected question ID and the answer text
        var questionId = document.getElementById("selectQuestionID").value;
        var answerText = document.getElementById("answerQuestion").value;
        
        // Validate inputs
        if (questionId.trim() === "" || answerText.trim() === "") {
            alert("Please select a question ID and provide an answer.");
            return;
        }

        // Create an AJAX request to send the data to the server
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "answerQuestion.jsp", true);  // Make sure the server-side page is correct
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

        // Send the selected question ID and answer text as parameters to the server
        var params = "question_id=" + encodeURIComponent(questionId) + "&answer_text=" + encodeURIComponent(answerText);
        xhr.send(params);

        // Handle the response from the server
        xhr.onreadystatechange = function() {
            if (xhr.readyState == 4 && xhr.status == 200) {
                // Replace the table content with the updated results
                document.getElementById("questionsTableBody").innerHTML = xhr.responseText;
                alert("Answer has been saved successfully.");
            }
        };
    }
</script>
</head>

<body>

<!-- Button to navigate to the representative home -->
<button onClick="window.location.href='RepresentativeHome.jsp'">Return to representative home</button>
<br><br>

<!-- Input field for the search keyword -->
<input type="text" id="keyword" name="keyword" placeholder="Enter Word(s)">
<button type="button" onClick="searchQuestions()">Search Question (Use % to return all questions)</button>
<br><br>

<!-- Input fields for answering a question -->
<input type="text" id="selectQuestionID" name="selectQuestionID" placeholder="Select Question ID">
<textarea id="answerQuestion" name="answerQuestion" placeholder="Answer the question here..." rows="4" cols="50"></textarea>
<button type="button" onClick="answerQuestions()">Submit Answer</button>

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
