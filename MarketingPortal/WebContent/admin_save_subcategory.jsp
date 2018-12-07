<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
	<%@ page import="java.sql.*,java.util.*" %>

<%! 
String subname;
String pdesc;
String pcat;
String pfile;
String pprice;
String subCat;
String brand;
%>

<%
subname = request.getParameter("subname");
pdesc = request.getParameter("pdesc");
pcat = request.getParameter("pcat");
pfile = request.getParameter("pfile");
pprice = request.getParameter("pprice");
subCat = request.getParameter("subcategories");
brand = request.getParameter("brands"); 

System.out.println("Subcategory ID="+subCat);
Connection con= null;
PreparedStatement ps = null;
ResultSet rs = null;

String driverName = "com.mysql.jdbc.Driver";
String url = "jdbc:mysql://localhost:3306/marketingportal";
String user = "root";
String dbpsw = "root";

String sql = "insert into subcategories(name,category_id) values(?,?)";

try{
	 Class.forName(driverName);
		con = DriverManager.getConnection(url, user, dbpsw);
		ps = con.prepareStatement(sql);
		ps.setString(1, subname);
		ps.setString(2, pcat);
		//rs = ps.executeUpdate();
		int x=ps.executeUpdate();
		if(x>0)
		{			
			response.sendRedirect("admin_add_categories.jsp");
		}
		else
			response.sendRedirect("error.jsp");
		
		ps.close();
		con.close();
		
}
catch(SQLException sqe)
{
	out.println(sqe);
}

///////////

///////////////////
	

%>
