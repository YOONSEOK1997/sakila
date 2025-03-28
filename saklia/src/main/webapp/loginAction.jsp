<%@page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% 
	//controller layer : staffId ,password
	int staffId = Integer.parseInt(request.getParameter("staffId"));
	String password = request.getParameter("password");
	
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	String sql = "select staff_id staffId, first_name firstName from staff where staff_id = ? and password = ? ";
	
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "wkqk1234");
	System.out.println("DB 연결 성공!");
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, staffId);
	stmt.setString(2,password);
	
	rs = stmt.executeQuery();
	boolean isLogin = false;
	if(rs.next()){
		application.setAttribute("loginStaff", rs.getInt("staffId")); //Tomcat에 변수 'loginStaff' 만듦
		session.setAttribute("loginStaff", rs.getInt("staffId"));
		response.sendRedirect("/sakila/index.jsp");
		System.out.println("로그인 성공");
	
	}else {
		response.sendRedirect("/sakila/loginForm.jsp");	
		System.out.println("로그인 실패");
	}
%>