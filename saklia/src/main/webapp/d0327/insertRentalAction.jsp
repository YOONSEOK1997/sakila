<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%
    // 파라미터 받기
    Integer customerId = Integer.parseInt(request.getParameter("customerId"));
    Integer inventoryId = Integer.parseInt(request.getParameter("inventoryId"));
    Integer staffId = Integer.parseInt(request.getParameter("staffId"));
    
    Connection conn = null;
    PreparedStatement stmt = null;
    String sql = "insert into rental (rental_date, inventory_id, customer_id, staff_id, return_date) VALUES (now(), ?, ?, ?, NULL)";
    int result = 0;

   
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "wkqk1234");
        stmt = conn.prepareStatement(sql);
   
        stmt.setInt(1, inventoryId);
        stmt.setInt(2, customerId);
        stmt.setInt(3, staffId);

        result = stmt.executeUpdate();

        if (result > 0) {
            System.out.println("대여 등록 성공!" + result);
          	response.sendRedirect("/sakila/d0325/rentalList.jsp");
        } else {
            System.out.println("대여 등록 실패! 다시 시도하세요.");
        }

        
 
%>
