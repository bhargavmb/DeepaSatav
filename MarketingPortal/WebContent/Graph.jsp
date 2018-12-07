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
<link href="./css/sb-admin.css" rel="stylesheet">
<link href="css/style.css" rel="stylesheet" type="text/css" media="all"/>
<link rel="stylesheet" href="./css/bootstrap-theme.min.css"/>
<script src="./js/jquery.min.js"></script>
<script src="./js/bootstrap.min.js"></script>
<link href="./images/favicon.ico" rel="icon" type="image/x-icon"/><!-- main window icon-->
</head>
<body>
<%
Connection con= null;
PreparedStatement ps = null;
ResultSet rs = null;

String driverName = "com.mysql.jdbc.Driver";
String url = "jdbc:mysql://localhost:3306/marketingportal";
String user = "root";
String dbpsw = "root";

//String subcategory_id=request.getAttribute("subcategory_id").toString();
String website_id=request.getParameter("website_id");

if(website_id==null)website_id="1";
if(website_id.equals(""))website_id="1";
String product_sql="select * from products where website_id="+website_id;

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
                     <!-- <li>
                        <a href="admin_manage_review.jsp"><i class="fa fa-fw fa-table"></i> Manage Reviews</a>
                    </li> -->
                    <li>
                        <a href="admin_manage_reviewbyip.jsp"><i class="fa fa-fw fa-table"></i> Manage Reviews By Ip address</a>
                    </li> 
                    <li>
                        <a href="HashReview.jsp"><i class="fa fa-fw fa-table"></i> Manage Reviews</a>
                    </li>
                   <li class="active">
                        <a href="Graph.jsp"><i class="fa fa-fw fa-table"></i> View Graph</a>
                    </li> 
                </ul>
            </div>
            <!-- /.navbar-collapse -->
        </nav>

        <div id="page-wrapper">

            <div class="container-fluid">

                <!-- Page Heading -->
                <div class="row">
                <br><br><br>
                <label>Select Website :</label>
                <select id="chng" onchange="window.location='Graph.jsp?website_id='+this.options[this.selectedIndex].value">
                <%
                if(website_id.equals("1")){
                    out.println("<option value='1' selected>FLIPKART</option>");
                    out.println("<option value='2'>AMAZON</option>");
                    out.println("<option value='3'>SNAPDEAL</option>");
                }
				if(website_id.equals("2")){
                    out.println("<option value='1'>FLIPKART</option>");
                    out.println("<option value='2' selected>AMAZON</option>");
                    out.println("<option value='3'>SNAPDEAL</option>");
          
                }
				if(website_id.equals("3")){
                    out.println("<option value='1'>FLIPKART</option>");
                    out.println("<option value='2'>AMAZON</option>");
                    out.println("<option value='3' selected>SNAPDEAL</option>");
				}	
                	
                %>
                                </select>
   <div class="content_bottom">
    		<div class="heading">
    		<h3>All Products</h3>
    		</div>
    		<div class="see">
    		</div>
    		<div class="clear"></div>
    	</div>
   
   <%
	try{
		Class.forName(driverName);
		con = DriverManager.getConnection(url, user, dbpsw);
		ps = con.prepareStatement(product_sql);		
		rs = ps.executeQuery();
		
		int i=1;
		int chk=0;
		
		while(rs.next() )
		{	
			
			
			if(i==1)out.println("<div class='section group'>");

			out.println("<div class='grid_1_of_4 images_1_of_4'>");
			 out.println("<a href='admin_view_ot_ow.jsp?product_id="+rs.getString("id")+"'><img src='.\\"+rs.getString("image_path")+"' alt='' /></a>"); 
			 /* out.println("<img src='.\\"+rs.getString("image_path")+"' alt='' /></a>"); */
			 out.println("<h2>"+rs.getString("name")+"</h2>");
			out.println("<div class='price-details'>");
		       out.println("<div class='price-number'>");
					out.println("<p><span class='rupees'>"+rs.getString("price")+"</span></p>");
			    out.println("</div>");
			       		out.println("<div class='add-cart'>");
							out.println("<h4><a href='viewgraph.jsp?website_id="+rs.getString("website_id")+"&subcategory_id="+rs.getString("subcategory_id")+"&name="+rs.getString("name")+"&product_id="+rs.getString("id")+"'>Graph</a></h4>");
					     out.println("</div>");
					 out.println("<div class='clear'></div>");
			out.println("</div>");
		    out.println("</div>");
						
			if(i==4){
				out.println("</div>");
				chk=1;
				i=1;
			}else{
				chk=0;
				i++;
			}
			
		}
		if(chk==0)out.println("</div>");
		rs.close();
		ps.close();	
		con.close();
		}
	catch(SQLException sqe)
	{
		out.println(sqe);
	}

   %>       
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