<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%	//로그인 되었는지 아닌지?
		
		Integer  staffId = (Integer)(session.getAttribute("loginStaff"));
		
		
		if(staffId == null){
			response.sendRedirect("/sakila/d0328/loginForm.jsp");
			return;
		}
		if(application.getAttribute("loginStaff") == null){
		//로그인 페이지 리다이렉트
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
	<h1> Index</h1>
	<div>
	<%=staffId %>님 반갑습니다.
	<a href="/sakila/d0328/logout.jsp">[로그아웃]</a>
	<a href="/sakila/d0328/updatePasswordForm.jsp">비밀번호 변경</a>
	</div>
	
	<ol>
		<li><a href="d0325/rentalList.jsp"> 대여목록</a></li>
		<li><a href="d0326/filmList.jsp"> 필름목록</a></li>
		<li><a href="d0326/actorList.jsp"> 배우목록</a></li>
		<li><a href ="d0327/inventoryList.jsp">물품목록</a>
	</ol>
</body>
</html>