<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% 
    // 로그인 되었는지 아닌지 확인
    Integer staffId = (Integer)(session.getAttribute("loginStaff"));
    if(staffId == null){
        response.sendRedirect("/sakila/d0328/loginForm.jsp");
        return;
    }
    if(application.getAttribute("loginStaff") == null){
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>SAKILA</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f7;
            margin: 0;
            padding: 0;
            color: #333;
        }
        .header {
            background-color: #2c3e50;
            color: white;
            padding: 12px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            
        }
        .header h1 {
            margin: 0;
            font-size: 24px;
            font-weight: bold;
          
        }
        .userinfo {
            font-size: 14px;
        }
        .userinfo a {
            color: #ecf0f1;
            margin-left: 8px;
            text-decoration: none;
        }
        .userinfo a:hover {
            text-decoration: underline;
        }
        .container {
            width: 100%;
            max-width: 600px;
            margin: 40px auto;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }
        ol {
            list-style-type: none;
            padding: 0;
            margin: 0;
        }
        ol li {
            margin: 8px 0;
        }
        ol li a {
            display: block;
            padding: 12px;
            background-color: #e9ecef;
            color: #333;
            text-decoration: none;
            border-radius: 4px;
            transition: background-color 0.2s ease;
        }
        ol li a:hover {
            background-color: #d1d8dd;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>SAKILA</h1>
        <div class="userinfo">
            <span><%=staffId %>님 반갑습니다.</span>
            <a href="/sakila/d0328/logout.jsp">로그아웃</a>
            <a href="/sakila/d0328/updatePasswordForm.jsp">비밀번호 변경</a>
        </div>
    </div>
    <div class="container">
        <ol>
            <li><a href="d0325/rentalList.jsp">대여목록</a></li>
            <li><a href="d0326/filmList.jsp">필름목록</a></li>
            <li><a href="d0326/actorList.jsp">배우목록</a></li>
            <li><a href="d0327/inventoryList.jsp">물품목록</a></li>
        </ol>
    </div>
</body>
</html>
