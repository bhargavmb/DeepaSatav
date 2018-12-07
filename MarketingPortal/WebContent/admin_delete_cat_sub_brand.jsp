<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*,java.util.*" %>

<%! 
String ot;
String pdesc;
String pcat;
String pfile;
String pprice;
String subCat;
String brand;
%>

<%
ot = request.getParameter("ot");
pdesc = request.getParameter("pdesc");
pcat = request.getParameter("pcat");
pfile = request.getParameter("pfile");
pprice = request.getParameter("pprice");
subCat = request.getParameter("subcategories");
brand = request.getParameter("brands"); 

System.out.println("Category ID="+pcat);
System.out.println("SubCategory ID="+subCat);
System.out.println("Brands ID="+brand);
Connection con= null;
PreparedStatement ps = null;
ResultSet rs = null;

String driverName = "com.mysql.jdbc.Driver";
String url = "jdbc:mysql://localhost:3306/marketingportal";
String user = "root";
String dbpsw = "root";

String sqlcat = "delete from categories where id ="+pcat;
String sqlsubcat = "delete from subcategories where id ="+subCat+" and category_id = "+pcat;
String sqlbrand = "delete from brands,subcategories using subcategories INNER JOIN brands where id ="+brand+" and subcategory_id = "+subCat;


try{
	 Class.forName(driverName);
		con = DriverManager.getConnection(url, user, dbpsw);
		ps = con.prepareStatement(sqlcat);
		
		int x=ps.executeUpdate();
		if(x>0)
		{			
			
			response.sendRedirect("admin_delete_categories.jsp");
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

try{
	 Class.forName(driverName);
		con = DriverManager.getConnection(url, user, dbpsw);
		ps = con.prepareStatement(sqlsubcat);
		
		int x1=ps.executeUpdate();
	
		ps.close();
		
		try{
			 Class.forName(driverName);
				con = DriverManager.getConnection(url, user, dbpsw);
				ps = con.prepareStatement(sqlbrand);
				
				int x2=ps.executeUpdate();
				if(x2>0)
				{			
					
					response.sendRedirect("admin_delete_categories.jsp");
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
		
		
}
catch(SQLException sqe)
{
	out.println(sqe);
}






///////////

///////////////////
	

%>
<script type="text/javascript"> window.onload = alertName; </script>