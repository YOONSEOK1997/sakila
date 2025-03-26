<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%
Class.forName("com.mysql.cj.jdbc.Driver");
Connection conn = null;
PreparedStatement stmt = null;
ResultSet rs = null;

int totalCount = 0;

conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "wkqk1234");
System.out.println("DB 연결 성공!");

int currentPage = 1;
if (request.getParameter("currentPage") != null) {
    currentPage = Integer.parseInt(request.getParameter("currentPage"));
}

int rowPerPage = 5; // 한 페이지당 출력할 개수
int startRow = (currentPage - 1) * rowPerPage;

//검색값 설정
String searchFilmId = request.getParameter("storeId") != null ? request.getParameter("storeId") : "";
String searchWord = request.getParameter("searchWord") != null ? request.getParameter("searchWord") : "";

String countSql = "SELECT COUNT(*) FROM film f "+
"JOIN "+
"film_actor fa ON f.film_id = fa.film_id "+
"JOIN "+
"actor a ON fa.actor_id = a.actor_id";

if (!searchWord.equals("")) {
    countSql += " WHERE f.title LIKE ? ";
}

stmt = conn.prepareStatement(countSql);

int paramIndex = 1;
if (!searchFilmId.equals("") && !searchFilmId.equals("0")) {
    stmt.setInt(paramIndex++, Integer.parseInt(searchFilmId));
}
if (!searchWord.equals("")) {
    stmt.setString(paramIndex++, "%" + searchWord + "%");
}

rs = stmt.executeQuery();
if (rs.next()) {
    totalCount = rs.getInt(1);
}

int lastPage = (totalCount + rowPerPage - 1) / rowPerPage; // 전체 페이지 수 계산

// 검색된 데이터 조회
ArrayList<HashMap<String, Object>> list = new ArrayList<>();

String sql = "SELECT " +
        "f.film_id AS filmId, " +
        "f.title AS title, " +
        "f.description AS description, " +
        "f.release_year AS releaseYear, " +
        "f.rental_rate AS rentalRate, " +
        "GROUP_CONCAT(DISTINCT CONCAT(a.first_name, ' ', a.last_name)) AS actorName " +
        "FROM " +
        "film f " +
        "INNER JOIN " +
        "film_actor fa ON f.film_id = fa.film_id " +
        "INNER JOIN " +
        "actor a ON fa.actor_id = a.actor_id ";

String whereClause = ""; // WHERE 절을 위한 변수

if (!searchWord.equals("")) {
    sql += " WHERE f.title LIKE ? ";  
}

sql += " GROUP BY f.film_id, f.title, f.description, f.release_year, f.rental_rate "; 
sql += " ORDER BY filmId DESC LIMIT ?, ?"; // 페이징 처리

stmt = conn.prepareStatement(sql);
paramIndex = 1;

if (!searchWord.equals("")) {
    stmt.setString(paramIndex++, "%" + searchWord + "%"); 
}

stmt.setInt(paramIndex++, startRow); // 페이징 시작 위치
stmt.setInt(paramIndex, rowPerPage);  // 페이지당 레코드 수

rs = stmt.executeQuery();

while (rs.next()) {
    HashMap<String, Object> map = new HashMap<>();
    map.put("filmId", rs.getObject("filmId"));
    map.put("title", rs.getObject("title"));
    map.put("description", rs.getObject("description"));
    map.put("releaseYear", rs.getObject("releaseYear"));
    map.put("rentalRate", rs.getObject("rentalRate"));
    map.put("actorName", rs.getObject("actorName"));    
    list.add(map);
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Film List</title>
<style>
    /* 넷플릭스 스타일 */
    body {
        background-color: #141414;
        font-family: 'Helvetica', 'Arial', sans-serif;
        color: #e5e5e5;
        margin: 0;
        padding: 0;
    }
    h1 {
        color: #fff;
        text-align: center;
        padding: 20px;
        font-size: 36px;
        font-weight: 700;
    }

    /* 영화 리스트 테이블 스타일 */
    #table {
        width: 80%;
        margin: 30px auto;
        border: none;
        border-radius: 8px;
        background-color: #222222;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.5);
    }
    #table th, #table td {
        padding: 15px;
        text-align: center;
        border-bottom: 1px solid #333;
    }
    #table th {
        background-color: #111;
        color: #e50914;
        font-size: 16px;
    }
    #table td {
        color: #e5e5e5;
        font-size: 14px;
    }
    #table tr:nth-child(even) {
        background-color: #333;
    }

    /* 검색 폼 스타일 */
    .search-form {
        display: flex;
        justify-content: center;
        margin: 20px;
    }
    .search-form input[type="text"] {
        width: 400px;
        height: 40px;
        padding: 0 15px;
        border: none;
        border-radius: 25px;
        font-size: 16px;
        background-color: #333;
        color: #fff;
    }
    .search-form button {
        padding: 0 20px;
        background-color: #e50914;
        border: none;
        color: #fff;
        font-size: 16px;
        border-radius: 25px;
        cursor: pointer;
        margin-left: 10px;
    }
    .search-form button:hover {
        background-color: #b20710;
    }

    /* 페이징 스타일 */
    #page {
        text-align: center;
        margin-top: 20px;
    }
    #page a {
        display: inline-block;
        padding: 8px 16px;
        margin: 0 5px;
        text-decoration: none;
        color: #fff;
        background-color: #333;
        border-radius: 20px;
    }
    #page a:hover {
        background-color: #e50914;
    }

    /* 링크 스타일 */
    #table tr {
        cursor: pointer;
    }

</style>
</head>
<body>
    <h1>Film List</h1>

    <form class="search-form" action="filmList.jsp">
        <input type="text" name="searchWord" value="<%= searchWord %>" placeholder="Search by title...">
        <button type="submit">Search</button>
    </form>

    <table id="table">
        <tr>
            <th>Film ID</th>
            <th>Title</th>
            <th>Description</th>
            <th>Release Year</th>
            <th>Rental Rate</th>
            <th>Actors</th>
        </tr>
        <% for (HashMap<String, Object> map : list) { %>
        <tr onclick="location.href='filmOne.jsp?filmId=<%= map.get("filmId") %>'">
            <td><%= map.get("filmId") %></td>
            <td><%= map.get("title") %></td>
            <td><%= map.get("description") %></td>
            <td><%= map.get("releaseYear") %></td>
            <td><%= map.get("rentalRate") %></td>
            <td><%= map.get("actorName") %></td>
        </tr>
        <% } %>
    </table>

    <!-- 페이징 -->
    <div id="page">
        <% if (currentPage > 1) { %>
            <a href="filmList.jsp?searchWord=<%= searchWord %>&currentPage=1">First</a>
            <% if (currentPage > 10) { %>
                <a href="filmList.jsp?searchWord=<%= searchWord %>&currentPage=<%= currentPage - 10 %>">Previous (-10)</a>
            <% } %>
        <% } %>

        <% for (int i = Math.max(1, currentPage - 4); i <= Math.min(lastPage, currentPage + 5); i++) { %>
            <a href="filmList.jsp?searchWord=<%= searchWord %>&currentPage=<%= i %>">
                <%= (i == currentPage) ? "<b>" + i + "</b>" : i %>
            </a>
        <% } %>

        <% if (currentPage < lastPage) { %>
            <a href="filmList.jsp?searchWord=<%= searchWord %>&currentPage=<%= currentPage + 10 %>">Next (+10)</a>
            <a href="filmList.jsp?searchWord=<%= searchWord %>&currentPage=<%= lastPage %>">Last</a>
        <% } %>
    </div>
</body>
</html>
