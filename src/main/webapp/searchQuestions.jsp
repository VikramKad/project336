<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.myapp.pkg.ApplicationDB"%>
<%
    // Retrieve the keyword from the request parameter
    String keyword = request.getParameter("keyword");

    if (keyword == null || keyword.trim().isEmpty()) {
        out.print("");  // Return empty if no keyword is provided
        return;
    }

    // Establish database connection and query to retrieve questions
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String query = "SELECT question_id, customer_username, question_text, representative_username, answer_text " + 
                   "FROM questions " + 
                   "WHERE question_text LIKE ?";

    try {
        // Get the database connection from ApplicationDB
        ApplicationDB db = new ApplicationDB();
        con = db.getConnection();

        // Prepare the SQL statement with the keyword
        ps = con.prepareStatement(query);
        ps.setString(1, "%" + keyword + "%");  // Use LIKE operator to search for partial matches

        // Execute the query
        rs = ps.executeQuery();

        // Check if any results were found
        if (!rs.next()) {
            out.print("<tr><td colspan='5'>No results found for the keyword: " + keyword + "</td></tr>");
        } else {
            // Iterate through the result set and populate the table rows
            do {
                String questionId = rs.getString("question_id");
                String customerUsername = rs.getString("customer_username");
                String questionText = rs.getString("question_text");
                String representativeUsername = rs.getString("representative_username");
                String answerText = rs.getString("answer_text");

                // Output each row of the table dynamically
                out.print("<tr>");
                out.print("<td>" + questionId + "</td>");
                out.print("<td>" + customerUsername + "</td>");
                out.print("<td>" + questionText + "</td>");
                out.print("<td>" + representativeUsername + "</td>");
                out.print("<td>" + answerText + "</td>");
                out.print("</tr>");
            } while (rs.next());
        }
    } catch (SQLException e) {
        out.print("Error: " + e.getMessage());
    } finally {
        try {
            // Close database resources
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            out.print("Error closing resources: " + e.getMessage());
        }
    }
%>
