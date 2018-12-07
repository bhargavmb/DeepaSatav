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

String review_id = request.getParameter("review_id");
String sqldelete_ot_status = "delete from ot_status where review_id="+review_id+" ";


String sql = "delete from reviews where id="+request.getParameter("review_id");
try {
	Class.forName(driverName);
	con = DriverManager.getConnection(url, user, dbpsw);
	ps = con.prepareStatement(sqldelete_ot_status);
	int x1=ps.executeUpdate();
	
	ps.close();
	
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
} catch (SQLException sqe) {
	out.println(sqe);
}
	
%>       
    