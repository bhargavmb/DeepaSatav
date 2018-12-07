<%@page import="com.google.gson.Gson"%>
<%@page import="java.util.*"%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page language="java" import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>


	<%
		response.setContentType("text/html");
	
		String str = request.getParameter("queryString");
		System.out.println(str);
		String website_id = session.getAttribute("website_id").toString();

		try {
			String connectionURL = "jdbc:mysql://localhost:3306/marketingportal";
			Connection con;
			Class.forName("com.mysql.jdbc.Driver");
			// Get a Connection to the database
			con = DriverManager.getConnection(connectionURL, "root", "root");
			//Add the data into the database
			String sql = "SELECT distinct(name) FROM products  WHERE name LIKE '" + str + "%' and website_id="
					+ website_id + " LIMIT 10";
			Statement stm = con.createStatement();
			stm.executeQuery(sql);
			ResultSet rs = stm.getResultSet();
			List<String> items=new ArrayList<String>();
			
			while (rs.next()) {
				
			//items.add(rs.getString("name"));
			out.println("<li onclick='fill(" + rs.getString("name") + ");'>" + rs.getString("name") + "</i>");
			//out.println("<li onSelect='fill(" + rs.getString("name") + ");'>" + rs.getString("name") + "</i>");
			//System.out.println(rs.getString("name"));
			}
			//String name=new Gson().toJson(items);
			//response.getWriter().write(name);
		} catch (Exception e) {
			out.println("Exception is ;" + e);
		}
	%>

</body>
</html>