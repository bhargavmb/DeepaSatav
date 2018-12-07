<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import="java.sql.*,java.util.*" %>
        <%@ page import="java.security.*" %>
    <%@ page import="HashAlgo.*" %>
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
<link rel="stylesheet" href="./css/bootstrap-theme.min.css"/>
<script src="./js/jquery.min.js"></script>
<script src="./js/bootstrap.min.js"></script>
<link href="./images/favicon.ico" rel="icon" type="image/x-icon"/><!-- main window icon-->
<link rel="stylesheet" href="./css/jquery.dataTables.min.css"/>
<script type="text/javascript" src="./js/jquery.dataTables.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
    $('#example').DataTable();
} );
</script>

</head>
<body>
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
                    <li>
                        <a href="Graph.jsp"><i class="fa fa-fw fa-table"></i> View Graph</a>
                    </li> 
                </ul>
            </div>
            <!-- /.navbar-collapse -->
        </nav>

        <div id="page-wrapper">

            <div class="container-fluid">
<br><div align="center"><h3>Review Details</h3></div>

 <!-- <div class="filter">
 <form action="#" method="post">
						   <div class="col-sm-2">
						     <button type="submit" class="btn btn-default">Refresh</button>
						    </div>
						    </form>
			 <form class="form-horizontal" role="form" method="post" action="#" >
						  <div class="form-group">
						    
						    <div class="col-sm-2">
						      <input type="text" class="form-control" name="ip_address" id="ip_address"  placeholder="Ip Address" >
						    </div>
						     <div class="col-sm-2">
						      <input type="text" class="form-control" name="pname" id="pname"  placeholder="Product Name" >
						    </div>
						     <div class="col-sm-2">
						      <input type="text" class="form-control" name="ot" id="ot"  placeholder="Enter OT Ex. RAM /SCREEN " >
						    </div>
						     <div class="col-sm-2">
						      <input type="text" class="form-control" name="ow" id="ow" placeholder="Enter OW Ex. Good or Bad" >
						    </div>
						    <div class="col-sm-1">
						     <button type="submit" class="btn btn-default">Search</button>
						    </div>
						  </div>
						
						</form>
				  	 			
				</div> -->
             
                <!-- Page Heading -->
                <div class="row">
                
                

<%!
public static String bytesToHex(byte[]  b) 
{
char hexDigit[] = {'0', '1', '2', '3', '4', '5', '6', '7',
'8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};
StringBuffer buffer = new StringBuffer();
for (int j=0; j<b.length; j++) {
buffer.append(hexDigit[(b[j] >> 4) & 0x0f]);
buffer.append(hexDigit[b[j] & 0x0f]);
}
//return the elements inside the buffer 
return buffer.toString();
} 

%>  

            
<%
Connection con= null;
PreparedStatement ps = null;
ResultSet rs = null;

String driverName = "com.mysql.jdbc.Driver";
String url = "jdbc:mysql://localhost:3306/marketingportal";
String user = "root";
String dbpsw = "root";

String ip = request.getParameter("ip_address");
String uname = request.getParameter("uname");
String pname= request.getParameter("pname");
String ot= request.getParameter("ot");
String ow = request.getParameter("ow");

System.out.println("User Name : "+uname+ " Product Name : "+pname+ " OT : "+ot+ " OW : "+ow);

String sqlsearch = "select reviews.id as review_id,reviews.ip_address,website.name as webname,user.username,products.name as productname,reviews.review from reviews,products,website,user where reviews.product_id=products.id && reviews.user_id=user.id && reviews.website_id=website.id && reviews.product_id="+request.getParameter("product_id")+" && reviews.user_id="+request.getParameter("user_id")+" && reviews.website_id="+request.getParameter("website_id")+" && ip_address like '%" + ip + "%' && products.name like'%" + pname + "%' && reviews.review like '%" + ot + "%' && reviews.review like '%" + ow + "%' ";

String sql = "select count(reviews.review) as SameReviewCount, reviews.review, reviews.id as review_id,website.name as webname,reviews.ip_address,user.username as username,products.name as productname from reviews,products,website,user where reviews.product_id=products.id && reviews.user_id=user.id && reviews.website_id=website.id && reviews.product_id="+request.getParameter("product_id")+" && reviews.user_id="+request.getParameter("user_id")+" && reviews.website_id="+request.getParameter("website_id")+" group by reviews.review order by review,reviews.id,user.username";

if(uname==null && pname==null && ot==null && ow==null)
{
	try {
		
String input = "";
		
		MessageDigest mds = MessageDigest.getInstance("SHA1");				
		System.out.println("Message digest: ");
		System.out.println("   Used Algorithm = "+mds.getAlgorithm());
		System.out.println("   Provider for the algorithm = "+mds.getProvider());
		System.out.println("   Convert it   toString = "+mds.toString());	
		
		
		Class.forName(driverName);
		con = DriverManager.getConnection(url, user, dbpsw);
		ps = con.prepareStatement(sql);
		rs = ps.executeQuery();
		out.println("<table id='example' class='table table-bordered'>");
		out.println("<thead>");
		out.println("<tr>");
		out.println("<th>website</th>");
		out.println("<th>Ip Address</th>");
		out.println("<th>User Name</th>");
		out.println("<th>product</th>");
		out.println("<th>Review</th>");
		out.println("<th>Count</th>");
		out.println("<th>Hashed review</th>");
		out.println("</tr>");
		out.println("</thead>");
		out.println("<tbody>");

		while (rs.next()) {
			input = rs.getString("review");
			byte[] output = mds.digest();
			mds.update(input.getBytes()); 
			output = mds.digest();
			System.out.print("SHA1(\""+input+"\") =");
			String hash = input;
			System.out.println("   "+bytesToHex(output));
			
			out.println("<tr>");
			out.println("<td>"+rs.getString("webname")+"</td>");
			out.println("<td>"+rs.getString("ip_address")+"</td>");
			out.println("<td>"+rs.getString("username")+"</td>");
			out.println("<td>"+rs.getString("productname")+"</td>");
			out.println("<td>"+rs.getString("review")+"</td>");
			
			out.println("<td>"+rs.getString("SameReviewCount")+"</td>");
			out.println("<td>"+bytesToHex(output)+"</td>");
				out.println("</tr>");
		}
		out.println("</tbody>");
		out.println("</table>");

		rs.close();
		ps.close();
		con.close();
	} catch (SQLException sqe) {
		out.println(sqe);
	}
}	
	
	else{
		try {
			Class.forName(driverName);
			con = DriverManager.getConnection(url, user, dbpsw);
			ps = con.prepareStatement(sqlsearch);
			rs = ps.executeQuery();
			out.println("<table class='table table-bordered'>");
			out.println("<thead>");
			out.println("<tr>");
			out.println("<th>website</th>");
			out.println("<th>Ip Address</th>");
			out.println("<th>product</th>");
			out.println("<th>review</th>");
			out.println("<th></th>");
			out.println("</tr>");
			out.println("</thead>");
			out.println("<tbody>");

			while (rs.next()) {
				out.println("<tr>");
				out.println("<td>"+rs.getString("webname")+"</td>");
				out.println("<td>"+rs.getString("ip_address")+"</td>");
				out.println("<td>"+rs.getString("productname")+"</td>");
				out.println("<td>"+rs.getString("review")+"</td>");
				out.println("<td><a href='admin_delete_review.jsp?review_id="+rs.getString("review_id")+"'>Delete</a></td>");
				out.println("</tr>");
			}
			out.println("</tbody>");
			out.println("</table>");

			rs.close();
			ps.close();
			con.close();
		} catch (SQLException sqe) {
			out.println(sqe);
		}
	}
%>       
         <div style="height:1000px"></div>       
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