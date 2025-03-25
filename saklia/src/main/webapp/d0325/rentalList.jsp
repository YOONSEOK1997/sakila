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

int rowPerPage = 10; // 한 페이지당 출력할 개수
int startRow = (currentPage - 1) * rowPerPage;

/////////////////////////// store ID 검색 /////////////////////////
String searchStoreId = request.getParameter("storeId") != null ? request.getParameter("storeId") : "";
String searchWord = request.getParameter("searchWord") != null ? request.getParameter("searchWord") : "";

String countSql = "SELECT COUNT(*) " +
"FROM rental r " +
"INNER JOIN inventory i ON r.inventory_id = i.inventory_id " +
"INNER JOIN film f ON i.film_id = f.film_id " +
"INNER JOIN customer c ON r.customer_id = c.customer_id " +
"INNER JOIN store s ON i.store_id = s.store_id ";

if (!searchStoreId.equals("") && !searchStoreId.equals("0")) {
    countSql += " WHERE s.store_id = ? ";
}
if (!searchWord.equals("")) {
    countSql += " AND f.title LIKE ? ";
}

stmt = conn.prepareStatement(countSql);

int paramIndex = 1;
if (!searchStoreId.equals("") && !searchStoreId.equals("0")) {
    stmt.setInt(paramIndex++, Integer.parseInt(searchStoreId));
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
"r.rental_id AS rentalId, " +
"f.title AS filmTitle, " +
"i.inventory_id AS inventoryId, " +
"CONCAT(c.first_name, ' ', c.last_name, '(', c.customer_id, ')') AS customerName, " +
"r.rental_date AS rentalDate, " +
"r.return_date AS returnDate " +
"FROM rental r " +
"INNER JOIN inventory i ON r.inventory_id = i.inventory_id " +
"INNER JOIN film f ON i.film_id = f.film_id " +
"INNER JOIN customer c ON r.customer_id = c.customer_id " +
"INNER JOIN store s ON i.store_id = s.store_id ";

if (!searchStoreId.equals("") && !searchStoreId.equals("0")) {
    sql += " WHERE s.store_id = ? ";
}
if (!searchWord.equals("")) {
    sql += " AND f.title LIKE ? ";
}

sql += " ORDER BY returnDate ASC LIMIT ?, ?";

stmt = conn.prepareStatement(sql);
paramIndex = 1;
if (!searchStoreId.equals("") && !searchStoreId.equals("0")) {
    stmt.setInt(paramIndex++, Integer.parseInt(searchStoreId));
}
if (!searchWord.equals("")) {
    stmt.setString(paramIndex++, "%" + searchWord + "%");
}
stmt.setInt(paramIndex++, startRow);
stmt.setInt(paramIndex, rowPerPage);

rs = stmt.executeQuery();

while (rs.next()) {
    HashMap<String, Object> map = new HashMap<>();
    map.put("rentalId", rs.getObject("rentalId"));
    map.put("filmTitle", rs.getObject("filmTitle"));
    map.put("inventoryId", rs.getObject("inventoryId"));
    map.put("customerName", rs.getObject("customerName"));
    map.put("rentalDate", rs.getObject("rentalDate"));
    map.put("returnDate", rs.getObject("returnDate"));    
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
    width: 60%;
    text-align: center;
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
#currentPage a{
    font-weight: bold;
}
</style>
</head>
<body>
    <h1>Rental List</h1>
    
    <form action="rentalList.jsp" method="GET">
        StoreId :
        <select name="storeId"> 
            <option value="0" <%= searchStoreId.equals("0") ? "selected" : "" %>>전체</option>
            <option value="1" <%= searchStoreId.equals("1") ? "selected" : "" %>>1지점</option>
            <option value="2" <%= searchStoreId.equals("2") ? "selected" : "" %>>2지점</option>
        </select>
        <button type="submit">검색</button>
    </form>
    
    <form action="rentalList.jsp" method="GET">
        영화제목 : 
        <input type="text" name="searchWord" value="<%= searchWord %>">
        <button type="submit">검색</button>
    </form>

    <table id="table">
        <tr>
            <th>Rental ID</th>
            <th>Film Title</th>
            <th>Inventory ID</th>
            <th>Customer Name</th>
            <th>Rental Date</th>
            <th>Return Date</th>
        </tr>
        <% for (HashMap<String, Object> map : list) { %>
        <tr>
            <td><%= map.get("rentalId") %></td>
            <td><%= map.get("filmTitle") %></td>
            <td><%= map.get("inventoryId") %></td>
            <td><%= map.get("customerName") %></td>
            <td><%= map.get("rentalDate") %></td>
            <td><%= map.get("returnDate") %></td>
        </tr>
        <% } %>
    </table>

    <!-- 페이징 -->
    <div id="page">
        <% if (currentPage > 1) { %>
            <a href="rentalList.jsp?storeId=<%= searchStoreId %>&searchWord=<%= searchWord %>&currentPage=1">처음</a>
            <% if (currentPage > 10) { %>
                <a href="rentalList.jsp?storeId=<%= searchStoreId %>&searchWord=<%= searchWord %>&currentPage=<%= currentPage - 10 %>">이전 (-10)</a>
            <% } %>
        <% } %>

        <% for (int i = Math.max(1, currentPage - 4); i <= Math.min(lastPage, currentPage + 5); i++) { %>
            <a href="rentalList.jsp?storeId=<%= searchStoreId %>&searchWord=<%= searchWord %>&currentPage=<%= i %>">
                <%= (i == currentPage) ? "<b>" + i + "</b>" : i %>
            </a>
        <% } %>

        <% if (currentPage < lastPage) { %>
            <a href="rentalList.jsp?storeId=<%= searchStoreId %>&searchWord=<%= searchWord %>&currentPage=<%= currentPage + 10 %>">다음 (+10)</a>
            <a href="rentalList.jsp?storeId=<%= searchStoreId %>&searchWord=<%= searchWord %>&currentPage=<%= lastPage %>">마지막</a>
        <% } %>
    </div>
</body>
</html>