<%@page import="javax.swing.text.html.Option"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*,java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%

if(session.getAttribute("user_id")==null){
	getServletContext().getRequestDispatcher("/index.jsp").include(request, response);
}
%>
<%
Map<String,String> categories=new HashMap<String,String>();
Map<String,String> subcategories=new HashMap<String,String>();
Map<String,String> brands=new HashMap<String,String>();
Map<String,String> sort=new HashMap<String,String>();
Connection con= null;
PreparedStatement ps = null;
ResultSet rs = null;

String driverName = "com.mysql.jdbc.Driver";
String url = "jdbc:mysql://localhost:3306/marketingportal";
String user = "root";
String dbpsw = "root";

String sql = "select * from categories order by name";



String categoryId=request.getParameter("category_id");
if(categoryId==null)categoryId="0";

String brandId=request.getParameter("brand_id");
if(brandId==null)brandId="0";


String sortId=request.getParameter("sort_id");
if(sortId==null)sortId="0";

String subcategoryId=request.getParameter("subcategory_id");

//String sql_sort="select * from products where category_id="+categoryId+" and website_id="+session.getAttribute("website_id").toString()+" and brand_id="+brandId+"order by price desc"  ;


//String sql_recent="SELECT DISTINCT name,id,image_path,price FROM products where website_id=1 ORDER BY name";
String sql_recent="SELECT * FROM (SELECT * FROM products ORDER BY id DESC LIMIT 8) sub ORDER BY id ASC"; 

//String sql_sort = "SELECT * FROM sort where brand_id=" + brandId + " order by name	";

String product_sql_sort1="select * from products where category_id="+categoryId+" and website_id="+session.getAttribute("website_id").toString()+" and brand_id="+brandId+" order by price asc";


String sql_Brand = "SELECT * FROM brands where subcategory_id=" + subcategoryId + " order by name";

String sql_subCat = "SELECT * FROM subcategories where category_id="+categoryId+" order by name";

String product_sql="select * from products where category_id="+categoryId+" and website_id="+session.getAttribute("website_id").toString()+" and brand_id="+brandId+" order by price desc";
String product_sql_sort2="select * from products where category_id="+categoryId+" and website_id="+session.getAttribute("website_id").toString()+" and brand_id="+brandId+" order by price desc";

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
		
		
		ps = con.prepareStatement(sql_subCat);
		rs = ps.executeQuery();
		while(rs.next())
		{			
			subcategories.put(rs.getString("id"),rs.getString("name"));
		}
		rs.close();
		ps.close();	

		ps = con.prepareStatement(sql_Brand);
		rs = ps.executeQuery();
		while(rs.next())
		{			
			brands.put(rs.getString("id"),rs.getString("name"));
		}
		rs.close();
		ps.close();	

		ps = con.prepareStatement(product_sql);
		rs = ps.executeQuery();
		while(rs.next())
		{			
			sort.put(rs.getString("id"),rs.getString("name"));
		}
		rs.close();
		ps.close();	
		
		ps = con.prepareStatement(product_sql_sort1);
		rs = ps.executeQuery();
		while(rs.next())
		{			
			sort.put(rs.getString("id"),rs.getString("name"));
		}
		rs.close();
		ps.close();	
		
		ps = con.prepareStatement(product_sql_sort2);
		rs = ps.executeQuery();
		while(rs.next())
		{			
			sort.put(rs.getString("id"),rs.getString("name"));
		}
		rs.close();
		ps.close();	
		
		}
	catch(SQLException sqe)
	{
		out.println(sqe);
	}

%>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Marketing Portal</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width;initial-scale=1;maximum-scale=1.0;user-scalable=0;">
<link rel="stylesheet" href="./css/bootstrap.min.css"/>
<link rel="stylesheet" href="./css/bootstrap-theme.min.css"/>
<link href="css/style.css" rel="stylesheet" type="text/css" media="all"/>
<link href="css/slider.css" rel="stylesheet" type="text/css" media="all"/>

<!-- <link href="./css/sb-admin.css" rel="stylesheet"> -->
<script src="./js/jquery.min.js"></script>
<script type="text/javascript" src="js/move-top.js"></script>
<script type="text/javascript" src="js/easing.js"></script>
<script type="text/javascript" src="js/startstop-slider.js"></script>
<script type="text/javascript" src=""></script>
<script src="./js/bootstrap.min.js"></script>
<link href="./images/favicon.ico" rel="icon" type="image/x-icon"/><!-- main window icon-->

<script type="text/javascript">
$(document).ready(function() {
$('#subcatories').change(function(event) {
    var sports = $("#subcatories").val();
    $.get('GetBrandsServlet', {
            subcategoryId : sports
    }, function(response) {

    var select = $('#brands');
    select.find('option').remove();
    select.append('<option value="">--Select--</option>');
      $.each(response, function(index, value) {
      $('<option>').val(value.id).text(value.name).appendTo(select);
  });
    });
    });
    
$('#brands').change(function(event) {
    var sports = $("#brands").val();    
});


});
</script>
</head>
<body>

  <div class="wrap">
	<div class="header">
		<div class="headertop_desc">
			<div class="call">
				 <!-- <p><span>Need help?</span> call us <span class="number">1-22-3456789</span></span></p> -->
			</div>
			<div class="account_desc">
				<ul>
					<li><a href="logout.jsp">Logout</a></li>
					<li><a href="#">My Account (<%=session.getAttribute("name")%>)</a></li>
				</ul>
			</div>
			<div class="clear"></div>
		</div>
		<div class="header_top">
			<div class="logo">
			<%
			String userType=session.getAttribute("usertype").toString();
			if(userType.equalsIgnoreCase("SNAPDEAL")){
				out.println("<a href='user_home.jsp'><img src='images/Snapdeal-logo-1.jpg' alt='' width='120px'/></a>");
			}
			if(userType.equalsIgnoreCase("AMAZON")){
				out.println("<a href='user_home.jsp'><img src='images/amazon_logo_500500._V323939215_.png' width='120px' alt=''/></a>");
			}
			if(userType.equalsIgnoreCase("FLIPKART")){
				out.println("<a href='user_home.jsp'><img src='images/flipkart_logo_detail.jpg' width='120px' alt=''/></a>");
			}
			%>
			</div>
			  <div class="cart">
			  	   <p>Welcome to our Online Store!</p>
			  </div>
			  <script type="text/javascript">
			function DropDown(el) {
				this.dd = el;
				this.initEvents();
			}
			DropDown.prototype = {
				initEvents : function() {
					var obj = this;

					obj.dd.on('click', function(event){
						$(this).toggleClass('active');
						event.stopPropagation();
					});	
				}
			}

			$(function() {

				var dd = new DropDown( $('#dd') );

				$(document).click(function() {
					// all dropdowns
					$('.wrapper-dropdown-2').removeClass('active');
				});

			});

		</script>
	 <div class="clear"></div>
  </div>
	<div class="header_bottom">
	     	<div class="menu">
	     		<ul>
			    	<li class="active"><a href="user_home.jsp">Home</a></li>
<!-- 			    	<li><a href="about.html">About</a></li>
			    	<li><a href="contact.html">Contact</a></li>
 -->			    	<div class="clear"></div>
     			</ul>
	     	</div>
 		<div class="clear"></div>
	     </div>	     

<!-- Categories -->

	<div class="header_slide">
			<div class="header_bottom_left">				
				<div class="categories">
				  <ul>
				  	<h3>Categories</h3>
				  	<% 				  	
				  	String tempVal=categories.get(categoryId);
				  	
				  	Iterator it = categories.entrySet().iterator();
				    while (it.hasNext()) {
				        Map.Entry entry = (Map.Entry)it.next();
				  	    String key = entry.getKey().toString();
				  	    String value = entry.getValue().toString();
				  	    if(categoryId.equals(key))out.println("<li><a href='user_home.jsp?category_id="+key+"' style='color:#B81D22'>"+value+"</a></li>");
				  	    else out.println("<li><a href='user_home.jsp?category_id="+key+"'>"+value+"</a></li>");
				  	    it.remove();
				  	}
 				  	%>
 				  </ul>
				</div>					
	  	     </div>
					 <div class="header_bottom_right">					 
					 	 <div class="slider">					     
							 <div id="slider">

		
<%
 
/* Subcategories  */

 if(tempVal!=null){
 out.println("<div class='content'>");
 out.println("<div style='margin-left:10px'>");
 out.println("<form class='form-inline'>");
 out.println("<div class='form-group'>");
 out.println("<label>Subcategories :</label>");
 out.println("<select class='form-control' id='subcatories'>");
 out.println("<option value=''>--Select--</option>");
	it = subcategories.entrySet().iterator();
    while (it.hasNext()) {
        Map.Entry entry = (Map.Entry)it.next();
  	    String key = entry.getKey().toString();
  	    String value = entry.getValue().toString();
  	    if(subcategoryId!=null){
  	    	if(subcategoryId.equalsIgnoreCase(key))out.println("<option value='"+key+"' selected>"+value+"</option>");
  	  	    else out.println("<option value='"+key+"'>"+value+"</option>");
  	    }else out.println("<option value='"+key+"'>"+value+"</option>");
  	    it.remove();
  	}
 out.println("</select>");
 out.println("</div>");
 
 /* Brands   */
 
 out.println("<div class='form-group'>"); 
 out.println("<strong>Brand :</strong>");
 out.println("<select id='brands' class='form-control' onchange='window.location.href = \"./user_home.jsp?category_id="+categoryId+"&subcategory_id=3&brand_id=\"+this.options[this.selectedIndex].value'>");
 out.println("<option>--Select--</option>");
	it = brands.entrySet().iterator();
    while (it.hasNext()) {
        Map.Entry entry = (Map.Entry)it.next();
  	    String key = entry.getKey().toString();
  	    String value = entry.getValue().toString();
  	    if(brandId!=null){
  	    	if(brandId.equalsIgnoreCase(key))out.println("<option value='"+key+"' selected>"+value+"</option>");
  	    	else out.println("<option value='"+key+"'>"+value+"</option>");
  	    }
  	    
  	    it.remove();
  	}

 out.println("</select>");
 out.println("</div>");
 
/* For sorting the price  */ 

//out.println("<div class='form-group'>"); 
//out.println("<select id='sort' class='form-control' onchange='window.location.href = \"./user_home.jsp?category_id="+categoryId+"&subcategory_id=3&brand_id=\"+this.options[this.selectedIndex].value'>");
%>


 <%
 out.println("<div class='form-group'>"); 
 out.println("<strong>Sort By :</strong>");
 //out.println("<select id='brands' name='selection'>");
 %>
<form action="post">

<select id="brands" class="form-control" name="choose" >
	<option>---Select----</option>
	<option value="price"> Price High To Low</option>
	<option value="price1">Price Low To high</option>
</select>
<input type="submit" value="Submit" onclick="document.getElementById('brands')">
</form>

<%
String x= request.getParameter("choose");
//String x="price";
//= request.getParameter("choose");
 out.println(x);
 out.println("</div>");
 %>
 
 <% if(x=="price"){ 
 	
 	%>
 <!-- ---------------------Price High To Low -------------------------------- -->
 <%
 out.println("<div class='content_bottom'>");
 out.println("<div class='heading'>");
 out.println("<h3>Products - By Price High To Low</h3>");
 out.println("</div>");
 out.println("<div class='see'>");
 out.println("</div>");
 out.println("<div class='clear'></div>");
 out.println("</div>");
 try{
		ps = con.prepareStatement(product_sql_sort1);
		rs = ps.executeQuery();
		int i=1;
		int chk=0;
		boolean isPresent=false;
		while(rs.next())
		{	
			isPresent=true;
			if(i==1)out.println("<div class='section group'>");

			out.println("<div style='z-index:999999' class='grid_1_of_4 images_1_of_4'>");
			 out.println("<a href='buy_products.jsp?product_id="+rs.getString("id")+"'><img src='.\\"+rs.getString("image_path")+"' alt='' /></a>");
			 out.println("<h2>"+rs.getString("name")+"</h2>");
			out.println("<div class='price-details'>");
		       out.println("<div class='price-number'>");
					out.println("<p><span class='rupees'>"+rs.getString("price")+"</span></p>");
			    out.println("</div>");
			       		out.println("<div class='add-cart'>");
							out.println("<h4><a href='buy_products.jsp?product_id="+rs.getString("id")+"'>Add to Cart</a></h4>");
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
		if(!isPresent){
			out.println("<h2></h2>");
		}
		rs.close();
		ps.close();	
		//con.close();
		}
	catch(SQLException sqe)
	{
		out.println(sqe);
	}
 } else if(x=="price1"){ %>
 <!-- ------------------------------Low To High ------------------------------- -->
 <% 
 out.println("<div class='content_bottom'>");
 out.println("<div class='heading'>");
 out.println("<h3>Products - By Price Low To High</h3>");
 out.println("</div>");
 out.println("<div class='see'>");
 out.println("</div>");
 out.println("<div class='clear'></div>");
 out.println("</div>");
 try{
		ps = con.prepareStatement(product_sql_sort2);
		rs = ps.executeQuery();
		int i=1;
		int chk=0;
		boolean isPresent=false;
		while(rs.next())
		{	
			isPresent=true;
			if(i==1)out.println("<div class='section group'>");

			out.println("<div style='z-index:999999' class='grid_1_of_4 images_1_of_4'>");
			 out.println("<a href='buy_products.jsp?product_id="+rs.getString("id")+"'><img src='.\\"+rs.getString("image_path")+"' alt='' /></a>");
			 out.println("<h2>"+rs.getString("name")+"</h2>");
			out.println("<div class='price-details'>");
		       out.println("<div class='price-number'>");
					out.println("<p><span class='rupees'>"+rs.getString("price")+"</span></p>");
			    out.println("</div>");
			       		out.println("<div class='add-cart'>");
							out.println("<h4><a href='buy_products.jsp?product_id="+rs.getString("id")+"'>Add to Cart</a></h4>");
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
		if(!isPresent){
			out.println("<h2></h2>");
		}
		rs.close();
		ps.close();	
		//con.close();
		}
	catch(SQLException sqe)
	{
		out.println(sqe);
	}

 } %>
 
<% 

		// -------------------Products----------------------------
		
		
 out.println("<div class='content_bottom'>");
 out.println("<div class='heading'>");
 out.println("<h3>Products</h3>");
 out.println("</div>");
 out.println("<div class='see'>");
 out.println("</div>");
 out.println("<div class='clear'></div>");
 out.println("</div>");
 }else{
	 
 }
    	
	try{
		ps = con.prepareStatement(product_sql);
		rs = ps.executeQuery();
		int i=1;
		int chk=0;
		boolean isPresent=false;
		while(rs.next())
		{	
			isPresent=true;
			if(i==1)out.println("<div class='section group'>");

			out.println("<div style='z-index:999999' class='grid_1_of_4 images_1_of_4'>");
			 out.println("<a href='buy_products.jsp?product_id="+rs.getString("id")+"'><img src='.\\"+rs.getString("image_path")+"' alt='' /></a>");
			 out.println("<h2>"+rs.getString("name")+"</h2>");
			out.println("<div class='price-details'>");
		       out.println("<div class='price-number'>");
					out.println("<p><span class='rupees'>"+rs.getString("price")+"</span></p>");
			    out.println("</div>");
			       		out.println("<div class='add-cart'>");
							out.println("<h4><a href='buy_products.jsp?product_id="+rs.getString("id")+"'>Add to Cart</a></h4>");
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
		if(!isPresent){
			out.println("<h2>Available Products: </h2>");
		}
		rs.close();
		ps.close();	
		//con.close();
		}
	catch(SQLException sqe)
	{
		out.println(sqe);
	}

%>
	
	<%-- 
	<!-- Recently Added Products -->		  
	  <div class="content">
			<div style="margin-left: 10%;">
				<form class="form-inline">
					<div class="form-group">
						<label> Recently Added Products: </label>
		<%
		try{
							ps = con.prepareStatement(sql_recent);
							rs = ps.executeQuery();
							int i=1;
							int chk=0;
							boolean isPresent=false;
							while(rs.next())
							{	
								isPresent=true;
								if(i==1)out.println("<div class='section group'>");

								out.println("<div style='z-index:999999' class='grid_1_of_4 images_1_of_4'>");
								 out.println("<a href='buy_products.jsp?product_id="+rs.getString("id")+"'><img src='.\\"+rs.getString("image_path")+"' alt='' /></a>");
								 out.println("<h2>"+rs.getString("name")+"</h2>");
								out.println("<div class='price-details'>");
							       out.println("<div class='price-number'>");
										out.println("<p><span class='rupees'>"+rs.getString("price")+"</span></p>");
								    out.println("</div>");
								       		out.println("<div class='add-cart'>");
												out.println("<h4><a href='buy_products.jsp?product_id="+rs.getString("id")+"'>Add to Cart</a></h4>");
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
							if(!isPresent){
								out.println("<h2> No Product Available</h2>");
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
					</div>
				</form>
			</div>
		</div>               	 --%>
		                	</div>
						 <div class="clear"></div>					       
		         		</div>
		      		</div>
		   <div class="clear"></div>
		</div>
   </div>
 <div class="main">
 <div style="height:50px"></div>
    </div>
 </div>
</div>

</body>
</html>