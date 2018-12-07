<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*,java.util.*" %>

<%! 
String pname;
String pdesc;
String pcat;
String pprice;
String pfile;
String pid;
String subCat;
String brand;

%>

<%
pid=request.getParameter("pid");
pname = request.getParameter("pname");
pdesc = request.getParameter("pdesc");
pcat = request.getParameter("pcat");
pprice = request.getParameter("pprice");
pfile = request.getParameter("pfile");
subCat = request.getParameter("subcategories");
brand = request.getParameter("brands");

Connection con= null;
PreparedStatement ps = null;
ResultSet rs = null;

String driverName = "com.mysql.jdbc.Driver";
String url = "jdbc:mysql://localhost:3306/marketingportal";
String user = "root";
String dbpsw = "root";

String sql = "update products set name=?,description=?,price=?,category_id=?,brand_id=?,image_path=? where id=?";

	try{
		Class.forName(driverName);
		con = DriverManager.getConnection(url, user, dbpsw);
		ps = con.prepareStatement(sql);
		ps.setString(1, pname);
		ps.setString(2, pdesc);
		ps.setString(3, pprice);
		ps.setString(4, pcat);
		ps.setString(5,brand);
		ps.setString(6, "uploads\\images\\"+pfile);
		ps.setString(7, pid);
		int x=ps.executeUpdate();
		if(x>0)
		{			
			response.sendRedirect("admin_manage_product.jsp");
		}
		else
			response.sendRedirect("error.jsp");
		
		ps.close();
		con.close();
		}catch(SQLException sqe){
		out.println(sqe);
		}

%>
