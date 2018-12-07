<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*,java.util.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%
	if (session.getAttribute("user_id") == null) {
		getServletContext().getRequestDispatcher("/index.jsp").include(request, response);
	}
%>
<%
	Map<String, String> categories = new HashMap<String, String>();
	Map<String, String> subcategories = new HashMap<String, String>();
	Map<String, String> brands = new HashMap<String, String>();
	Map<String, String> sort = new HashMap<String, String>();
	Connection con = null;
	PreparedStatement ps = null;
	ResultSet rs = null;

	String driverName = "com.mysql.jdbc.Driver";
	String url = "jdbc:mysql://localhost:3306/marketingportal";
	String user = "root";
	String dbpsw = "root";

	String sql = "select * from categories order by name";

	String categoryId = request.getParameter("category_id");
	if (categoryId == null)
		categoryId = "0";

	String brandId = request.getParameter("brand_id");
	if (brandId == null)
		brandId = "0";

	String sortId = request.getParameter("sort_id");
	if (sortId == null)
		sortId = "0";

	String subcategoryId = request.getParameter("subcategory_id");

	String str = request.getParameter("name");
	String website_id = session.getAttribute("website_id").toString();

	//String sql_sort="select * from products where category_id="+categoryId+" and website_id="+session.getAttribute("website_id").toString()+" and brand_id="+brandId+"order by price desc"  ;

	//String sql_recent="SELECT DISTINCT name,id,image_path,price FROM products where website_id=1 ORDER BY name";
	String sql_recent = "SELECT * FROM (SELECT * FROM products ORDER BY id DESC LIMIT 8) sub ORDER BY id ASC";
	String product_sql_search = "SELECT * FROM products  WHERE name LIKE '%" + str + "%' and website_id=" + website_id + " LIMIT 10";

	//String sql_sort = "SELECT * FROM sort where brand_id=" + brandId + " order by name	";

	String product_sql_sort1 = "select * from products where category_id=" + categoryId + " and website_id="
			+ session.getAttribute("website_id").toString() + " and brand_id=" + brandId
			+ " order by price asc";

	String sql_Brand = "SELECT * FROM brands where subcategory_id=" + subcategoryId + " order by name";

	String sql_subCat = "SELECT * FROM subcategories where category_id=" + categoryId + " order by name";

	String product_sql = "select * from products where category_id=" + categoryId + " and website_id="
			+ session.getAttribute("website_id").toString() + " and brand_id=" + brandId + " order by id";


	String product_sql_sort2 = "select * from products where category_id=" + categoryId + " and website_id="
			+ session.getAttribute("website_id").toString() + " and brand_id=" + brandId
			+ " order by price desc";

	try {
		Class.forName(driverName);
		con = DriverManager.getConnection(url, user, dbpsw);
		ps = con.prepareStatement(sql);
		rs = ps.executeQuery();
		while (rs.next()) {
			categories.put(rs.getString("id"), rs.getString("name"));
		}
		rs.close();
		ps.close();

		ps = con.prepareStatement(sql_subCat);
		rs = ps.executeQuery();
		while (rs.next()) {
			subcategories.put(rs.getString("id"), rs.getString("name"));
		}
		rs.close();
		ps.close();

		ps = con.prepareStatement(sql_Brand);
		rs = ps.executeQuery();
		while (rs.next()) {
			brands.put(rs.getString("id"), rs.getString("name"));
		}
		rs.close();
		ps.close();

		ps = con.prepareStatement(product_sql);
		rs = ps.executeQuery();
		while (rs.next()) {
			sort.put(rs.getString("id"), rs.getString("name"));
		}
		rs.close();
		ps.close();

		ps = con.prepareStatement(product_sql_sort1);
		rs = ps.executeQuery();
		while (rs.next()) {
			sort.put(rs.getString("id"), rs.getString("name"));
		}
		rs.close();
		ps.close();

		ps = con.prepareStatement(product_sql_sort2);
		rs = ps.executeQuery();
		while (rs.next()) {
			sort.put(rs.getString("id"), rs.getString("name"));
		}
		rs.close();
		ps.close();

	} catch (SQLException sqe) {
		out.println(sqe);
	}
%>

<head>

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Marketing Portal</title>
<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width;initial-scale=1;maximum-scale=1.0;user-scalable=0;">
<link rel="stylesheet" href="./css/bootstrap.min.css" />
<link rel="stylesheet" href="./css/bootstrap-theme.min.css" />
<link href="css/style.css" rel="stylesheet" type="text/css" media="all" />
<link href="css/slider.css" rel="stylesheet" type="text/css" media="all" />

<!-- <link href="./css/sb-admin.css" rel="stylesheet"> -->
<script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="js/autocomplete-0.3.0.js"></script>
<script src="./js/jquery.min.js"></script>
<script type="text/javascript" src="js/move-top.js"></script>
<script type="text/javascript" src="js/easing.js"></script>
<script type="text/javascript" src="js/startstop-slider.js"></script>
<script type="text/javascript" src=""></script>
<script src="./js/bootstrap.min.js"></script>
<link href="./images/favicon.ico" rel="icon" type="image/x-icon" />
<!-- main window icon-->

<script type="text/javascript"
	src="http://code.jquery.com/jquery-latest.js"></script>
<script type="text/javascript"
	src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.9/jquery-ui.js"></script>

<script>
    $(document).ready(function() {
        function disableBack() { window.history.forward() }

        window.onload = disableBack();
        window.onpageshow = function(evt) { if (evt.persisted) disableBack() }
    });
</script>
<script type="text/javascript">
	$(document)
			.ready(
					function() {
						$('#subcatories')
								.change(
										function(event) {
											var sports = $("#subcatories")
													.val();
											$
													.get(
															'GetBrandsServlet',
															{
																subcategoryId : sports
															},
															function(response) {

																var select = $('#brands');
																select
																		.find(
																				'option')
																		.remove();
																select
																		.append('<option value="">--Select--</option>');
																$
																		.each(
																				response,
																				function(
																						index,
																						value) {
																					$(
																							'<option>')
																							.val(
																									value.id)
																							.text(
																									value.name)
																							.appendTo(
																									select);
																				});
															});
										});

						$('#brands').change(function(event) {
							var sports = $("#brands").val();
						});

					});
</script>
<style>
.your-review input[type="submit"] {
	padding: 9px 15px;
	margin-top: 0px;
	width: 100%;
}

.your-review input[type="text"], .your-review textarea {
	padding: 8px;
	display: block;
	width: 100%;
	border: 1px solid #E0E0E0;
	background: none;
	outline: none;
	color: #222;
	font-size: 1em;
	font-family: Arial, Helvetica, sans-serif;
	-webkit-appearance: none;
	float: left;
}

.col-md-9 {
	width: 37%;
}

.col-md-3 {
	width: 8%;
}
</style>
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
						<li><a href="#">My Account (<%=session.getAttribute("name")%>)
						</a></li>
					</ul>
				</div>
				<div class="clear"></div>
			</div>
			<div class="header_top">
				<div class="logo">
					<%
						String userType = session.getAttribute("usertype").toString();
						if (userType.equalsIgnoreCase("SNAPDEAL")) {
							out.println("<a href='user_home.jsp'><img src='images/Snapdeal-logo-1.jpg' alt='' width='120px'/></a>");
						}
						if (userType.equalsIgnoreCase("AMAZON")) {
							out.println(
									"<a href='user_home.jsp'><img src='images/amazon_logo_500500._V323939215_.png' width='120px' alt=''/></a>");
						}
						if (userType.equalsIgnoreCase("FLIPKART")) {
							out.println(
									"<a href='user_home.jsp'><img src='images/flipkart_logo_detail.jpg' width='120px' alt=''/></a>");
						}
					%>
				</div>


				<!-- <script type="text/javascript">
				 $(document).ready(function(){
					$(function(){
						
						$("#inputString").autocomplete({
						
							source: function(request,response){
							alert("hii");
								$.ajax({
								   url : "search",
								   type: "GET",
								   data:{
									   term : request.term
								   },
								   datatype : "json",
								   success : function(data){
									   response(data);
									   
								   }
								});
								},
							select: function(event,ui){
								alert(ui.item.value);
							}
							
						});			
					});
				}); 
				/*  
				 function lookup(inputString) {
						if (inputString.length == 0) {
							$('#suggestions').hide();
						} else {
							$.post("autoproducts.jsp", {
								queryString : "" + inputString + ""
							}, function(data) {
								if (data.length > 0) {
									$('#suggestions').show();
									$('#autoSuggestionsList').html(data);
																			}
								
							});
							
							
						}
						
						
					} 
				 */	
				/* 	 function fill(thisValue) {		
						
						$('#inputString').val(thisValue);
						
						setTimeout("$('#suggestions').hide();", 200);
						// alert(document.getElementById("autoSuggestionsList").getAttribute(value));
						//alert(thisValue);
						//alert(ui.item.data);
					}  
					
 */
								
				</script>
			 -->

<style>
* {box-sizing:border-box}
body {font-family: Verdana,sans-serif;}
.mySlides {display:none}

/* Slideshow container */
.slideshow-container {
  max-width: 1000px;
  position: relative;
  margin: auto;
}

/* Caption text */
.text {
  color: #f2f2f2;
  font-size: 15px;
  padding: 8px 12px;
  position: absolute;
  bottom: 8px;
  width: 100%;
  text-align: center;
}

/* Number text (1/3 etc) */
.numbertext {
  color: #f2f2f2;
  font-size: 12px;
  padding: 8px 12px;
  position: absolute;
  top: 0;
}

/* The dots/bullets/indicators */
.dot {
  height: 13px;
  width: 13px;
  margin: 0 2px;
  background-color: #bbb;
  border-radius: 50%;
  display: inline-block;
  transition: background-color 0.6s ease;
}

.active {
  background-color: #717171;
}

/* Fading animation */
.fade {
  -webkit-animation-name: fade;
  -webkit-animation-duration: 1.5s;
  animation-name: fade;
  animation-duration: 1.5s;
}

@-webkit-keyframes fade {
  from {opacity: .4} 
  to {opacity: 1}
}

@keyframes fade {
  from {opacity: .4} 
  to {opacity: 1}
}

/* On smaller screens, decrease text size */
@media only screen and (max-width: 300px) {
  .text {font-size: 11px}
}
</style>


				<style type="text/css">
body {
	font-family: Helvetica;
	font-size: 13px;
	color: #000;
}

h3 {
	margin: 0px;
	padding: 0px;
}

.suggestionsBox {
	position: relative;
	left: 260px;
	margin: 0px 0px 0px 0px;
	width: 200px;
	background-color: #7845DD;
	-moz-border-radius: 7px;
	-webkit-border-radius: 7px;
	border: 2px solid #000;
	color: #fff;
}

.suggestionList {
	margin: 0px;
	padding: 0px;
}

.suggestionList li {
	margin: 0px 0px 3px 0px;
	padding: 3px;
	cursor: pointer;
}

.suggestionList li:hover {
	background-color: #DD45CD;
}
</style>


<script type="text/javascript">
$(document).ready(function() {
    $(function() {
    	
    	//alert(document.getElementById("search").value)
            $("#inputString").autocomplete({ 
            	
            source : function(request, response) {            	
            $.ajax({
                    url : "search",
                    type : "GET",
                    data : {                    
                            term : request.term
                    },
                    dataType : "json",
                    success : function(data) {
                    	//alert("inside json function");
                            response(data);
                    }                    
                 });
              },
              
              
              select:function(event,ui){
            	/*  alert(ui.item.value);
            	 alert("hiii");
            	 document.getElementById("name").innerHTML=ui.item.value;
            	 var x=document.URL;
            	 var url=window.location.toString();
            	 $.ajax({
            		 
            		 url:window.location=url.replace(x,"http://localhost:8081/MarketingPortal/search"),
            		type:"GET",
            		data:{
            			result:ui.item.value
            		},
            		dataType:"json" 
            	 })            	             	             	 
            	 return false;
            	 */
              } 
             
				
         });
     });
    
});
</script>



				<form action="#" name="search">			
				<div class="your-review">


					<div class="col-md-9">
						<span><input name="name" class="form-control" type="text"
							size="30" id="inputString" placeholder="Search Product"
							value="${param.name}" /></span> 
							<input type="hidden" name="website_id"
							value="<%=session.getAttribute("website_id")%>" id="website_id">
					</div>
					<!-- div class="suggestionsBox" id="suggestions"
							style="display: none;">
							<div class="suggestionList" id="autoSuggestionsList" >
								
							</div>
						</div>  -->
					<div class="col-md-3" >
						  <span><input type="submit" value="SEARCH"></span>
						   		</div>


				</div>
				</form>
				<div class="cart">
					<p>Welcome</p>
				</div>

				<script type="text/javascript">
					function DropDown(el) {
						this.dd = el;
						this.initEvents();
					}
					DropDown.prototype = {
						initEvents : function() {
							var obj = this;

							obj.dd.on('click', function(event) {
								$(this).toggleClass('active');
								event.stopPropagation();
							});
						}
					}

					$(function() {

						var dd = new DropDown($('#dd'));

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
 -->
						<div class="clear"></div>
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
								String tempVal = categories.get(categoryId);

								Iterator it = categories.entrySet().iterator();
								while (it.hasNext()) {
									Map.Entry entry = (Map.Entry) it.next();
									String key = entry.getKey().toString();
									String value = entry.getValue().toString();
									if (categoryId.equals(key))
										out.println("<li><a href='user_home.jsp?category_id=" + key + "' style='color:#B81D22'>" + value
												+ "</a></li>");
									else
										out.println("<li><a href='user_home.jsp?category_id=" + key + "'>" + value + "</a></li>");
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

								if (tempVal != null) {
									out.println("<div class='content'>");
									out.println("<div style='margin-left:10px'>");
									out.println("<form class='form-inline'>");
									out.println("<div class='form-group'>");
									out.println("<label>Subcategories :</label>");
									out.println("<select class='form-control' id='subcatories'>");
									out.println("<option value=''>--Select--</option>");
									it = subcategories.entrySet().iterator();
									while (it.hasNext()) {
										Map.Entry entry = (Map.Entry) it.next();
										String key = entry.getKey().toString();
										String value = entry.getValue().toString();
										if (subcategoryId != null) {
											if (subcategoryId.equalsIgnoreCase(key))
												out.println("<option value='" + key + "' selected>" + value + "</option>");
											else
												out.println("<option value='" + key + "'>" + value + "</option>");
										} else
											out.println("<option value='" + key + "'>" + value + "</option>");
										it.remove();
									}
									out.println("</select>");
									out.println("</div>");

									/* Brands   */

									out.println("<div class='form-group'>");
									out.println("<strong>Brand :</strong>");
									out.println(
											"<select id='brands' class='form-control' onchange='window.location.href = \"./user_home.jsp?category_id="
													+ categoryId
													+ "&subcategory_id=3&brand_id=\"+this.options[this.selectedIndex].value'>");
									out.println("<option>--Select--</option>");
									it = brands.entrySet().iterator();
									while (it.hasNext()) {
										Map.Entry entry = (Map.Entry) it.next();
										String key = entry.getKey().toString();
										String value = entry.getValue().toString();
										if (brandId != null) {
											if (brandId.equalsIgnoreCase(key))
												out.println("<option value='" + key + "' selected>" + value + "</option>");
											else
												out.println("<option value='" + key + "'>" + value + "</option>");
										}

										it.remove();
									}

									out.println("</select>");
									out.println("</div>");

									/* For sorting the price  */

									//out.println("<div class='form-group'>"); 
									//out.println("<select id='sort' class='form-control' onchange='window.location.href = \"./user_home.jsp?category_id="+categoryId+"&subcategory_id=3&brand_id=\"+this.options[this.selectedIndex].value'>");
							%>
							<div class="form-group">
								<form action="#" method="post" class="form_sort">
									<strong>Sort by:</strong> <select
										class="select_styled white_select" name="sort_list"
										id="sort_list">
										<option value="1" selected="selected" data-sort="ladd">Latest
											Added</option>
										<option value="2" data-sort="price">Price High - Low</option>
										<option value="3" data-sort="price">Price Low - high</option>
										<!-- <option value="3" data-sort="loc" disabled>Location</option> -->
										<!-- <option value="4">Names A-Z</option>
                    <option value="5">Names Z-A</option> -->
									</select>
								</form>
							</div>
						</div>
						<!--/ sorting, pages -->
						<!-- offers list -->

					</div>

					<script type="text/javascript">
						$(document)
								.ready(
										function() {
											$(
													'select.select_styled.white_select[name="sort_list"]')
													.change(
															function() {
																var arr = [];
																var by = this.selectedIndex; // sort by
																var items = $(".images_1_of_4");
																var val, temp;
																items
																		.each(function() {
																			if (by === 0) {
																				temp = $(
																						this)
																						.find(
																								'.offer_regist')
																						.text()
																						.split(
																								'/');
																				val = (temp[1] + temp[0]) | 0;
																			} else if (by == 1) {
																				val = $(
																						this)
																						.find(
																								'.price-number')
																						.text();
																				val = val
																						.replace(
																								'$',
																								'')
																						.replace(
																								'.',
																								'') | 0;
																			} else if (by == 2) {
																				val = $(
																						this)
																						.find(
																								'.price-number')
																						.text();
																				val = val
																						.replace(
																								'$',
																								'')
																						.replace(
																								'.',
																								'') | 0;
																			}
																			arr
																					.push({
																						v : val,
																						t : this
																					});
																		});
																//console.log(arr);
																arr
																		.sort(function(
																				a,
																				b) {
																			// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/sort
																			if (by === 0
																					|| by == 1) { //sort numbers - newest date and highest price
																				return (a.v < b.v) ? +1
																						: ((a.v > b.v) ? -1
																								: 0);
																			} else if (by === 0
																					|| by == 2) {
																				return (a.v > b.v) ? +1
																						: ((a.v < b.v) ? -1
																								: 0);
																			}
																		});
																//console.log(arr);
																$(arr)
																		.each(
																				function() {
																					$(
																							'.section')
																							.append(
																									this.t);
																				});
															})
													.trigger('change');
										});
					</script>


					<%
						// -------------------Products Main----------------------------
							
							
							out.println("<div class='content_bottom'>");
							out.println("<div class='heading'>");
							out.println("<h3>Products</h3>");
							out.println("</div>");
							out.println("<div class='see'>");
							out.println("</div>");
							out.println("<div class='clear'></div>");
							out.println("</div>");
						} else {

						}

						try {
							ps = con.prepareStatement(product_sql);
							rs = ps.executeQuery();
							int i = 1;
							int chk = 0;
							boolean isPresent = false;
							while (rs.next()) {
								isPresent = true;
								if (i == 1)
								out.println("<div class='section group'>");

								out.println("<div style='z-index:999999' class='grid_1_of_4 images_1_of_4'>");
								out.println("<a href='buy_products.jsp?product_id=" + rs.getString("id") + "'><img src='.\\"
										+ rs.getString("image_path") + "' alt='' /></a>");
								out.println("<h2>" + rs.getString("name") + "</h2>");
								out.println("<div class='price-details'>");
								out.println("<div class='price-number'>");
								out.println("<p><span class='rupees'>" + rs.getString("price") + "</span></p>");
								out.println("</div>");
								out.println("<div class='add-cart'>");
								out.println("<h4><a href='buy_products.jsp?product_id=" + rs.getString("id")
										+ "'>View</a></h4>");
								out.println("</div>");
								out.println("<div class='clear'></div>");
								out.println("</div>");
								out.println("</div>");

								if (i == 4) {
									out.println("</div>");
									chk = 1;
									i = 1;
								} else {
									chk = 0;
									i++;
								}

							}
							if (chk == 0)
								out.println("</div>");
							if (!isPresent) {
								out.println("<h2>Available Products: </h2>");
							}
							rs.close();
							ps.close();
							//con.close();
						} catch (SQLException sqe) {
							out.println(sqe);
						}
					%>


				</div>
				<div class="clear"></div>
			</div>
		</div>
		
		

		
		<%
						// -------------------Products Search----------------------------

							
						
						try {
							
							out.println("<div class='content_bottom'>");
							out.println("<div class='heading'>");
							
							out.println("</div>");
							out.println("<div class='see'>");
							out.println("</div>");
							out.println("<div class='clear'></div>");
							out.println("</div>");
							ps = con.prepareStatement(product_sql_search);
							rs = ps.executeQuery();
							int i = 1;
							int chk = 0;
							boolean isPresent = false;
							while (rs.next()) {
								isPresent = true;
								if (i == 1)
									out.println("<div class='section group'>");

								out.println("<div style='z-index:999999' class='grid_1_of_4 images_1_of_4'>");
								out.println("<a href='buy_products.jsp?product_id=" + rs.getString("id") + "'><img src='.\\"
										+ rs.getString("image_path") + "' alt='' /></a>");
								out.println("<h2>" + rs.getString("name") + "</h2>");
								out.println("<div class='price-details'>");
								out.println("<div class='price-number'>");
								out.println("<p><span class='rupees'>" + rs.getString("price") + "</span></p>");
								out.println("</div>");
								out.println("<div class='add-cart'>");
								out.println("<h4><a href='buy_products.jsp?product_id=" + rs.getString("id")
										+ "'>View</a></h4>");
								out.println("</div>");
								out.println("<div class='clear'></div>");
								out.println("</div>");
								out.println("</div>");

								if (i == 4) {
									out.println("</div>");
									chk = 1;
									i = 1;
								} else {
									chk = 0;
									i++;
								}

							}
							if (chk == 0)
								out.println("</div>");
							if (!isPresent) {
						//out.println("<h2>Available Products: </h2>");
							}
							rs.close();
							ps.close();
							//con.close();
						} catch (SQLException sqe) {
							out.println(sqe);
						}
					%>
		
<div class="container">
 
  <div id="myCarousel" class="carousel slide" data-ride="carousel" style="width: 90% ;height: auto;">
    <!-- Indicators -->
    <ol class="carousel-indicators">
      <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
      <li data-target="#myCarousel" data-slide-to="1"></li>
      <li data-target="#myCarousel" data-slide-to="2"></li>
    </ol>

    <!-- Wrapper for slides -->
    <div class="carousel-inner">
      <div class="item active">
        <img src="mobile offer.png" alt="Mobile" style="width:100%; height: 100%;">
      </div>

      <div class="item">
        <img src="shoes offer.jpg" alt="Shoes" style="width:100%; height: 100%;">
      </div>
    
      <div class="item">
        <img src="tv offer.jpg" alt="TV" style="width:100%; height: 100%;">
      </div>
    </div>

    <!-- Left and right controls -->
    <a class="left carousel-control" href="#myCarousel" data-slide="prev">
      <span class="glyphicon glyphicon-chevron-left"></span>
      <span class="sr-only">Previous</span>
    </a>
    <a class="right carousel-control" href="#myCarousel" data-slide="next">
      <span class="glyphicon glyphicon-chevron-right"></span>
      <span class="sr-only">Next</span>
    </a>
  </div>
</div>

		
		<div class="clear"></div>
	</div>
	</div>
	<div class="main">
		<div style="height: 50px"></div>
	</div>
	</div>
	</div>

</body>
</html>