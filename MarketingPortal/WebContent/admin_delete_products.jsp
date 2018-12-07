<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*,java.util.*" %>
<%

if(session.getAttribute("name")==null){
	response.sendRedirect("./index.jsp");
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Marketing Portal</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width;initial-scale=1;maximum-scale=1.0;user-scalable=0;">
<link rel="stylesheet" href="./css/bootstrap.min.css"/>
<link rel="stylesheet" href="./css/bootstrap-theme.min.css"/>
<link href="./css/sb-admin.css" rel="stylesheet">
<script src="./js/jquery.min.js"></script>
<script src="./js/bootstrap.min.js"></script>
<link href="./images/favicon.ico" rel="icon" type="image/x-icon"/><!-- main window icon-->
</head>
<body>
<%
String product_id=request.getParameter("product_id");
System.out.println("Product ID :"+product_id);

Connection con= null;
PreparedStatement ps = null;
ResultSet rs = null;


String driverName = "com.mysql.jdbc.Driver";
String url = "jdbc:mysql://localhost:3306/marketingportal";
String user = "root";
String dbpsw = "root";

String sql = "delete from products where id="+product_id;
String sqlreview = "delete from reviews where product_id="+product_id;
String sqlotstatus = "delete from ot_status where product_id="+product_id;
try{
	 Class.forName(driverName);
		con = DriverManager.getConnection(url, user, dbpsw);
		ps = con.prepareStatement(sqlreview);
		//rs = ps.executeUpdate();
		int x=ps.executeUpdate();
		
		ps.close();
		
		 try{
			 Class.forName(driverName);
				con = DriverManager.getConnection(url, user, dbpsw);
				ps = con.prepareStatement(sql);
				//rs = ps.executeUpdate();
				int x2=ps.executeUpdate();
				
				
		 }
		catch(SQLException sqe)
		{
			out.println(sqe);
		}	
		 
}

catch(SQLException sqe)
{
	out.println(sqe);
}
try{
	 Class.forName(driverName);
		con = DriverManager.getConnection(url, user, dbpsw);
		ps = con.prepareStatement(sql);
		//rs = ps.executeUpdate();
		int x1=ps.executeUpdate();
	response.sendRedirect("admin_manage_product.jsp");
		
		
		ps.close();
		con.close();
		
}
catch(SQLException sqe)
{
	out.println(sqe);
}		
 
%>

    <!-- /#wrapper -->

</body>
</html>