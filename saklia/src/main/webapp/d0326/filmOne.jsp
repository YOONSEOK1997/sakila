<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, java.sql.*" %>

<%
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "wkqk1234");

    String filmId = request.getParameter("filmId"); // 영화 ID 가져오기
    HashMap<String, Object> film = new HashMap<>();
    ArrayList<String> actorMovies = new ArrayList<>();

    // 영화 상세 정보 조회 
    String filmSql = "SELECT f.film_id, f.title, f.description, f.release_year, f.rental_rate, f.length, f.rating, " +
                     "GROUP_CONCAT(a.actor_id) AS actorIds, GROUP_CONCAT(CONCAT(a.first_name, ' ', a.last_name)) AS actors " +
                     "FROM film f " +
                     "JOIN film_actor fa ON f.film_id = fa.film_id " +
                     "JOIN actor a ON fa.actor_id = a.actor_id " +
                     "WHERE f.film_id = ? " +
                     "GROUP BY f.film_id";
    
    PreparedStatement stmt = conn.prepareStatement(filmSql);
    stmt.setInt(1, Integer.parseInt(filmId));
    ResultSet rs = stmt.executeQuery();

    String actorIds = "";
    if (rs.next()) {
        film.put("filmId", rs.getInt("film_id"));
        film.put("title", rs.getString("title"));
        film.put("description", rs.getString("description"));
        film.put("releaseYear", rs.getInt("release_year"));
        film.put("rentalRate", rs.getDouble("rental_rate"));
        film.put("length", rs.getInt("length"));
        film.put("rating", rs.getString("rating"));
        film.put("actors", rs.getString("actors"));
        actorIds = rs.getString("actorIds");
    }

    //배우선택
    String[] actorIdArray = actorIds != null ? actorIds.split(",") : new String[0];
    String[] actorNameArray = film.get("actors") != null ? film.get("actors").toString().split(",") : new String[0];

    StringBuilder actorLinks = new StringBuilder();
    for (int i = 0; i < actorIdArray.length; i++) {
        actorLinks.append("<span cursor:pointer;' onclick=\"location.href='actorOne.jsp?actorId=")
                  .append(actorIdArray[i].trim()).append("'\">")
                  .append(actorNameArray[i].trim()).append("</span>");
        if (i < actorIdArray.length - 1) {
            actorLinks.append(", ");
        }
    }

%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>영화 상세 정보</title>
    <style>
        body {
            margin: 0;
            padding: 0;          
            background-color: #141414;
            font-family: 'Arial', sans-serif;
        }
        h1 {
            text-align: center;
            color: #fff;
            background-color: #333;
            padding: 20px;
            margin: 0;
            font-size: 36px;
        }
        .container {
            width: 80%;
            margin: 50px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.1);
            position: relative;
        }
        .info {
            font-size: 18px;
            margin: 15px 0;
            color: #333;
        }
        .info span {
            font-weight: bold;
            color: #555;
        }
        .poster-container {
            position: absolute;
            top: 20px;
            right: 20px;
            width: 250px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        }
        .poster {
            width: 100%;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.2);
        }
        .back-button {
            display: inline-block;
            margin-top: 20px;
            padding: 12px 24px;
            border: none;
            background-color: #333;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            cursor: pointer;
            text-align: center;
        }
        .back-button:hover {
            background-color: #555;
        }
        .actor-movies {
            margin-top: 20px;
            padding: 15px;
            background-color: #f9f9f9;
            border-radius: 8px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.05);
        }
        .actor-movies ul {
            list-style-type: none;
            padding: 0;
        }
        .actor-movies li {
            font-size: 16px;
            padding: 8px 0;
        }
        .actor-movies a {
            color: #007BFF;
            text-decoration: none;
        }
        .actor-movies a:hover {
            text-decoration: underline;
        }
        .rating {
            color: #ff9800;
            font-weight: bold;
        }
        .actor-links span {
    		color: #007BFF;
   			cursor: pointer;
   			transition: color 0.3s ease; /* 색상 변경을 부드럽게 처리 */
}

		.actor-links span:hover {
   			color: #ff5722; /* 마우스를 올렸을 때 색상 변경 */
   		    text-decoration: underline; /* 마우스를 올리면 밑줄 표시 */
}
    </style>
</head>
<body>
    <h1>영화 상세 정보</h1>
    <div class="container">
        <!-- 포스터 -->
        <div class="poster-container">
            <img class="poster" src="images/poster.jpg" alt="영화 포스터">
        </div>

        <!-- 영화 정보 -->
        <div class="info"><span>제목:</span> <%= film.get("title") %></div>
        <div class="info"><span>설명:</span> <%= film.get("description") %></div>
        <div class="info"><span>개봉년도:</span> <%= film.get("releaseYear") %></div>
        <div class="info"><span>대여 요금:</span> $<%= film.get("rentalRate") %></div>
        <div class="info"><span>상영 시간:</span> <%= film.get("length") %>분</div>
        <div class="info"><span>등급:</span> <%= film.get("rating") %> <span class="rating"></span></div>
        <div class="info"><span>출연 배우:</span>  <div class="actor-links"> <%= actorLinks.toString() %> </div>
</div>


       

        <a class="back-button" href="filmList.jsp">목록</a>
    </div>
</body>
</html>
