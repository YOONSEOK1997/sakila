<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%
	// staff 로그인 session 확인
	

	Integer inventoryId = Integer.parseInt(request.getParameter("inventoryId"));
	Integer staffId	= (Integer)session.getAttribute("loginStaff");
	Integer customerId = null;
	if(request.getParameter("customerId") != null) {
		// 이름검색 후 이 페이지가 다시 요청되면 customerId값을 받아 온다
		customerId = Integer.parseInt(request.getParameter("customerId"));
	}
	
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	String sql = "select i.inventory_id inventoryId,i.film_id filmId, f.title, i.store_id storeId from inventory i inner join film f on i.film_id=f.film_id  where inventory_id=?";
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila","root","wkqk1234");
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, inventoryId);
	System.out.println(stmt);
	rs = stmt.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f4f4;
        margin: 0;
        padding: 20px;
    }

    h1 {
        text-align: center;
        font-size: 2em;
        margin-bottom: 20px;
        color: #333;
    }

    form {
        margin: 0 auto;
        width: 50%;
        text-align: center;
    }

    input[type="text"] {
        padding: 10px;
        margin: 5px;
        border: 1px solid #ddd;
        border-radius: 4px;
    }

    button {
        padding: 10px 20px;
        background-color: #28a745;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        margin-top: 10px;
    }

    button:hover {
        background-color: #218838;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
    }

    td {
        padding: 12px;
        border: 1px solid #ddd;
        text-align: center;
        background-color: #fff;
    }

    th {
        background-color: #333;
        color: white;
        padding: 12px;
        border: 1px solid #ddd;
    }
    #searchbar{
    		 border-radius: 20px;
    	    border: 1px solid #1ec800;
    }
</style>
</head>
<body>
	<h1>Insert Rental Inventory</h1>
	<%
		if(rs.next()) {
	%>
		<form action="/sakila/d0327/searchCustomIdList.jsp" method="post">
			<input type="hidden" name="inventoryId" value="<%=inventoryId%>">
			<input type="text" name="searchName" id="serachbar">
			<button type="submit">이름으로 customerId검색</button>
		</form>
		<!-- 
			insertRentalForm.jsp -> 이름검색 -> customerListByName.jsp -> insertRentalForm.jsp
		 -->
		
		
		<form action="/sakila/d0327/insertRentalAction.jsp" method="post">
			<table id="table">
				<tr>
					<td>customerId</td>
					<td>
						<input type="text" name="customerId" value="<%=customerId%>" readonly>
					</td>
				</tr>
			
				<tr>
					<td>inventoryId</td>
					<td><input type="text" name="inventoryId" value="<%=inventoryId%>" readonly></td>
				</tr>
				<tr>
					<td>filmId</td>
					<td>
						<input type="text" name="filmId" value="<%=rs.getInt("filmId")%>" readonly> <br>
						<%=rs.getString("title")%>
					</td>
				</tr>
				<tr>
					<td>storeId</td>
					<td><input type="text" name="storeId" value=<%=rs.getInt("storeId")%> readonly></td>
				</tr>
				<tr>
					<td>staffId</td>
					<td><input type="text" name="staffId" value=<%=staffId%> readonly></td>
				</tr>
			</table>
			<button type="submit">대여하기</button>
		</form>
	<%		
		}
	%>
</body>
</html>