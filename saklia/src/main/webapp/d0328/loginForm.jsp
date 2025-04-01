<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>LOGIN</title>
<link rel="stylesheet" type="text/css" href="/sakila/css/sakila.css?after">
<style>
    body {
        margin: 0;
        padding: 0;
        font-family: Arial, sans-serif;
        background-color: #f4f4f4;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
    }

    .login-container {
        background-color: white;
        padding: 40px 50px;
        border-radius: 16px;
        box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
        width: 340px;
        text-align: center;
    }

    .sakila-logo {
        font-size: 40px;
        font-weight: 900;
        color: #1ec800;
        margin-bottom: 20px;
    }

    .tab-menu {
        display: flex;
        justify-content: center;
        margin-bottom: 20px;
        background-color: #f8f8f8;
        border-radius: 8px;
    }

    .tab-menu div {
        padding: 12px 24px;
        cursor: pointer;
        font-size: 12px;
        color: #555;
        border-right: 1px solid #e5e5e5;
        flex: 1;
        text-align: center;
    }

    .tab-menu div:last-child {
        border-right: none;
    }

    .tab-menu div.active {
        background-color: white;
        font-weight: bold;
        color: #1ec800;
        border-bottom: 3px solid #1ec800;
    }

    input[type="text"], input[type="password"] {
        width: 90%;
        padding: 12px;
        margin: 8px 0;
        border: 1px solid #ddd;
        border-radius: 8px;
        font-size: 16px;
    }

    .options {
        display: flex;
        justify-content: space-between;
        margin: 12px 0;
        font-size: 14px;
    }

    .login-button {
        width: 100%;
        padding: 14px;
        background-color: #1ec800;
        color: white;
        border: none;
        border-radius: 8px;
        font-size: 18px;
        margin-top: 10px;
        cursor: pointer;
    }

    .login-button:hover {
        background-color: #28a745;
    }

    .login-options {
        margin: 12px 0;
        font-size: 14px;
        color: #666;
    }

    .checkbox input[type="checkbox"] {
        margin-right: 5px;
    }
    .checkbox{
    	margin-right: 110px;
    }

    .toggle {
        position: relative;
        display: inline-block;
        width: 34px;
        height: 20px;
    }

    .toggle input {
        opacity: 0;
        width: 0;
        height: 0;
    }

    .slider {
        position: absolute;
        cursor: pointer;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background-color: #ccc;
        border-radius: 20px;
        transition: 0.4s;
    }

    .slider:before {
        position: absolute;
        content: "";
        height: 14px;
        width: 14px;
        border-radius: 50%;
        background-color: white;
        bottom: 3px;
        left: 3px;
        transition: 0.4s;
    }

    input:checked + .slider {
        background-color: #1ec800;
    }

    input:checked + .slider:before {
        transform: translateX(14px);
    }

    .login-option {
        display: flex;
 
        align-items: center;
    }

    .login-option label {
        font-size: 14px;
        color: #555;
    }

    .toggle + label {
        margin-left: 10px;
        margin-right: 0;
    }

    .login-option label:last-child {
        margin-left: 10px;
        margin-right: 10px;
    }
	.error-message{
		font-size: 13px;
		color : red;
	}
</style>
</head>
<body>
    <div class="login-container">
        <div class="sakila-logo">SAKILA</div>
        <div class="tab-menu">
            <div class="active">ID/전화번호</div>
            <div>일회용 번호</div>
            <div>QR코드</div>
        </div>
       
        <form action="/sakila/d0328/loginAction.jsp">
            <input type="text" name="staffId" placeholder="아이디 또는 전화번호">
            <input type="password" name="password" placeholder="비밀번호">
             <% if (request.getParameter("loginError") != null) { %>
    <div class="error-message" >아이디 또는 비밀번호가 일치하지 않습니다.</div>
<% } %>
            <div class="login-option">
                <label class="checkbox">
                    <input type="checkbox"> 로그인 상태 유지
                </label>
                <label class="toggle">
                    <input type="checkbox"> 
                    <span class="slider"></span>
                   
                </label>
                 <label>IP보안</label>
            </div>
            <button class="login-button" type="submit">로그인</button>
        </form>
        <div class="login-options">
            비밀번호 찾기 | 아이디 찾기 | 회원가입
        </div>
    </div>
</body>
</html>
