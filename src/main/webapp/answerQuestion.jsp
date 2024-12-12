<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.myapp.pkg.ApplicationDB"%>
<%

	String username = (String) session.getAttribute("username");
	
    // Retrieve parameters from the request
    String questionId = request.getParameter("question_id");
    String answerText = request.getParameter("answer_text");

    // Validate inputs
      if (questionId == null || questionId.trim().isEmpty() || answerText == null || answerText.trim().isEmpty()) {
        out.print("Error: Missing question ID or answer text.");
        return;
    }

    // Establish database connection
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String updateQuery = "UPDATE questions SET answer_text = ?, representative_username = ? WHERE question_id = ?";

    try {
        // Get the database connection from ApplicationDB
        ApplicationDB db = new ApplicationDB();
        con = db.getConnection();

        // Prepare the SQL update statement
        ps = con.prepareStatement(updateQuery);
        ps.setString(1, answerText);   
        ps.setString(2, username);        
        ps.setString(3, questionId);

        // Execute the update query
        int rowsUpdated = ps.executeUpdate();

        if (rowsUpdated > 0) {
        	out.print("Answer has been successfully updated by representative: " + username);
        } else {
            out.print("Error: No question found with the provided question ID.");
        }

    } catch (SQLException e) {
        out.print("SQL Error: " + e.getMessage());
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