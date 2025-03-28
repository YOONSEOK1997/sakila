<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
// 로그인 되었는지 확인
Integer staffId = (Integer)(session.getAttribute("loginStaff"));

if (staffId != null) { // 로그아웃 상태라면
    response.sendRedirect("/sakila/loginForm.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>LOGIN</title>
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
        padding: 30px 40px;
        border-radius: 12px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        width: 320px;
    }

    h1 {
        text-align: center;
        margin-bottom: 20px;
        font-size: 24px;
        color: #333;
    }

    table {
        width: 100%;
        margin-bottom: 15px;
    }

    th, td {
        padding: 8px;
        text-align: left;
        font-size: 16px;
        color: #555;
    }

    input[type="number"], input[type="password"] {
        width: 100%;
        padding: 8px;
        margin-top: 4px;
        margin-bottom: 10px;
        border: 1px solid #ddd;
        border-radius: 6px;
        font-size: 14px;
    }

    button {
        width: 100%;
        padding: 10px;
        background-color: #007bff;
        color: white;
        border: none;
        border-radius: 6px;
        font-size: 16px;
        cursor: pointer;
        transition: background-color 0.2s;
    }

    button:hover {
        background-color: #0056b3;
    }
</style>
</head>
<body>
    <div class="login-container">
        <h1>WELCOME</h1>
        <form action="/sakila/loginAction.jsp">
            <table>
                <tr>
                    <th>ID</th>
                    <td><input type="number" name="staffId" placeholder="아이디를 입력해주세요"></td>
                </tr>
                <tr>
                    <th>PW</th>
                    <td><input type="password" name="password" placeholder="바밀번호를 입력해주세요"></td>
                </tr>
            </table>
            <button type="submit">로그인</button>
        </form>
    </div>
</body>
</html>
