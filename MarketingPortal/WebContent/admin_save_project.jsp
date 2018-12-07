<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*,java.util.*" %>

<%! 
String pname;
String pdesc;
String pcat;
String pfile;
String pprice;
String subCat;
String brand;
%>

<%
pname = request.getParameter("pname");
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

String sql = "insert into products(name,description,price,category_id,image_path,website_id,brand_id,subcategory_id) values(?,?,?,?,?,?,?,?)";

List<Integer> ss=new ArrayList<Integer>();

	try{
		Class.forName(driverName);
		con = DriverManager.getConnection(url, user, dbpsw);
		ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
		ps.setString(1, pname);
		ps.setString(2, pdesc);
		ps.setString(3, pprice);
		ps.setString(4, pcat);
		ps.setString(5, "uploads\\images\\"+pfile);
		ps.setString(6, "1");
		ps.setString(7,brand);
		ps.setString(8, subCat);
		if(ps.executeUpdate()==0)
		{			
			response.sendRedirect("error.jsp");
		}
		rs = ps.getGeneratedKeys();
        if(rs.next())
        {
            int last_inserted_id = rs.getInt(1);
            ss.add(last_inserted_id);
        }
        rs.close();
		ps.close();
		
		ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
		ps.setString(1, pname);
		ps.setString(2, pdesc);
		ps.setString(3, pprice);
		ps.setString(4, pcat);
		ps.setString(5, "uploads\\images\\"+pfile);
		ps.setString(6, "2");
		ps.setString(7,brand);
		ps.setString(8, subCat);
		if(ps.executeUpdate()==0)
		{			
			response.sendRedirect("error.jsp");
		}				
		rs = ps.getGeneratedKeys();
        if(rs.next())
        {
            int last_inserted_id = rs.getInt(1);
            ss.add(last_inserted_id);
        }
        rs.close();
		ps.close();

		ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
		ps.setString(1, pname);
		ps.setString(2, pdesc);
		ps.setString(3, pprice);
		ps.setString(4, pcat);
		ps.setString(5, "uploads\\images\\"+pfile);
		ps.setString(6, "3");
		ps.setString(7,brand);
		ps.setString(8, subCat);
		int x=ps.executeUpdate();
		if(x>0)
		{			
			response.sendRedirect("admin_add_product.jsp");
		}
		else
			response.sendRedirect("error.jsp");
		
		rs = ps.getGeneratedKeys();
        if(rs.next())
        {
            int last_inserted_id = rs.getInt(1);
            ss.add(last_inserted_id);
        }
        rs.close();
		ps.close();

		
		con.close();
		}catch(SQLException sqe){
		out.println(sqe);
		}
///////////
String sqlgetot="select * from ots where subcategory_id="+subCat;
List<String> sll=new ArrayList<String>();
	try{
		
		Class.forName(driverName);
		con = DriverManager.getConnection(url, user, dbpsw);
		ps = con.prepareStatement(sqlgetot);
		rs=ps.executeQuery();
		while(rs.next()){
		sll.add(rs.getString("name"));	
		}
		ps.close();
		con.close();
		}catch(SQLException sqe){
		out.println(sqe);
		}
///////////////////
	sql = "insert into product_ot(name,product_id) values(?,?)";
	String gg=request.getParameter("ot");
	//String []ggg=gg.split(",");
	
	try{
		Class.forName(driverName);
		con = DriverManager.getConnection(url, user, dbpsw);
		ps = con.prepareStatement(sql);

		for(int d:ss){
				for(String h:sll){
					ps.setString(1,h);
					ps.setInt(2,d);
					if(ps.executeUpdate()==0)
					{			
						response.sendRedirect("error.jsp");
					}
				}
		}
		ps.close();
		
		
		con.close();
		}catch(SQLException sqe){
		out.println(sqe);
		}
	

%>
