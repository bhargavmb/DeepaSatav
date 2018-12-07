<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*,java.util.*" %>

<!DOCTYPE HTML>
<head>
<title>Marketing Portal</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<link href="css/style.css" rel="stylesheet" type="text/css" media="all"/>
<script type="text/javascript" src="js/jquery-1.7.2.min.js"></script> 
<script type="text/javascript" src="js/move-top.js"></script>
<script type="text/javascript" src="js/easing.js"></script>
<script src="js/easyResponsiveTabs.js" type="text/javascript"></script>
<link href="css/easy-responsive-tabs.css" rel="stylesheet" type="text/css" media="all"/>
<link rel="stylesheet" href="css/global.css">
<script src="js/slides.min.jquery.js"></script>
<script>
		$(function(){
			$('#products').slides({
				preload: true,
				preloadImage: 'img/loading.gif',
				effect: 'slide, fade',
				crossfade: true,
				slideSpeed: 350,
				fadeSpeed: 500,
				generateNextPrev: true,
				generatePagination: false
			});
		});
	</script>
</head>
<body>
<%
class calculatePercent{
	public int getPercent(int good,int total){
		return (good*100)/total;
	}
}
class Review{
	public String review_id="";
	public String review="";
	public String reviewer_nm="";	
};
class OTDetail{
	public String ot_id="";
	public String ot_name="";
	public String ot_percent="";
	public String toString(){
		return ot_id+ot_name+ot_percent;
	}
};
class ProductIdAndWebsiteName{
	public String product_id="";
	public String website_name="";
};

ArrayList<Review> reviews=new ArrayList<Review>();
ArrayList<OTDetail> otsForAmazon=new ArrayList<OTDetail>();
ArrayList<OTDetail> otsForFlipkart=new ArrayList<OTDetail>();
ArrayList<OTDetail> otsForSnapdeal=new ArrayList<OTDetail>();

ArrayList<ProductIdAndWebsiteName> productIdAndWebsiteNameList=new ArrayList<ProductIdAndWebsiteName>();

Map<String,String> categories=new HashMap<String,String>();
Connection con= null;
PreparedStatement ps = null;
ResultSet rs = null;

String driverName = "com.mysql.jdbc.Driver";
String url = "jdbc:mysql://localhost:3306/marketingportal";
String user = "root";
String dbpsw = "root";

String sql = "select * from categories order by id asc	";

String product_id=request.getParameter("product_id");

String sql2 = "SELECT products.id,products.name,products.description,products.price,products.category_id,categories.name as catname,products.image_path FROM products,categories where products.id="+product_id+" && categories.id=products.category_id && products.website_id="+session.getAttribute("website_id").toString();

String sql3 = "select * from reviews where product_id="+product_id+" && website_id="+session.getAttribute("website_id").toString();

String ssql="SELECT products.id as pid,website.name as wnm FROM products,website where products.name=? and products.website_id=website.id";

String sql4 = "select * from product_ot where product_id=?";

String sql5="select *,count(*) as ct from ot_status where product_ot_id in (SELECT id FROM product_ot where product_id=?) and product_ot_id=? group by product_ot_id,ow_main";

ArrayList<String> allwebsiteProductIds=new ArrayList<String>();

String id="";
String name="";
String description="";
String price="";
String category_id="";
String catname="";
String image_path="";

String review_id="";
String review="";
String reviewer_nm="";

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
		
		///////////
		
		ps = con.prepareStatement(sql2);
		rs = ps.executeQuery();
		while(rs.next())
		{			
			 id=rs.getString("id");
			 name=rs.getString("name");
			 description=rs.getString("description");
			 price=rs.getString("price");
			 category_id=rs.getString("category_id");
			 catname=rs.getString("catname");
			 image_path=rs.getString("image_path");
		}
		rs.close();		
		ps.close();	

		/////////
		
		ps = con.prepareStatement(sql3);
		rs = ps.executeQuery();
		
		while(rs.next())
		{	
			Review rr=new Review();
			 rr.review_id=rs.getString("id");
			 rr.review=rs.getString("review");
			 rr.reviewer_nm=rs.getString("reviewer_name");
			 reviews.add(rr);
		}
		rs.close();		
		ps.close();
		
		/////////////

		ps = con.prepareStatement(ssql);
		ps.setString(1,name);
		rs = ps.executeQuery();
		
		while(rs.next())
		{	
			 ProductIdAndWebsiteName rr=new ProductIdAndWebsiteName();
			 rr.product_id=rs.getString("pid");
			 rr.website_name=rs.getString("wnm");
			 productIdAndWebsiteNameList.add(rr);
		}
		rs.close();		
		ps.close();	
		
		////////
					
		ps = con.prepareStatement(sql4);
		ps.setString(1,productIdAndWebsiteNameList.get(0).product_id);
		rs = ps.executeQuery();
		if(productIdAndWebsiteNameList.get(0).website_name.equalsIgnoreCase("FLIPKART")){
			while(rs.next())
			{	
				OTDetail oTDetail=new OTDetail();
				oTDetail.ot_id=rs.getString("id");
				oTDetail.ot_name=rs.getString("name");
				otsForFlipkart.add(oTDetail);
			}
			
			rs.close();		
			ps.close();	

		    for(OTDetail otDetail:otsForFlipkart) {				  	    
				ps = con.prepareStatement(sql5);
				ps.setString(1,productIdAndWebsiteNameList.get(0).product_id);
				ps.setString(2,otDetail.ot_id);
				rs = ps.executeQuery();
				int count=0;
				int goodCt=0;
				while(rs.next())
				{	
					count=count+Integer.parseInt(rs.getString("ct"));
					if(rs.getString("ow_main").equalsIgnoreCase("GOOD"))goodCt=goodCt+Integer.parseInt(rs.getString("ct"));
				}
				calculatePercent c=new calculatePercent();
				try{
				otDetail.ot_percent=String.valueOf(c.getPercent(goodCt,count));
				}catch(Exception e){
					otDetail.ot_percent="0";
				}
				rs.close();		
				ps.close();					  	    
		  	}

		}
		if(productIdAndWebsiteNameList.get(0).website_name.equalsIgnoreCase("AMAZON")){
			while(rs.next())
			{	
				OTDetail oTDetail=new OTDetail();
				oTDetail.ot_id=rs.getString("id");
				oTDetail.ot_name=rs.getString("name");
				otsForAmazon.add(oTDetail);
			}
			
			rs.close();		
			ps.close();				
			
		    for(OTDetail otDetail:otsForAmazon) {				  	    
				ps = con.prepareStatement(sql5);
				ps.setString(1,productIdAndWebsiteNameList.get(0).product_id);
				ps.setString(2,otDetail.ot_id);
				rs = ps.executeQuery();
				int count=0;
				int goodCt=0;
				while(rs.next())
				{	
					count=count+Integer.parseInt(rs.getString("ct"));
					if(rs.getString("ow_main").equalsIgnoreCase("GOOD"))goodCt=goodCt+Integer.parseInt(rs.getString("ct"));
				}
				calculatePercent c=new calculatePercent();
				try{
				otDetail.ot_percent=String.valueOf(c.getPercent(goodCt,count));
				}catch(Exception e){
					otDetail.ot_percent="0";
				}
				rs.close();		
				ps.close();					  	    
		  	}
			
		}
		if(productIdAndWebsiteNameList.get(0).website_name.equalsIgnoreCase("SNAPDEAL")){
			while(rs.next())
			{	
				OTDetail oTDetail=new OTDetail();
				oTDetail.ot_id=rs.getString("id");
				oTDetail.ot_name=rs.getString("name");
				otsForSnapdeal.add(oTDetail);
			}
			
			rs.close();		
			ps.close();	
			
		    for(OTDetail otDetail:otsForSnapdeal) {				  	    
				ps = con.prepareStatement(sql5);
				ps.setString(1,productIdAndWebsiteNameList.get(0).product_id);
				ps.setString(2,otDetail.ot_id);
				rs = ps.executeQuery();
				int count=0;
				int goodCt=0;
				while(rs.next())
				{	
					count=count+Integer.parseInt(rs.getString("ct"));
					if(rs.getString("ow_main").equalsIgnoreCase("GOOD"))goodCt=goodCt+Integer.parseInt(rs.getString("ct"));
				}
				calculatePercent c=new calculatePercent();
				try{
				otDetail.ot_percent=String.valueOf(c.getPercent(goodCt,count));
				}catch(Exception e){
					otDetail.ot_percent="0";
				}
				rs.close();		
				ps.close();					  	    
		  	}

		}
		
		//
		ps = con.prepareStatement(sql4);
		ps.setString(1,productIdAndWebsiteNameList.get(1).product_id);
		rs = ps.executeQuery();
		if(productIdAndWebsiteNameList.get(1).website_name.equalsIgnoreCase("FLIPKART")){
			while(rs.next())
			{	
				OTDetail oTDetail=new OTDetail();
				oTDetail.ot_id=rs.getString("id");
				oTDetail.ot_name=rs.getString("name");
				otsForFlipkart.add(oTDetail);
			}
			
			rs.close();		
			ps.close();	

		    for(OTDetail otDetail:otsForFlipkart) {				  	    
				ps = con.prepareStatement(sql5);
				ps.setString(1,productIdAndWebsiteNameList.get(1).product_id);
				ps.setString(2,otDetail.ot_id);
				rs = ps.executeQuery();
				int count=0;
				int goodCt=0;
				while(rs.next())
				{	
					count=count+Integer.parseInt(rs.getString("ct"));
					if(rs.getString("ow_main").equalsIgnoreCase("GOOD"))goodCt=goodCt+Integer.parseInt(rs.getString("ct"));
				}
				calculatePercent c=new calculatePercent();
				try{
				otDetail.ot_percent=String.valueOf(c.getPercent(goodCt,count));
				}catch(Exception e){
					otDetail.ot_percent="0";
				}
				rs.close();		
				ps.close();					  	    
		  	}

		}
		if(productIdAndWebsiteNameList.get(1).website_name.equalsIgnoreCase("AMAZON")){
			while(rs.next())
			{	
				OTDetail oTDetail=new OTDetail();
				oTDetail.ot_id=rs.getString("id");
				oTDetail.ot_name=rs.getString("name");
				otsForAmazon.add(oTDetail);
			}
			
			rs.close();		
			ps.close();				
			
		    for(OTDetail otDetail:otsForAmazon) {				  	    
				ps = con.prepareStatement(sql5);
				ps.setString(1,productIdAndWebsiteNameList.get(1).product_id);
				ps.setString(2,otDetail.ot_id);
				rs = ps.executeQuery();
				int count=0;
				int goodCt=0;
				while(rs.next())
				{	
					count=count+Integer.parseInt(rs.getString("ct"));
					if(rs.getString("ow_main").equalsIgnoreCase("GOOD"))goodCt=goodCt+Integer.parseInt(rs.getString("ct"));
				}
				calculatePercent c=new calculatePercent();
				try{
				otDetail.ot_percent=String.valueOf(c.getPercent(goodCt,count));
				}catch(Exception e){
					otDetail.ot_percent="0";
				}
				rs.close();		
				ps.close();					  	    
		  	}
			
		}
		if(productIdAndWebsiteNameList.get(1).website_name.equalsIgnoreCase("SNAPDEAL")){
			while(rs.next())
			{	
				OTDetail oTDetail=new OTDetail();
				oTDetail.ot_id=rs.getString("id");
				oTDetail.ot_name=rs.getString("name");
				otsForSnapdeal.add(oTDetail);
			}
			
			rs.close();		
			ps.close();	
			
		    for(OTDetail otDetail:otsForSnapdeal) {				  	    
				ps = con.prepareStatement(sql5);
				ps.setString(1,productIdAndWebsiteNameList.get(1).product_id);
				ps.setString(2,otDetail.ot_id);
				rs = ps.executeQuery();
				int count=0;
				int goodCt=0;
				while(rs.next())
				{	
					count=count+Integer.parseInt(rs.getString("ct"));
					if(rs.getString("ow_main").equalsIgnoreCase("GOOD"))goodCt=goodCt+Integer.parseInt(rs.getString("ct"));
				}
				calculatePercent c=new calculatePercent();
				try{
				otDetail.ot_percent=String.valueOf(c.getPercent(goodCt,count));
				}catch(Exception e){
					otDetail.ot_percent="0";
				}
				rs.close();		
				ps.close();					  	    
		  	}

		}
		//
		
		ps = con.prepareStatement(sql4);
		ps.setString(1,productIdAndWebsiteNameList.get(2).product_id);
		rs = ps.executeQuery();
		if(productIdAndWebsiteNameList.get(2).website_name.equalsIgnoreCase("FLIPKART")){
			while(rs.next())
			{	
				OTDetail oTDetail=new OTDetail();
				oTDetail.ot_id=rs.getString("id");
				oTDetail.ot_name=rs.getString("name");
				otsForFlipkart.add(oTDetail);
			}
			
			rs.close();		
			ps.close();	

		    for(OTDetail otDetail:otsForFlipkart) {				  	    
				ps = con.prepareStatement(sql5);
				ps.setString(1,productIdAndWebsiteNameList.get(2).product_id);
				ps.setString(2,otDetail.ot_id);
				rs = ps.executeQuery();
				int count=0;
				int goodCt=0;
				while(rs.next())
				{	
					count=count+Integer.parseInt(rs.getString("ct"));
					if(rs.getString("ow_main").equalsIgnoreCase("GOOD"))goodCt=goodCt+Integer.parseInt(rs.getString("ct"));
				}
				calculatePercent c=new calculatePercent();
				try{
				otDetail.ot_percent=String.valueOf(c.getPercent(goodCt,count));
				}catch(Exception e){
					otDetail.ot_percent="0";
				}
				rs.close();		
				ps.close();					  	    
		  	}

		}
		if(productIdAndWebsiteNameList.get(2).website_name.equalsIgnoreCase("AMAZON")){
			while(rs.next())
			{	
				OTDetail oTDetail=new OTDetail();
				oTDetail.ot_id=rs.getString("id");
				oTDetail.ot_name=rs.getString("name");
				otsForAmazon.add(oTDetail);
			}
			
			rs.close();		
			ps.close();				
			
		    for(OTDetail otDetail:otsForAmazon) {				  	    
				ps = con.prepareStatement(sql5);
				ps.setString(1,productIdAndWebsiteNameList.get(2).product_id);
				ps.setString(2,otDetail.ot_id);
				rs = ps.executeQuery();
				int count=0;
				int goodCt=0;
				while(rs.next())
				{	
					count=count+Integer.parseInt(rs.getString("ct"));
					if(rs.getString("ow_main").equalsIgnoreCase("GOOD"))goodCt=goodCt+Integer.parseInt(rs.getString("ct"));
				}
				calculatePercent c=new calculatePercent();
				try{
				otDetail.ot_percent=String.valueOf(c.getPercent(goodCt,count));
				}catch(Exception e){
					otDetail.ot_percent="0";
				}
				rs.close();		
				ps.close();					  	    
		  	}
			
		}
		if(productIdAndWebsiteNameList.get(2).website_name.equalsIgnoreCase("SNAPDEAL")){
			while(rs.next())
			{	
				OTDetail oTDetail=new OTDetail();
				oTDetail.ot_id=rs.getString("id");
				oTDetail.ot_name=rs.getString("name");
				otsForSnapdeal.add(oTDetail);
			}
			
			rs.close();		
			ps.close();	
			
		    for(OTDetail otDetail:otsForSnapdeal) {				  	    
				ps = con.prepareStatement(sql5);
				ps.setString(1,productIdAndWebsiteNameList.get(2).product_id);
				ps.setString(2,otDetail.ot_id);
				rs = ps.executeQuery();
				int count=0;
				int goodCt=0;
				while(rs.next())
				{	
					count=count+Integer.parseInt(rs.getString("ct"));
					if(rs.getString("ow_main").equalsIgnoreCase("GOOD"))goodCt=goodCt+Integer.parseInt(rs.getString("ct"));
				}
				calculatePercent c=new calculatePercent();
				try{
				otDetail.ot_percent=String.valueOf(c.getPercent(goodCt,count));
				}catch(Exception e){
					otDetail.ot_percent="0";
				}
				rs.close();		
				ps.close();					  	    
		  	}

		}


		//
		
		con.close();
		}
	catch(SQLException sqe)
	{
		out.println(sqe);
	}

%>

  <div class="wrap">
	<div class="header">
		<div class="headertop_desc">
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
			    	<li><a href="user_home.jsp">Home</a></li>
		  
 			    	<div class="clear"></div>
     			</ul>
	     	</div>
	     	<div class="clear"></div>
	     </div>	     	
   </div>
 <div class="main">
    <div class="content">
    	<div class="content_top">
    		<div class="back-links">
    		<a href="user_home.jsp">Home</a> >>>> <a href="#"><%=catname%></a>
    	    </div>
    		<div class="clear"></div>
    	</div>
    	<div class="section group">
				<div class="cont-desc span_1_of_2">
				  <div class="product-details">				
					<div class="grid images_3_of_2">
						<div id="container">
						   <div id="products_example">
							   <div id="products">
								<div class="slides_container">
									<a href="#" target="_blank"><img src="./<%=image_path %>" alt=" " /></a>
								</div>
								<ul class="pagination">
									<li><a href="#"><img src="./<%=image_path %>" alt=" " /></a></li>
								</ul>
							</div>
						</div>
					</div>
				</div>
				<div class="desc span_3_of_2">
					<h2><%=name %></h2>
					<p><%=description %></p>					
					<div class="price">
						<p>Price: <span><%=price %></span></p>
					</div>
					<div class="available">
						<p>Available Options :</p>
					<ul>
						<li>Quantity:<select>
							<option>1</option>
							<option>2</option>
							<option>3</option>
							<option>4</option>
							<option>5</option>
						</select></li>
					</ul>
					</div>
				<div class="share-desc">
					<div class="share">
						<p>Share Product :</p>
						<ul>
					    	<li><a href="https://www.facebook.com/login"><img src="images/facebook.png" alt="" /></a></li>
					    	<li><a href="https://twitter.com/login"><img src="images/twitter.png" alt="" /></a></li>					    
			    		</ul>
					</div>
					
				</div>
				 
			</div>
			<div class="clear"></div>
		  </div>
		<div class="product_desc">	
			<div id="horizontalTab">
				<ul class="resp-tabs-list">
					<li>Product Details</li>
					<li>Product Reviews</li>
					<li>Real Time Reviews</li>
				
					<div class="clear"></div>
				</ul>
				<div class="resp-tabs-container">
					<div class="product-desc">
					<div id="chartContainerAmazon">
					
					</div>
					<hr>
					<div id="chartContainerFlipkart">
					
					</div>
					<hr>
					<div id="chartContainerSnapdeal">
					
					</div>
					<hr>
					<div id="chartContainerAll">
					
					</div>
					
					</div>
					
				 <div class="review">
				<%
				for(int i=0;i<reviews.size();i++){
					out.println("<h4>"+(i+1)+". Review by : "+reviews.get(i).reviewer_nm+"</h4>");
					 out.println("<p>"+reviews.get(i).review+"</p>");
					 out.println("<p>");
				}
				%>					 
				
				  <div class="your-review">
				  	 <h3>How Do You Rate This Product?</h3>
				  	  <p>Write Your Own Review?</p>
				  	  <form id="submitReviewform"  role="form" method="post" action="/MarketingPortal/submitReview.jsp" onsubmit="return checkReview(this)">
				  	  <input type="hidden" name="pid" value="<%=id%>">
				  	  <input type="hidden" name="reviewer" value="<%=session.getAttribute("name")%>">
				  	  <input type="hidden" name="website_id" value="<%=session.getAttribute("website_id")%>">
				  	  <input type="hidden" name="user_id" value="<%=session.getAttribute("user_id")%>">
						    <div>
						    	<span><label>Review<span class="red">*</span></label></span>
						    	<span><textarea id="review" name="review"> </textarea></span>
						    </div>
						   <div>
						   		<span><input type="submit" value="SUBMIT REVIEW"></span>
						  </div>
						  <div>
						 
						  </div>
					    </form>
					    
				  	 </div>	
				  	 			
				</div>
				<div class="your-review">
				  		 <form action="view" method="post">
				  		  <input type="hidden" name="pid" value="<%=id%>">
  							<input type="submit" value="Get Real Time Reviews for this Product"> 

						</form>
				  	 </div>
	 		</div>
		 </div>
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
        </div>
				<div class="rightsidebar span_3_of_1">
					<h2>CATEGORIES</h2>
					<ul>
				  	<%
				  	Iterator it = categories.entrySet().iterator();
				    while (it.hasNext()) {
				        Map.Entry entry = (Map.Entry)it.next();
				  	    String key = entry.getKey().toString();
				  	    String value = entry.getValue().toString();
				  	    out.println("<li><a href='user_home.jsp?category_id="+key+"'>"+value+"</a></li>");
				  	    it.remove();
				  	}
				  	%>
    				</ul>
    				
      				 
 				</div>
 		</div>
 	</div>
    </div>
 </div>
                            <%
                           StringBuffer sbamazon=new StringBuffer();
											sbamazon.append("[");
                          for(int i=0;i<otsForAmazon.size();i++){
                        	  OTDetail ot=otsForAmazon.get(i);
                        	  sbamazon.append("{ y: "+ot.ot_percent+", label: '"+ot.ot_percent+"%', indexLabel: '"+ot.ot_name+"' }");
                        	  if(i!=otsForAmazon.size()-1)
                        		  sbamazon.append(",");
                          }
                          sbamazon.append("]");
                          
                          StringBuffer sbflipkart=new StringBuffer();
                          sbflipkart.append("[");
                         for(int i=0;i<otsForFlipkart.size();i++){
                       	  OTDetail ot=otsForFlipkart.get(i);
                       	sbflipkart.append("{ y: "+ot.ot_percent+", label: '"+ot.ot_percent+"%', indexLabel: '"+ot.ot_name+"' }");
                       	  if(i!=otsForFlipkart.size()-1)
                       		sbflipkart.append(",");
                         }
                         sbflipkart.append("]");

                         StringBuffer sbSnapdel=new StringBuffer();
                         sbSnapdel.append("[");
                        for(int i=0;i<otsForSnapdeal.size();i++){
                      	  OTDetail ot=otsForSnapdeal.get(i);
                      	sbSnapdel.append("{ y: "+ot.ot_percent+", label: '"+ot.ot_percent+"%', indexLabel: '"+ot.ot_name+"' }");
                      	  if(i!=otsForSnapdeal.size()-1)
                      		sbSnapdel.append(",");
                        }
                        sbSnapdel.append("]");
//

                         StringBuffer sbAll=new StringBuffer();
                         sbAll.append("[");
                        for(int i=0;i<otsForAmazon.size();i++){
                      	  	String otnm=otsForAmazon.get(i).ot_name;
                      	  	int x=Integer.parseInt(otsForAmazon.get(i).ot_percent);
                          	for(int j=0;j<otsForFlipkart.size();j++){
                          	  if(otsForFlipkart.get(j).ot_name.equalsIgnoreCase(otnm)){
                          		x=x+Integer.parseInt(otsForFlipkart.get(j).ot_percent);
                          	  }                          	  
                            }
                          	
                          	for(int j=0;j<otsForSnapdeal.size();j++){
                          	  if(otsForSnapdeal.get(j).ot_name.equalsIgnoreCase(otnm)){
                          		x=x+Integer.parseInt(otsForSnapdeal.get(j).ot_percent);
                          	  }
                            }
                          	x=x/3;
                          	sbAll.append("{ y: "+String.valueOf(x)+", label: '"+String.valueOf(x)+"%', indexLabel: '"+otnm+"' }");
                        	  if(i!=otsForAmazon.size()-1)
                        		sbAll.append(",");
                        }
                        sbAll.append("]");
                        
                        

                          %>
 
 <script type="text/javascript">
 window.onload = function () {
     var chartAmazon = new CanvasJS.Chart("chartContainerAmazon", {
         title: {
             text: "Amazon Review Ratings",
             fontFamily: "Verdana",
             fontColor: "Peru",
             fontSize: 22

         },
         animationEnabled: true,
         axisY: {
             tickThickness: 0,
             lineThickness: 0,
             valueFormatString: " ",
             gridThickness: 0                    
         },
         axisX: {
             tickThickness: 0,
             lineThickness: 0,
             labelFontSize: 18,
             labelFontColor: "Peru"

         },
         data: [
         {
             indexLabelFontSize: 26,
             toolTipContent: "<span style='\"'color: {color};'\"'><strong>{indexLabel}</strong></span><span style='\"'font-size: 20px; color:peru '\"'><strong>{y}</strong></span>",

             indexLabelPlacement: "inside",
             indexLabelFontColor: "black",
             indexLabelFontWeight: 600,
             indexLabelFontFamily: "Verdana",
             color: "#62C9C3",
             type: "column",
             dataPoints: <%out.println(sbamazon.toString());%>
         }
         ]
     });

     chartAmazon.render();
     
     var chartFlipkart = new CanvasJS.Chart("chartContainerFlipkart", {
         title: {
             text: "Flipkart Review Ratings",
             fontFamily: "Verdana",
             fontColor: "Peru",
             fontSize: 22

         },
         animationEnabled: true,
         axisY: {
             tickThickness: 0,
             lineThickness: 0,
             valueFormatString: " ",
             gridThickness: 0                    
         },
         axisX: {
             tickThickness: 0,
             lineThickness: 0,
             labelFontSize: 18,
             labelFontColor: "Peru"

         },
         data: [
         {
             indexLabelFontSize: 26,
             toolTipContent: "<span style='\"'color: {color};'\"'><strong>{indexLabel}</strong></span><span style='\"'font-size: 20px; color:peru '\"'><strong>{y}</strong></span>",

             indexLabelPlacement: "inside",
             indexLabelFontColor: "black",
             indexLabelFontWeight: 600,
             indexLabelFontFamily: "Verdana",
             color: "#62C9C3",
             type: "column",
             dataPoints: <%out.println(sbflipkart.toString());%>
         }
         ]
     });

     chartFlipkart.render();

     var chartSnapdeal = new CanvasJS.Chart("chartContainerSnapdeal", {
         title: {
             text: "Snapdeal Review Ratings",
             fontFamily: "Verdana",
             fontColor: "Peru",
             fontSize: 22

         },
         animationEnabled: true,
         axisY: {
             tickThickness: 0,
             lineThickness: 0,
             valueFormatString: " ",
             gridThickness: 0                    
         },
         axisX: {
             tickThickness: 0,
             lineThickness: 0,
             labelFontSize: 18,
             labelFontColor: "Peru"

         },
         data: [
         {
             indexLabelFontSize: 26,
             toolTipContent: "<span style='\"'color: {color};'\"'><strong>{indexLabel}</strong></span><span style='\"'font-size: 20px; color:peru '\"'><strong>{y}</strong></span>",

             indexLabelPlacement: "inside",
             indexLabelFontColor: "black",
             indexLabelFontWeight: 600,
             indexLabelFontFamily: "Verdana",
             color: "#62C9C3",
             type: "column",
             dataPoints: <%out.println(sbSnapdel.toString());%>
         }
         ]
     });

     chartSnapdeal.render();

     var chartAll = new CanvasJS.Chart("chartContainerAll", {
         title: {
             text: "Overall Review Ratings",
             fontFamily: "Verdana",
             fontColor: "Peru",
             fontSize: 22

         },
         animationEnabled: true,
         axisY: {
             tickThickness: 0,
             lineThickness: 0,
             valueFormatString: " ",
             gridThickness: 0                    
         },
         axisX: {
             tickThickness: 0,
             lineThickness: 0,
             labelFontSize: 18,
             labelFontColor: "Peru"

         },
         data: [
         {
             indexLabelFontSize: 26,
             toolTipContent: "<span style='\"'color: {color};'\"'><strong>{indexLabel}</strong></span><span style='\"'font-size: 20px; color:peru '\"'><strong>{y}</strong></span>",

             indexLabelPlacement: "inside",
             indexLabelFontColor: "black",
             indexLabelFontWeight: 600,
             indexLabelFontFamily: "Verdana",
             color: "#62C9C3",
             type: "column",
             dataPoints: <%out.println(sbAll.toString());%>
         }
         ]
     });

     chartAll.render();

 }
 </script>
 <script type="text/javascript" src="js/canvasjs.min.js"></script>

</body>
</html>

    