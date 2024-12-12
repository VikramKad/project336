<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Active Lines</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script> <!-- Include jQuery -->
<script>
    // Function to query the best customer and update the textbox with the result
    function getBestCustomer() {
        // Send an AJAX request to the server-side JSP page (bestCustomer.jsp)
        $.ajax({
            url: 'bestCustomer.jsp',  // The JSP page that queries for the best customer
            type: 'GET',  // Use GET to retrieve data
            success: function(response) {
                // On success, update the textbox with the username of the best customer
                document.getElementById("bestCustomerTextBox").value = response.trim();  // Use trim to clean up any whitespace
            },
            error: function(xhr, status, error) {
                console.error('Error fetching best customer: ', error);
            }
        });
    }
    
    // Function to query for the top 5 active lines and update the textbox with the result
    function getActiveLines() {
        // Send an AJAX request to the server-side JSP page (activeLines.jsp)
        $.ajax({
            url: 'activeLines.jsp',  // The JSP page that queries for the top 5 active lines
            type: 'GET',  // Use GET to retrieve data
            success: function(response) {
                // On success, update the textbox with the top 5 active lines
                document.getElementById("activeLinesTextBox").value = response.trim();  // Use trim to clean up any whitespace
            },
            error: function(xhr, status, error) {
                console.error('Error fetching active lines: ', error);
            }
        });
    }

    // Function to query for the monthly sales and update the textbox with the result
    function getMonthlySales() {
        // Send an AJAX request to the server-side JSP page (monthlySales.jsp)
        $.ajax({
            url: 'monthlySales.jsp',  // The JSP page that queries for the monthly sales
            type: 'GET',  // Use GET to retrieve data
            success: function(response) {
                // On success, update the textbox with the monthly sales data
                document.getElementById("monthlySalesTextBox").value = response.trim();  // Use trim to clean up any whitespace
            },
            error: function(xhr, status, error) {
                console.error('Error fetching monthly sales: ', error);
            }
        });
    }

    // Function to generate a report based on selected category and type
    function generateReport() {
        // Get the selected category and type radio buttons
        var category = $("input[name='category']:checked").val();  // Reservation or Revenue
        var type = $("input[name='type']:checked").val();  // Transit Line or Customer Email
        
        // Validate if both category and type are selected
        if (!category || !type) {
            alert("Please select both category and type.");
            return;
        }
        
        // Send the selected category and type to the server-side JSP page (generateReport.jsp)
        $.ajax({
            url: 'generateReport.jsp',  // The JSP page that generates the report
            type: 'GET',  // Use GET to retrieve data
            data: {
                category: category,  // Pass selected category (reservation or revenue)
                type: type           // Pass selected type (transit line or customer email)
            },
            success: function(response) {
                // On success, populate the ReportTextBox with the report result
                document.getElementById("ReportTextBox").value = response.trim();  // Use trim to clean up any whitespace
            },
            error: function(xhr, status, error) {
                console.error('Error generating report: ', error);
            }
        });
    }
</script>
</head>
<body>

    <!-- Display the username of the best customer in this textbox -->
    <label for="bestCustomerTextBox">Best Customer:</label>
    <input type="text" id="bestCustomerTextBox" readonly>

    <!-- Display the top 5 active lines in a larger textarea -->
    <label for="activeLinesTextBox">Top 5 Active Lines:</label>
    <textarea id="activeLinesTextBox" rows="6" cols="80" readonly></textarea> <!-- Larger textbox -->

    <!-- Display the monthly sales in a larger textarea -->
    <label for="monthlySalesTextBox">Monthly Sales:</label>
    <textarea id="monthlySalesTextBox" rows="6" cols="80" readonly></textarea> <!-- Larger textbox for monthly sales -->

    <form method="post" action="Logout.jsp">
        <input type="submit" value="Log Out">
    </form>

    <button onClick="window.location.href='EditCustomerRepresentatives.jsp'">Edit Customer Representatives</button>
    <button onClick="getBestCustomer()">Get Best Customer</button>
    <button onClick="getActiveLines()">Get Top 5 Active Lines</button>
    <button onClick="getMonthlySales()">Get Monthly Sales</button>
    
    <br><br><br>
    <!-- Radio button group for reservation or revenue -->
    <label>Choose a Category:</label><br>
    <input type="radio" id="reservation" name="category" value="reservation">
    <label for="reservation">Reservation</label><br>
    <input type="radio" id="revenue" name="category" value="revenue">
    <label for="revenue">Revenue</label><br><br>

    <!-- Radio button group for transit line or customer email -->
    <label>Choose a Type:</label><br>
    <input type="radio" id="transitLine" name="type" value="transitLine">
    <label for="transitLine">Transit Line</label><br>
    <input type="radio" id="customerUsername" name="type" value="customerUsername">
    <label for="customerUsername">Customer Username</label><br><br>
    
    <button onClick="generateReport()">Generate Report</button>
    <br>
    <textarea id="ReportTextBox" rows="12" cols="160" readonly></textarea> <!-- Larger textbox for report -->
    
ADMIN
</body>
</html>
