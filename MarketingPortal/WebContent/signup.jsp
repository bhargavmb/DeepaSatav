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
<% 
String userdbNm;
String userdbEmail;
String userdbName;
String userdbPsw;
String dbUsertype;

Connection con= null;
PreparedStatement ps = null;
ResultSet rs = null;

String driverName = "com.mysql.jdbc.Driver";
String url = "jdbc:mysql://localhost:3306/marketingportal";
String user = "root";
String dbpsw = "root";

String sql = "insert into user(usertype,username,password,email,name,website_id) values(?,?,?,?,?,?)";

String name = request.getParameter("name");
String username = request.getParameter("username");
String email = request.getParameter("email");
String password = request.getParameter("password");
String webid="";

String sqls="SELECT * FROM user where username='"+username+"'";

if(!email.equalsIgnoreCase("")){
	try{
		Class.forName(driverName);
		con = DriverManager.getConnection(url, user, dbpsw);

		ps = con.prepareStatement(sqls);
		ResultSet rr=ps.executeQuery();
		boolean isExist=false;
		while(rr.next()){
			isExist=true;
			break;
		}
		if(isExist){
			%>
			<center><p style="color:red">Not able to signup, Username already Exist</p></center>
		    <% 
	 	    //out.println(sqe);
		    getServletContext().getRequestDispatcher("/index.jsp").include(request, response);
		    return;
		}
		
		ps = con.prepareStatement(sql);
		ps.setString(1, "FLIPKART");
		ps.setString(2, username);
		ps.setString(3, password);
		ps.setString(4, email);
		ps.setString(5, name);
		ps.setString(6, "1");
		int x=ps.executeUpdate();
		
		ps.close();
		
		ps = con.prepareStatement(sql);
		ps.setString(1, "AMAZON");
		ps.setString(2, username);
		ps.setString(3, password);
		ps.setString(4, email);
		ps.setString(5, name);
		ps.setString(6, "2");
		x=ps.executeUpdate();
		
		ps.close();

		ps = con.prepareStatement(sql);
		ps.setString(1, "SNAPDEAL");
		ps.setString(2, username);
		ps.setString(3, password);
		ps.setString(4, email);
		ps.setString(5, name);
		ps.setString(6, "3");
		x=ps.executeUpdate();
		if(x>0)
		{			
			response.sendRedirect("index.jsp");
		}
		else
			response.sendRedirect("error.jsp");
		
		ps.close();

		
		con.close();
		}
	catch(SQLException sqe)
	{
		%>
		<center><p style="color:red">Error In Signup</p></center>
		<% 
		//out.println(sqe);
		getServletContext().getRequestDispatcher("/index.jsp").include(request, response);
		return;
	}
}
else
{
	%>
		<center><p style="color:red">Error In Signup</p></center>
	<% 
	getServletContext().getRequestDispatcher("/index.jsp").include(request, response);
	return;
}

    %>
</body>
</html>