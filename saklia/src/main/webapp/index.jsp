<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/header.jsp" %>
<% 
    
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>SAKILA</title>
    <style>
       
       
      
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

<title>SAKILA</title>
<link rel="stylesheet" type="text/css" href="/sakila/css/sakila.css?after">
</head>
<body>

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
