<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.myapp.pkg.ApplicationDB"%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
</head>
<body>
	<%
	
	String username = (String) session.getAttribute("username");
	String question = request.getParameter("question");
	
	String message = "";
	
	if (question == null | question.isEmpty()) {
		out.print("Question can not be blank.");
		return;
	}
	
		try {
			ApplicationDB db = new ApplicationDB();
			Connection con = db.getConnection();
			
			String nextQuestionId = "";
			String nextQuery = "SELECT LPAD(CAST(SUBSTRING(MAX(`question_id`), 2) AS UNSIGNED) + 1, 5, '0') AS next_question_id FROM questions";
			PreparedStatement nextPs = con.prepareStatement(nextQuery);
			ResultSet rs = nextPs.executeQuery();
			if(rs.next()) {
				nextQuestionId = rs.getString("next_question_id");
			}
			
			String query = "INSERT INTO questions (question_id, customer_username, question_text, representative_username, answer_text) VALUES(?, ?, ?, NULL, NULL)";
			PreparedStatement ps = con.prepareStatement(query);
			ps.setString(1, nextQuestionId);
			ps.setString(2, username);
			ps.setString(3, question);
			int rowsAffected = ps.executeUpdate();
			
			if (rowsAffected > 0) {
				// succesful
				message = "Question submitted successfully!";
			} else {
				message = "Error submitting question. Please try again.";
			}
			
			ps.close();
			con.close();
		} 
		catch (Exception e) {
			message = "Error: " + e.getMessage();
		}
		
		request.setAttribute("message", message);
		RequestDispatcher rd = request.getRequestDispatcher("CustomerHome.jsp");
		rd.forward(request, response);
	
	%>
</body>
</html>