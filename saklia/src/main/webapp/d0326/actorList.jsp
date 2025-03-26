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

// 검색값 설정
String searchActorName = request.getParameter("searchWord") != null ? request.getParameter("searchWord") : "";

String countSql = "SELECT COUNT(DISTINCT a.actor_id) FROM actor a " +
                  "JOIN film_actor fa ON a.actor_id = fa.actor_id " +
                  "JOIN film f ON fa.film_id = f.film_id";

if (!searchActorName.equals("")) {
    countSql += " WHERE CONCAT(a.first_name, ' ', a.last_name) LIKE ? ";
}

stmt = conn.prepareStatement(countSql);
int paramIndex = 1;
if (!searchActorName.equals("")) {
    stmt.setString(paramIndex++, "%" + searchActorName + "%");
}

rs = stmt.executeQuery();
if (rs.next()) {
    totalCount = rs.getInt(1);
}

int lastPage = (totalCount + rowPerPage - 1) / rowPerPage; // 전체 페이지 수 계산

// 검색된 데이터 조회
ArrayList<HashMap<String, Object>> list = new ArrayList<>();

String sql = "SELECT DISTINCT CONCAT(a.first_name, ' ', a.last_name) AS actorName, GROUP_CONCAT(f.title) AS filmTitle " +
             "FROM actor a " +
             "INNER JOIN film_actor fa ON a.actor_id = fa.actor_id " +
             "INNER JOIN film f ON fa.film_id = f.film_id ";

if (!searchActorName.equals("")) {
    sql += " WHERE CONCAT(a.first_name, ' ', a.last_name) LIKE ? ";  
}

sql += " GROUP BY a.actor_id ORDER BY actorName LIMIT ?, ?"; // 페이징 처리

stmt = conn.prepareStatement(sql);
paramIndex = 1;
if (!searchActorName.equals("")) {
    stmt.setString(paramIndex++, "%" + searchActorName + "%"); 
}
stmt.setInt(paramIndex++, startRow);
stmt.setInt(paramIndex, rowPerPage);

rs = stmt.executeQuery();

while (rs.next()) {
    HashMap<String, Object> map = new HashMap<>();
    map.put("actorName", rs.getObject("actorName"));
    map.put("filmTitle", rs.getObject("filmTitle"));
    list.add(map);
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Actor List</title>
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
        width: 80%;
        margin: 20px auto;
        border: 1px solid black;
        border-radius: 10px;
    }
    #table th, #table td {
        border: 1px solid black;
        padding: 10px;
        text-align: center;
    }
    #table tr:nth-child(even) {
        background-color: #f2f2f2;
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
    #currentPage a {
        font-weight: bold;
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
    <h1>Actor List</h1>

    <!-- 검색 폼 추가 -->
    <form class="search-form" action="actorList.jsp">
        <input type="text" name="searchWord" value="<%= searchActorName %>" placeholder="배우 이름 검색">
        <button type="submit">검색</button>
    </form>
     <a href="http://localhost/sakila/d0326/filmList.jsp">
        <button style="padding: 10px 20px; border-radius: 20px; background-color: #1ec800; color: white; font-size: 16px; border: none; cursor: pointer;">
            영화목록
        </button>
    </a>

    <table id="table">
        <tr>
            <th>배우 이름</th>
            <th>대표작</th>
        </tr>
        <% for (HashMap<String, Object> map : list) { %>
        <tr>
            <td><%= map.get("actorName") %></td>
            <td><%= map.get("filmTitle") %></td>
        </tr>
        <% } %>
    </table>
	
    <!-- 페이징 -->
     <div style="text-align: center; margin-top: 20px;">
 
</div>
    <div id="page">
        <% if (currentPage > 1) { %>
            <a href="actorList.jsp?searchWord=<%= searchActorName %>&currentPage=1">처음</a>
            <% if (currentPage > 10) { %>
                <a href="actorList.jsp?searchWord=<%= searchActorName %>&currentPage=<%= currentPage - 10 %>">이전 (-10)</a>
            <% } %>
        <% } %>

        <% for (int i = Math.max(1, currentPage - 4); i <= Math.min(lastPage, currentPage + 5); i++) { %>
            <a href="actorList.jsp?searchWord=<%= searchActorName %>&currentPage=<%= i %>">
                <%= (i == currentPage) ? "<b>" + i + "</b>" : i %>
            </a>
        <% } %>

        <% if (currentPage < lastPage) { %>
            <a href="actorList.jsp?searchWord=<%= searchActorName %>&currentPage=<%= currentPage + 10 %>">다음 (+10)</a>
            <a href="actorList.jsp?searchWord=<%= searchActorName %>&currentPage=<%= lastPage %>">마지막</a>
        <% } %>
        
    </div>
   
</body>
</html>
