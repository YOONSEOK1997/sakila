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

String countSql = "SELECT COUNT(*) "+
		"FROM "+
		"(SELECT i.inventory_id, f.title "+
		"FROM inventory i "+
		  "INNER JOIN  "+
		      "film f "+
		   "ON i.film_id = f.film_id) t1 "+
		      "LEFT OUTER JOIN "+
		         "(SELECT inventory_id, rental_date, "+
		               "CASE WHEN return_date IS NULL THEN '대여불가' "+
		                    "ELSE '대여가능' END isRental "+    
		         "FROM rental "+
		         "WHERE (inventory_id, rental_date) "+
		               "IN (SELECT inventory_id, MAX(rental_date) "+
		                  "FROM rental "+
		                  "GROUP BY inventory_id)) t2 "+
		      "ON t1.inventory_id = t2.inventory_id";

if (!searchWord.equals("")) {
    countSql += " WHERE t1.title LIKE ? ";
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

String sql = "SELECT t1.inventory_id, t1.title, t2.isRental "+
"FROM "+
"(SELECT i.inventory_id, f.title "+
"FROM inventory i "+
  "INNER JOIN  "+
      "film f "+
   "ON i.film_id = f.film_id) t1 "+
      "LEFT OUTER JOIN "+
         "(SELECT inventory_id, rental_date, "+
               "CASE WHEN return_date IS NULL THEN '대여불가' "+
                    "ELSE '대여가능' END isRental "+    
         "FROM rental "+
         "WHERE (inventory_id, rental_date) "+
               "IN (SELECT inventory_id, MAX(rental_date) "+
                  "FROM rental "+
                  "GROUP BY inventory_id)) t2 "+
      "ON t1.inventory_id = t2.inventory_id";

	String whereClause = ""; // WHERE 절을 위한 변수

	if (!searchWord.equals("")) {
		sql += " WHERE t1.title LIKE ? ";  
	}

	//sql += " GROUP BY f.film_id, f.title, f.description, f.release_year, f.rental_rate "; 
	sql += " ORDER BY inventory_id DESC LIMIT ?, ?"; // 페이징 처리

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
    map.put("inventoryId", rs.getObject("inventory_id"));
    map.put("filmTitle", rs.getObject("title"));
    map.put("isRental", rs.getObject("isRental")); 
    list.add(map);
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Inventory List</title>
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
    <h1>INVENTORY LIST</h1>
    

    <form class="search-form" action="inventoryList.jsp">
        <input type="text" name="searchWord" value="<%= searchWord %>" placeholder="영화 제목 검색"
        >
        <button type="submit">검색</button>
    </form>

    <table id="table">
        <tr>
            <th>재고번호</th>
            <th>영화제목</th>
            <th>재고현황</th> 
        </tr>
        <% for (HashMap<String, Object> map : list) { %>
		<tr>
		    <td><%= map.get("inventoryId") %></td>
		    <td><%= map.get("filmTitle") %></td>
		    <td><%= map.get("isRental") %></td>	
		</tr>
        <% } %>
    </table>

   <!-- 페이징 -->
    <div id="page">
        <% if (currentPage > 1) { %>
            <a href="inventoryList.jsp?searchWord=<%= searchWord %>&currentPage=1">처음</a>
            <% if (currentPage > 10) { %>
                <a href="inventoryList.jsp?searchWord=<%= searchWord %>&currentPage=<%= currentPage - 10 %>">이전 </a>
            <% } %>
        <% } %>

        <% for (int i = Math.max(1, currentPage - 4); i <= Math.min(lastPage, currentPage + 5); i++) { %>
            <a href="inventoryList.jsp?searchWord=<%= searchWord %>&currentPage=<%= i %>">
                <%= (i == currentPage) ? "<b>" + i + "</b>" : i %>
            </a>
        <% } %>

        <% if (currentPage < lastPage) { %>
            <a href="inventoryList.jsp?searchWord=<%= searchWord %>&currentPage=<%= currentPage + 10 %>">다음 </a>
            <a href="inventoryList.jsp?searchWord=<%= searchWord %>&currentPage=<%= lastPage %>">마지막</a>
        <% } %>
    </div>
</body>
</html>