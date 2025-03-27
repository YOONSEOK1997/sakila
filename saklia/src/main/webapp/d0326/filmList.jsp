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
<html>
<head>
<meta charset="UTF-8">
<title>Rental List</title>
<style>
    body {
        margin: 0;
        padding: 5px;
        width: 100%;
        text-align: center;
    }
    h1{
        color : black;
    }
    #table {
        width: %;
        height: 500px;
        margin: 20px auto;
        border: 1px solid black;
        border-radius: 10px;
    }
    #table th, #table td {
        border: 1px solid black;
        padding: 10px;
        text-align: center;
        word-wrap: break-word; /* 단어가 테이블을 벗어나지 않게 함 */
    }
    #table tr:nth-child(even) {
        background-color: #f2f2f2;
    }
    #table td.description {
        max-width: 300px; /* 최대 너비 설정 */
        overflow: hidden;
        text-overflow: ellipsis; /* 넘치는 텍스트는 '...'으로 표시 */
        white-space: nowrap; /* 텍스트가 줄바꿈 되지 않게 함 */
    }
    #page {
        margin-top: 20px;
        text-align: center;
    }
    #page a {
        display: inline-block;
        padding: 4px 8px;
        margin: 0 5px;
        text-decoration: none;
        color: black;
        border: 1px solid black;
        border-radius: 15px;
    }
    #currentPage a{
        font-weight: bold;
    }

  
    #selBox{
        width : 100px;
        height: 37px;
        border-radius: 20px;
        border: 1px solid #1ec800;
        text-align: center;
    }
    .search-form {
        margin: 20px 0;
        display: flex;
        justify-content: center;
        align-items: center;
    }
    .search-form input[type="text"] {
        width: 400px;
        height: 35px;
        padding: 0 10px;
        border-radius: 20px;
        border: 1px solid #1ec800;
        font-size: 14px;
    }
    .search-form button {
        height: 35px;
        margin-left: 10px;
        padding: 0 20px;
        border-radius: 20px;
        border: none;
        background-color: #1ec800;
        color: white;
        font-size: 14px;
        cursor: pointer;
    }
    .search-form button:hover {
        background-color: #16b600;
    }
</style>

</head>
<body>
    <h1>FILM LIST</h1>
    

    <form class="search-form" action="filmList.jsp">
        <input type="text" name="searchWord" value="<%= searchWord %>" placeholder="영화 제목 검색"
        >
        <button type="submit">검색</button>
    </form>

    <table id="table">
        <tr>
            <th>영화ID</th>
            <th>제목</th>
            <th>설명</th> 
            <th>개봉년도</th>
            <th>요금</th>
            <th>주연</th>
        </tr>
        <% for (HashMap<String, Object> map : list) { %>
      <tr onclick="location.href='filmOne.jsp?filmId=<%= map.get("filmId") %>'" style="cursor: pointer;">
    <td><%= map.get("filmId") %></td>
    <td><%= map.get("title") %></td>
    <td class="description"><%= map.get("description") %></td> 
    <td><%= map.get("releaseYear") %></td>
    <td><%= map.get("rentalRate") %></td>
    <td><%= map.get("actorName") %></td>
</tr>
        <% } %>
    </table>

   <!-- 페이징 -->
    <div id="page">
        <% if (currentPage > 1) { %>
            <a href="filmList.jsp?searchWord=<%= searchWord %>&currentPage=1">처음</a>
            <% if (currentPage > 10) { %>
                <a href="filmList.jsp?searchWord=<%= searchWord %>&currentPage=<%= currentPage - 10 %>">이전 </a>
            <% } %>
        <% } %>

        <% for (int i = Math.max(1, currentPage - 4); i <= Math.min(lastPage, currentPage + 5); i++) { %>
            <a href="filmList.jsp?searchWord=<%= searchWord %>&currentPage=<%= i %>">
                <%= (i == currentPage) ? "<b>" + i + "</b>" : i %>
            </a>
        <% } %>

        <% if (currentPage < lastPage) { %>
            <a href="filmList.jsp?searchWord=<%= searchWord %>&currentPage=<%= currentPage + 10 %>">다음 </a>
            <a href="filmList.jsp?searchWord=<%= searchWord %>&currentPage=<%= lastPage %>">마지막</a>
        <% } %>
    </div>
</body>
</html>