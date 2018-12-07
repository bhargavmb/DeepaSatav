<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*,java.util.*" %>

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
<link href="./images/favicon.ico" rel="icon" type="image/x-icon"/>
<link href="css/style.css" rel="stylesheet" type="text/css" media="all"/>
<script type="text/javascript" src="js/jquery-1.7.2.min.js"></script> 
<script type="text/javascript" src="js/move-top.js"></script>
<script type="text/javascript" src="js/easing.js"></script>
<script src="js/easyResponsiveTabs.js" type="text/javascript"></script>
<link href="css/easy-responsive-tabs.css" rel="stylesheet" type="text/css" media="all"/>
<link rel="stylesheet" href="css/global.css">
<script src="js/slides.min.jquery.js"></script><!-- main window icon-->

<script type="text/javascript">
$(document).ready(function() {
	
$('#subcategories').change(function(event) {
    var sports = $("#subcategories").val();
    $.get('GetBrandsServlet', {
            subcategoryId : sports
    }, function(response) {
console.log(response);
    var select = $('#brands');
    select.find('option').remove();
    select.append('<option value="">--Select--</option>');
      $.each(response, function(index, value) {
      $('<option>').val(value.id).text(value.name).appendTo(select);
  });
    });
});

$('#pcat').change(function(event) {
    var sports = $("#pcat").val();
    $.get('GetSubCategoriesServlet', {
            categoryId : sports
    }, function(response) {
console.log(response);
    var select = $('#subcategories');
    select.find('option').remove();
    select.append('<option value="">--Select--</option>');
      $.each(response, function(index, value) {
      $('<option>').val(value.id).text(value.name).appendTo(select);
  });
    });
});

    
});
</script>
<script type="text/javascript">
$(document).ready(function() {
	
$('#subcategories1').change(function(event) {
    var sports = $("#subcategories1").val();
    $.get('GetBrandsServlet', {
            subcategoryId : sports
    }, function(response) {
console.log(response);
    var select = $('#brands');
    select.find('option').remove();
    select.append('<option value="">--Select--</option>');
      $.each(response, function(index, value) {
      $('<option>').val(value.id).text(value.name).appendTo(select);
  });
    });
});

$('#pcat1').change(function(event) {
    var sports = $("#pcat1").val();
    $.get('GetSubCategoriesServlet', {
            categoryId : sports
    }, function(response) {
console.log(response);
    var select = $('#subcategories1');
    select.find('option').remove();
    select.append('<option value="">--Select--</option>');
      $.each(response, function(index, value) {
      $('<option>').val(value.id).text(value.name).appendTo(select);
  });
    });
});

    
});
</script>
<script type="text/javascript">
$(document).ready(function() {
	
$('#subcategories2').change(function(event) {
    var sports = $("#subcategories2").val();
    $.get('GetBrandsServlet', {
            subcategoryId : sports
    }, function(response) {
console.log(response);
    var select = $('#brands');
    select.find('option').remove();
    select.append('<option value="">--Select--</option>');
      $.each(response, function(index, value) {
      $('<option>').val(value.id).text(value.name).appendTo(select);
  });
    });
});

$('#pcat2').change(function(event) {
    var sports = $("#pcat2").val();
    $.get('GetSubCategoriesServlet', {
            categoryId : sports
    }, function(response) {
console.log(response);
    var select = $('#subcategories2');
    select.find('option').remove();
    select.append('<option value="">--Select--</option>');
      $.each(response, function(index, value) {
      $('<option>').val(value.id).text(value.name).appendTo(select);
  });
    });
});

    
});
</script>

</head>
<body>
<%

if(session.getAttribute("name")==null){
	response.sendRedirect("./index.jsp");
}
%>
<%
Map<String,String> categories=new HashMap<String,String>();
Map<String,String> categories1=new HashMap<String,String>();
Map<String,String> categories2=new HashMap<String,String>();
Connection con= null;
PreparedStatement ps = null;
ResultSet rs = null;

String driverName = "com.mysql.jdbc.Driver";
String url = "jdbc:mysql://localhost:3306/marketingportal";
String user = "root";
String dbpsw = "root";

String sql = "select * from categories order by id asc";

	try{
		Class.forName(driverName);
		con = DriverManager.getConnection(url, user, dbpsw);
		ps = con.prepareStatement(sql);
		rs = ps.executeQuery();
		while(rs.next())
		{			
			categories.put(rs.getString("id"),rs.getString("name"));
			categories1.put(rs.getString("id"),rs.getString("name"));
			categories2.put(rs.getString("id"),rs.getString("name"));
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
                    <li class="active">
                        <a href="admin_delete_categories.jsp"><i class="fa fa-fw fa-table"></i> Delete Cat/SubCat/Brands</a>
                    </li>
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
            
                <br><div align="center"><h3>Add Category/SubCategory/Brands</h3></div>
                <!-- Page Heading -->
                <div class="row">
	               
						
				<div id="horizontalTab">
				<ul class="resp-tabs-list">
					
					<li>Delete Category/SubCategory/Brands</li>
					<!-- <li>Add OT</li> -->
				
					<div class="clear"></div>
				</ul>
				<div class="resp-tabs-container">
	
				  	<!-- Add Brands -->
				  	 
				  	 <div class="brand">
				  		<form class="form-horizontal" role="form" method="post" action="/MarketingPortal/admin_delete_cat_sub_brand.jsp" onsubmit="return checkAddProduct(this)">
						  
						   <div class="form-group">
						    <label class="control-label col-sm-2" for="email">Select Category:</label>
						    <div class="col-sm-10">
						      <select class="form-control" id="pcat" name="pcat">
						      <option value="">--Select--</option>
				  	<% 				  	
				  	Iterator itr = categories1.entrySet().iterator();
				    while (itr.hasNext()) {
				        Map.Entry entry = (Map.Entry)itr.next();
				  	    String key = entry.getKey().toString();
				  	    String value = entry.getValue().toString();
				  	    out.println("<option value='"+key+"'>"+value+"</option>");
				  	    itr.remove();
				  	}
 				  	%>
							  </select>
						    </div>
						  </div>
						  
						   <div class="form-group">
						    <label class="control-label col-sm-2" for="email">Sub Category:</label>
						    <div class="col-sm-10">
						      <select class="form-control" id="subcategories" name="subcategories">
						      <option value="">--Select--</option>
							  </select>
						    </div>
						  </div>
						  
						 <div class="form-group">
						    <label class="control-label col-sm-2" for="email">Brands:</label>
						    <div class="col-sm-10">
						      <select class="form-control" id="brands" name="brands">
						      <option value="">--Select--</option>
							  </select>
						    </div>
						  </div>
						  
  					
						  <div class="form-group"> 
						    <div class="col-sm-offset-2 col-sm-10">
						      <button type="submit" class="btn btn-default">Delete</button>
						    </div>
						  </div>
						</form>
				  	 </div>
				  	 
				  
				  	 
	 		</div>
		 </div>
						<div style="height:500px"></div>
						
						
	
                </div>
                <!-- /.row -->
                
            </div>
            		
			
	     <script type="text/javascript">
    $(document).ready(function () {
        $('#horizontalTab').easyResponsiveTabs({
            type: 'default', //Types: default, vertical, accordion           
            width: 'auto', //auto or any width like 600px
            fit: true   // 100% fit in a container
        });
    });
    function checkReview(aaa){
    	if(aaa.review.value.trim().length==0)
    	{
    	aaa.review.focus();
    	return false;
    	}
    	return true;
    }
   </script>
            <!-- /.container-fluid -->

        </div>
        <!-- /#page-wrapper -->

    </div>
    <!-- /#wrapper -->

</body>
</html>