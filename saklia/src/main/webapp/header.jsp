<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% 
    Integer staffId = (Integer)(session.getAttribute("loginStaff"));
    if(staffId == null){
        response.sendRedirect("/sakila/d0328/loginForm.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body>
<div class="header">
  <h1><a href="/sakila/index.jsp" style="color: white; text-decoration: none;">SAKILA</a></h1>
    <div class="userinfo">
        <span><%=staffId %>님 반갑습니다.</span>
        <a href="/sakila/d0328/logout.jsp">로그아웃</a>
        <a href="/sakila/d0328/updatePasswordForm.jsp">비밀번호 변경</a>
    </div>
</div>
</body>
</html>