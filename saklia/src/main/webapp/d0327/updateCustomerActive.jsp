<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!-- Controller -->
<%

	Integer staffId = (Integer)session.getAttribute("loginStaff");
	
	if (staffId == null) { 
		response.sendRedirect("/sakila/loginForm.jsp");
		return;
	}
	
	Integer customerId = Integer.parseInt(request.getParameter("customerId"));
	Integer active = Integer.parseInt(request.getParameter("active"));
%>

<!-- Model -->
<%
	Connection conn = null;
	PreparedStatement stmt = null;
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "wkqk1234");
	
	
	String sql = "UPDATE customer SET ACTIVE = 1 WHERE customer_id = ?";
	

	if (active == 1) {
		sql = "UPDATE customer SET ACTIVE = 0 WHERE customer_id = ?";
	}
	
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, customerId);
	System.out.println(stmt);
	stmt.executeUpdate();
	
	response.sendRedirect("/sakila/d0327/inventoryList.jsp");
%>