<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>MySQL 连接测试</title>
</head>
<body>
<h1>数据库连接测试</h1>
<%
    String url = "jdbc:mysql://192.168.211.200:3306/mydb?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    String user = "root";
    String password = "AppPass123!";
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, password);
        out.println("<p style='color:green'>✅ 数据库连接成功！</p >");
        
        stmt = conn.createStatement();
        rs = stmt.executeQuery("SELECT * FROM haha");
        
	out.println("<table border='1'><tr><th>ID</th><th>姓名");
        while (rs.next()) {
            out.println("<tr>");
            out.println("<td>" + rs.getInt("id") + "</td>");
            out.println("<td>" + rs.getString("name") + "</td>");
            out.println("</tr>");
        }
        out.println("</table>");
    } catch (Exception e) {
        out.println("<p style='color:red'>❌ 连接失败：" + e.getMessage() + "</p >");
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
        if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }
%>
</body>
</html>
