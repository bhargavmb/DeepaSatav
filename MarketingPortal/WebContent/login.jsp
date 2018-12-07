<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Login</title>
</head>
<body>
<%! 
String userdbNm;
String userdbEmail;
String userdbName;
String userdbPsw;
String dbUsertype;
%>
<%
Connection con= null;
PreparedStatement ps = null;
ResultSet rs = null;

String driverName = "com.mysql.jdbc.Driver";
String url = "jdbc:mysql://localhost:3306/marketingportal";
String user = "root";
String dbpsw = "root";

String sql = "select * from user where username=? and password=? and usertype=?";

String sql_admin = "select * from admin where username=? and password=?";

String name = request.getParameter("username");
String password = request.getParameter("password");
String usertype = request.getParameter("usertype");

if(usertype.equalsIgnoreCase("ADMIN")){
	try{
		Class.forName(driverName);
		con = DriverManager.getConnection(url, user, dbpsw);
		ps = con.prepareStatement(sql_admin);
		ps.setString(1, name);
		ps.setString(2, password);
		rs = ps.executeQuery();
		if(rs.next())
		{			
			userdbName = rs.getString("username");
			userdbPsw = rs.getString("password");
			if(name.equals(userdbName) && password.equals(userdbPsw))
				{
					session.setAttribute("name",userdbName);					
					response.sendRedirect("admin_home.jsp");				
				}						   
		}
		else
			response.sendRedirect("error.jsp");
		rs.close();
		ps.close();	
		con.close();
		}
	catch(SQLException sqe)
	{
		out.println(sqe);
	}
}
else if(!usertype.equalsIgnoreCase("ADMIN"))
{
	try{
		Class.forName(driverName);
		con = DriverManager.getConnection(url, user, dbpsw);
		ps = con.prepareStatement(sql);
		ps.setString(1, name);
		ps.setString(2, password);
		ps.setString(3, usertype);
		rs = ps.executeQuery();
		if(rs.next())
		{			
			userdbNm = rs.getString("name");
			userdbEmail = rs.getString("email");
			userdbName = rs.getString("username");
			userdbPsw = rs.getString("password");
			dbUsertype = rs.getString("usertype");
			if(name.equals(userdbName) && password.equals(userdbPsw) && usertype.equals(dbUsertype))
				{
				session.setAttribute("name",userdbNm);
				session.setAttribute("email",userdbEmail);
					session.setAttribute("username",userdbName);
					session.setAttribute("usertype", dbUsertype);
					session.setAttribute("website_id", rs.getString("website_id"));
					session.setAttribute("user_id", rs.getString("id"));
					response.sendRedirect("user_home.jsp");				
				}						   
		}
		else
			response.sendRedirect("error.jsp");
		rs.close();
		ps.close();	
		con.close();
		}
	catch(SQLException sqe)
	{
		out.println(sqe);
	}	
}
else
{
	%>
		<center><p style="color:red">Error In Login</p></center>
		<% 
	getServletContext().getRequestDispatcher("/index.jsp").include(request, response);
}

%>
</body>
</html>