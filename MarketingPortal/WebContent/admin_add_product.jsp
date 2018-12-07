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
<link href="./images/favicon.ico" rel="icon" type="image/x-icon"/><!-- main window icon-->
<script type="text/javascript">
function checkAddProduct(aaa)
{
	if(aaa.pname.value.trim().length==0)
	{
	document.getElementById("productError").innerHTML="* name required";
	aaa.pname.focus();
	return false;
	}
	
	if(aaa.pdesc.value.trim().length==0)
	{
	document.getElementById("productError").innerHTML="* description required";
	aaa.pdesc.focus();
	return false;
	}

	
	if(aaa.pcat.value.trim().length==0)
	{
	document.getElementById("productError").innerHTML="* category required";
	aaa.pcat.focus();
	return false;
	}

	if(aaa.subcategories.value.trim().length==0)
	{
	document.getElementById("productError").innerHTML="* subcategory required";
	aaa.subcategories.focus();
	return false;
	}

	if(aaa.brands.value.trim().length==0)
	{
	document.getElementById("productError").innerHTML="* price required";
	aaa.brands.focus();
	return false;
	}

	if(aaa.pprice.value.trim().length==0)
	{
	document.getElementById("productError").innerHTML="* price required";
	aaa.pprice.focus();
	return false;
	}
	
	if(aaa.pfile.value.trim().length==0)
	{
	document.getElementById("productError").innerHTML="* file required";
	aaa.pfile.focus();
	return false;
	}
document.getElementById("productError").innerHTML="";
return true;
}


function uploadImage() {
	var fl = document.getElementById("pfile");
	var fls = fl.files;
	if (fls.length == 0) {
		alert('No image selected');
		return;
	}
	var file = fls[0];
	alert(file.type + "," + file.name);
	var formData = new FormData();
	formData.append(file.name, file);
	var ax = new XMLHttpRequest();
	ax.open('POST', 'UploadApp', true);
	ax.onreadystatechange = function() {
		if (ax.readyState === 4 && ax.status === 200) {
			img = true;
			alert("Image uploaded successfully");
		}
		if (ax.readyState === 4 && ax.status === 500) {
			alert("Unable to upload image");
		}
	};
	ax.send(formData);
}

</script>
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

</head>
<body>
<%

if(session.getAttribute("name")==null){
	response.sendRedirect("./index.jsp");
}
%>
<%
Map<String,String> categories=new HashMap<String,String>();
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
                    <li class="active">
                        <a href="admin_add_product.jsp"><i class="fa fa-fw fa-bar-chart-o"></i> Add Products</a>
                    </li>
                     <li>
                        <a href="admin_add_categories.jsp"><i class="fa fa-fw fa-table"></i> Add Cat/SubCat/Brands</a>
                    </li>
                    <!-- <li>
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
                <br><div align="center"><h3>Add Product</h3></div>
                <!-- Page Heading -->
                <div class="row">
	                <form class="form-horizontal" role="form" method="post" action="/MarketingPortal/admin_save_project.jsp" onsubmit="return checkAddProduct(this)">
						  <div class="form-group">
						    <label class="control-label col-sm-2" for="email">Product Name:</label>
						    <div class="col-sm-10">
						      <input type="text" class="form-control" name="pname" id="pname" placeholder="Enter product name">
						    </div>
						  </div>
						  <div class="form-group">
						    <label class="control-label col-sm-2" for="pwd">Product Description:</label>
						    <div class="col-sm-10"> 
						      <textarea class="form-control" rows="5" id="pdesc" name="pdesc" placeholder="Enter product description"></textarea>
						    </div>
						  </div>
  						  <div class="form-group">
						    <label class="control-label col-sm-2" for="email">Product Category:</label>
						    <div class="col-sm-10">
						      <select class="form-control" id="pcat" name="pcat">
						      <option value="">--Select--</option>
				  	<% 				  	
				  	Iterator it = categories.entrySet().iterator();
				    while (it.hasNext()) {
				        Map.Entry entry = (Map.Entry)it.next();
				  	    String key = entry.getKey().toString();
				  	    String value = entry.getValue().toString();
				  	    out.println("<option value='"+key+"'>"+value+"</option>");
				  	    it.remove();
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
						    <label class="control-label col-sm-2" for="email">Product Price:</label>
						    <div class="col-sm-10">
						      <input type="text" class="form-control" id="pprice" name="pprice" placeholder="Product price">
						    </div>
						  </div>
						  <div class="form-group">
						    <label class="control-label col-sm-2" for="email">Upload Image:</label>
						    <div class="col-sm-10">
						      <input type="file" class="form-control" id="pfile" name="pfile" placeholder="Product Image">
						      <button class="btn btn-default" type="button" value="Upload" onclick="uploadImage();">Upload</button>
						    </div>
						  </div>
						  <div class="form-group">
						  <label class="control-label col-sm-2" "></label>
						    <div class="col-sm-10">
						                 <label class="text-danger" id="productError"></label>
						    </div>
                            </div>
						  
						  <div class="form-group"> 
						    <div class="col-sm-offset-2 col-sm-10">
						      <button type="submit" class="btn btn-default">Submit</button>
						    </div>
						  </div>
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