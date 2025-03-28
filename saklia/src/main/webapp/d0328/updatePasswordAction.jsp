<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%

        // 폼에서 전달된 파라미터 받기
        String password = request.getParameter("password");
        String newPassword = request.getParameter("newPassword");
        // staffId 파싱
        Integer staffId = (Integer)(session.getAttribute("loginStaff"));
        
      	System.out.println("password=" +password);
      	System.out.println("newPassword=" +newPassword);
      	System.out.println("staffId=" + staffId);
        
      	
   
        
        // 데이터베이스 연결
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "wkqk1234");
        PreparedStatement stmt = null;
        
        // 비밀번호 변경 쿼리
        String sql = "UPDATE staff SET password = ? WHERE staff_Id = ? AND password = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, newPassword);
        stmt.setInt(2, staffId);
        stmt.setString(3, password);
        
        // 쿼리 실행
        int result = stmt.executeUpdate();
        
        if (result > 0) {
            System.out.println("비밀번호가 성공적으로 변경되었습니다! 로그인 페이지로 이동합니다");
            session.invalidate();
            response.sendRedirect("/sakila/index.jsp");
        } else {
            out.println("<p>비밀번호 변경에 실패했습니다. 현재 비밀번호를 확인하고 다시 시도해주세요.</p>");
        }
   
%>
