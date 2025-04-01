<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, java.sql.*" %>
<%@ include file="/header.jsp" %>
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
    <link rel="stylesheet" type="text/css" href="/sakila/css/sakila.css?after">
    <style>
      
        h1 {
            color: #333;
            text-align: center;
            font-size: 36px;
            margin-bottom: 30px;
            font-weight: 600;
        }
        .container {
            width: 80%;
            margin: 0 auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 12px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            background-color: white;
            position: relative;
            overflow: hidden;
        }
        .actor-movies {
            margin-top: 20px;
        }
        .actor-movies h2 {
            color: #555;
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 15px;
        }
        .actor-movies ul {
            list-style-type: none;
            padding: 0;
            display: grid;
            grid-template-columns: repeat(3, 1fr); /* 3열 그리드 */
            gap: 20px; /* 항목 간 간격 */
        }
        .actor-movies li {
            padding: 12px;
            border-radius: 8px;
            background-color: #fff;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .actor-movies li:hover {
            transform: scale(1.05); /* hover 시 크기 확대 */
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
        }
        .actor-movies li a {
            color: black;
            text-decoration: none;
            font-weight: 500;
            display: block;
            text-align: center;
        }
        .actor-movies li a:hover {
            text-decoration: underline;
        }
        .back-button {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            border: none;
            background-color: #333;
            color: white;
            text-decoration: none;
            border-radius: 30px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .back-button:hover {
            background-color: #16b600;
        }
    </style>
</head>
<body>
    <h1>filmographies</h1>
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

        <a class="back-button" href="actorList.jsp">목록으로 돌아가기</a>
    </div>
</body>
</html>
