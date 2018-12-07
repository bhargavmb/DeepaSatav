<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import="java.sql.*,java.util.*" %>
<%
Connection con= null;
PreparedStatement ps = null;
ResultSet rs = null;

String driverName = "com.mysql.jdbc.Driver";
String url = "jdbc:mysql://localhost:3306/marketingportal";
String user = "root";
String dbpsw = "root";

String sql = "delete from reviews where id in (select reviews.id from reviews,products,website,user where reviews.product_id=products.id && reviews.user_id=user.id && reviews.website_id=website.id group by reviews.product_id,reviews.user_id,reviews.website_id having count(*)>1)";

	try {
		Class.forName(driverName);
		con = DriverManager.getConnection(url, user, dbpsw);
		ps = con.prepareStatement(sql);
		int x=ps.executeUpdate();
		if(x>0){
			response.sendRedirect("admin_manage_review.jsp");
		}else{
			response.sendRedirect("error.jsp");
		}
		ps.close();
		con.close();
	} catch (SQLException sqe) {
		out.println(sqe);
	}
%>       
    