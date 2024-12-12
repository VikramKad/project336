<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="com.myapp.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>

<%
try {
    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();
    
    int reservationNumber = Integer.parseInt(request.getParameter("reservation_number"));
    
    String deleteQuery = "DELETE FROM reservations WHERE reservation_number = ?";
    PreparedStatement pstmt = con.prepareStatement(deleteQuery);
    pstmt.setInt(1, reservationNumber);
    pstmt.executeUpdate();
    
    con.close();
    
    out.println("Reservation deleted");
    %>
    <br>
    <button onClick="window.location.href='viewReservations.jsp'">Go back to Reservations</button>
    <br>
    <button onClick="window.location.href='CustomerHome.jsp'">Go back to Homepage</button>
    
    <%
    
} catch (Exception e) {
    out.println("Error: " + e.getMessage());
}
%>