<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>



<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 변경</title>

</head>
<body>
    <div class="login-container">
        <h1>비밀번호 변경</h1>
        <form action="/sakila/d0328/updatePasswordAction.jsp">
            <table>
             	
                <tr>
                	
                    <td><input type="password" name="password" placeholder="현재비밀번호"></td>
                </tr>
                <tr>
                	<td><input type="password" name="newPassword" placeholder="새 비밀번호"></td>
                <tr>
               
            </table>
            <button type="submit">확인</button>
         
        </form>
    </div>
</body>
</html>
