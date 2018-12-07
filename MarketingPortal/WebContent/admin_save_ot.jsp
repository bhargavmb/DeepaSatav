<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*,java.util.*" %>

<%! 
String ot;
String pdesc;
String pcat2;
String pfile;
String pprice;
String subCat;
String brand;
%>

<%
ot = request.getParameter("ot");

pdesc = request.getParameter("pdesc");
pcat2 = request.getParameter("pcat2");
pfile = request.getParameter("pfile");
pprice = request.getParameter("pprice");
subCat = request.getParameter("subcategories2");
brand = request.getParameter("brands"); 

String s[] = ot.split(",");

System.out.println("Subcategory ID="+subCat);
System.out.println("OT="+s);
Connection con= null;
PreparedStatement ps = null;
ResultSet rs = null;

String driverName = "com.mysql.jdbc.Driver";
String url = "jdbc:mysql://localhost:3306/marketingportal";
String user = "root";
String dbpsw = "root";

String sql = "insert into ots(name,subcategory_id) values(?,?)";

try{
	int x;
	 Class.forName(driverName);
		con = DriverManager.getConnection(url, user, dbpsw);
		for(String g:s){
			
		ps = con.prepareStatement(sql);
		ps.setString(1, g);
		ps.setString(2, subCat);
		//rs = ps.executeUpdate();
		x=ps.executeUpdate();
		}
	response.sendRedirect("admin_add_categories.jsp");
		//response.sendRedirect("error.jsp");
		
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
