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
Map<String,String> ots=new HashMap<String,String>();
Connection con= null;
PreparedStatement ps = null;
ResultSet rs = null;

String driverName = "com.mysql.jdbc.Driver";
String url = "jdbc:mysql://localhost:3306/marketingportal";
String user = "root";
String dbpsw = "root";

String sql = "SELECT * FROM product_ot where product_id="+product_id;

	try{
		Class.forName(driverName);
		con = DriverManager.getConnection(url, user, dbpsw);
		
		ps = con.prepareStatement(sql);
		rs = ps.executeQuery();
		while(rs.next())
		{			
			ots.put(rs.getString("id"),rs.getString("name"));
		}
		rs.close();
		ps.close();	
		
		con.close();
		}
	catch(SQLException sqe)
	{
		out.println(sqe);
	}

%>

    <div id="wrapper">

        <!-- Navigation -->
        <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-ex1-collapse">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="#">MP Admin</a>
            </div>
            <!-- Top Menu Items -->
            <ul class="nav navbar-right top-nav">
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="fa fa-user"></i> <%=session.getAttribute("name")%><b class="caret"></b></a>
                    <ul class="dropdown-menu">
                        <li>
                            <a href="logout.jsp"><i class="fa fa-fw fa-power-off"></i> Log Out</a>
                        </li>
                    </ul>
                </li>
            </ul>
            <!-- Sidebar Menu Items - These collapse to the responsive navigation menu on small screens -->
            <div class="collapse navbar-collapse navbar-ex1-collapse">
                <ul class="nav navbar-nav side-nav">
                    <li>
                        <a href="admin_home.jsp"><i class="fa fa-fw fa-dashboard"></i> Dashboard</a>
                    </li>
                    <li>
                        <a href="admin_add_product.jsp"><i class="fa fa-fw fa-bar-chart-o"></i> Add Products</a>
                    </li>
                    <li>
                        <a href="admin_add_categories.jsp"><i class="fa fa-fw fa-table"></i> Add Cat/SubCat/Brands</a>
                    </li>
                   <!--  <li>
                        <a href="admin_delete_categories.jsp"><i class="fa fa-fw fa-table"></i> Delete Cat/SubCat/Brands</a>
                    </li> -->
                    <li>
                        <a href="admin_manage_product.jsp"><i class="fa fa-fw fa-table"></i> Manage Products</a>
                    </li>
                    <li>
                        <a href="admin_manage_review.jsp"><i class="fa fa-fw fa-table"></i> Manage Reviews</a>
                    </li>
                     <li>
                        <a href="admin_manage_reviewbyip.jsp"><i class="fa fa-fw fa-table"></i> Manage Reviews By Ip address</a>
                    </li> 
                    <li>
                        <a href="Graph.jsp"><i class="fa fa-fw fa-table"></i> View Graph</a>
                    </li> 
                    
                </ul>
            </div>
            <!-- /.navbar-collapse -->
        </nav>

        <div id="page-wrapper">

            <div class="container-fluid">
                <br><div align="center"><h3>Product OT and OW's</h3></div>
                <!-- Page Heading -->
                <div class="row">
	                
	                <form>
	                
	                <table class="table">
	                <tr><th>S.No</th><th>OT</th><th>OW's</th></tr>
	                <tbody>
	                
	                <% 				  	
				  	Iterator it = ots.entrySet().iterator();
            		int x=1;
				    while (it.hasNext()) {
				  	    out.println("<tr>");
				        Map.Entry entry = (Map.Entry)it.next();
				  	    String key = entry.getKey().toString();
				  	    String value = entry.getValue().toString();
				  	    
				  	    out.println("<td>"+(x++)+"</td>");
				  	    out.println("<td>"+value+"</td>");
				  	    
				  	    sql = "SELECT ow_main FROM ot_status where product_ot_id="+key;
				  	    String tempStr="";
				  		try{
				  			Class.forName(driverName);
				  			con = DriverManager.getConnection(url, user, dbpsw);
				  			
				  			ps = con.prepareStatement(sql);
				  			rs = ps.executeQuery();
				  			while(rs.next())
				  			{			
				  				tempStr=tempStr+rs.getString("ow_main")+", ";
				  			}
				  			rs.close();
				  			ps.close();	
				  			
				  			con.close();
				  			}
				  		catch(SQLException sqe)
				  		{
				  			out.println(sqe);
				  		}
				  	    if(tempStr==""){
				  		out.println("<td>Not present</td>");
				  	    }else{
				  	    	String ggk=tempStr.trim();
				  	    	tempStr=ggk.substring(0,ggk.length()-1);
				  	    	out.println("<td>"+tempStr+"</td>");
				  	    }
				  	    out.println("</tr>");
				  	    it.remove();
				  	}
 				  	%>
	                    
	                </tbody>
	                </table>
	                
					</form>
						<div style="height:500px"></div>
                </div>
                <!-- /.row -->
                
            </div>
            <!-- /.container-fluid -->

        </div>
        <!-- /#page-wrapper -->

    </div>
    <!-- /#wrapper -->

</body>
</html>