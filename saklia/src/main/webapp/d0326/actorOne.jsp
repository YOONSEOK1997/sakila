<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, java.sql.*" %>

<%
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "wkqk1234");

    String actorId = request.getParameter("actorId"); // 배우 ID 가져오기
    HashMap<String, Object> actor = new HashMap<>();
    ArrayList<HashMap<String, Object>> actorMovies = new ArrayList<>(); // 영화 리스트 저장

    // 출연 영화 목록 조회
    String actorMovieSql = "SELECT f.film_id, f.title " +
                           "FROM film f " +
                           "JOIN film_actor fa ON f.film_id = fa.film_id " +
                           "JOIN actor a ON fa.actor_id = a.actor_id " +
                           "WHERE fa.actor_id = ? " +
                           "ORDER BY f.title";

    PreparedStatement stmt = conn.prepareStatement(actorMovieSql);
    stmt.setInt(1, Integer.parseInt(actorId));
    ResultSet rs = stmt.executeQuery();

    // 영화 목록 가져오기
    while (rs.next()) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("filmId", rs.getInt("film_id"));  // 영화 ID 추가
        map.put("title", rs.getString("title"));  // 영화 제목 추가
        actorMovies.add(map);  // 영화 리스트에 추가
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>필모그레피</title>
    <style>
        body {
            margin: 0;
            padding: 20px;
            font-family: Arial, sans-serif;
        }
        h1 {
            color: black;
            text-align: center;
        }
        .container {
            width: 60%;
            margin: 0 auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 10px;
            box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.1);
            position: relative;
        }
        .info {
            text-align: left;
            margin: 10px 0;
        }
        .info span {
            font-weight: bold;
            color: #555;
        }
        .back-button {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            border: none;
            background-color: black;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .back-button:hover {
            background-color: #16b600;
        }
        .actor-movies {
            margin-top: 20px;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #f9f9f9;
        }
        .actor-movies ul {
            list-style-type: none;
            padding: 0;
        }
        .actor-movies li {
            padding: 5px 0;
        }
        li a{
        text-decoration : none;
        }
    </style>
</head>
<body>
    <h1>필모그레피</h1>
    <div class="container">
        <div class="actor-movies">
            <ul>
                <% 
                    for (HashMap<String, Object> map : actorMovies) { 
                        String title = (String) map.get("title");
                        int filmId = (Integer) map.get("filmId");
                %>
                    <li><a href="filmOne.jsp?filmId=<%= filmId %>"><%= title %></a></li>
                <% 
                    }
                %>
            </ul>
        </div>

        <a class="back-button" href="actorList.jsp">목록</a>
    </div>
</body>
</html>
