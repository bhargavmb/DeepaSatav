<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*,java.util.*,java.net.*" %>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Login</title>
</head>
<body>
<%
final String pid = request.getParameter("pid");
final String ipAddress = InetAddress.getLocalHost().toString().split("/")[1];
Connection con= null;
PreparedStatement ps = null;
ResultSet rs = null;

final String driverName = "com.mysql.jdbc.Driver";
final String url = "jdbc:mysql://localhost:3306/marketingportal";
final String user = "root";
final String dbpsw = "root";
String reviewcheck="0";

String review = request.getParameter("review");
String reviewer = request.getParameter("reviewer");
String website_id = request.getParameter("website_id");
String user_id = request.getParameter("user_id");



/* try{
	Class.forName(driverName);
	Connection conn = DriverManager.getConnection(url, user, dbpsw);
	String reviewchecksql = "select * from reviews where user_id="+user_id+" and product_id="+pid;
	Statement pss = conn.createStatement();
	
	ResultSet rss=pss.executeQuery(reviewchecksql);
	if(rss != null){
		while(rss.next()){
			if(rss.getString("reviewcheck") == "1"){
			  reviewcheck = rss.getString("reviewcheck");
			}
		}
	}
	rss.close();
	pss.close();
	}catch(Exception e){
		
	} */


Date date = new Date();
DateFormat dateFormat = new SimpleDateFormat ("dd/MMM/yyyy HH:mm:ss");
String CurrentDate = dateFormat.format(date);
System.out.println("Current Date Time :"+CurrentDate);
String sql = "insert into reviews(product_id,reviewer_name,review,website_id,user_id,ip_address,review_date) values(?,?,?,?,?,?,?)";
class ProductOT{
	public String id;
	public String name;
}
class OTStatus{
	public String review_id;
	public String product_ot_id;
	public String ow;
	public String ow_main;
	
	public void setProductOtId(String ot){
		product_ot_id = ot;
	}
	
	public String getProductOtId(){
		return product_ot_id;
	}
	
	public void setOwMain(String ow_main){
		this.ow_main = ow_main;
	}
	
	public String getOwMain(){
		return ow_main;
	}
	
}

final List<OTStatus> productOtList = new ArrayList<OTStatus>();

class ReviewEvaluator{
	
	public OTStatus evaluateReview(String review){
		Set<String> testSet = new HashSet<String>();
		OTStatus oTStatus=new OTStatus();
		
		int goodWordCount=0; 
		int otcount=0;
		int badWordCount=0;
		
		
		String gg[]=review.split(" and|or|but|,|otherwise|else ");
		/* System.out.println("[1]:"+gg[0]);
		System.out.println("[1]:"+gg[1]); */
		List<ProductOT> otList=getOTs();
		
		for(String g: gg){
				OTStatus otStatusObj = new OTStatus();
				List<String> goodList=getGoodWordList();
				for(ProductOT ot:otList){
				for(String goodWord:goodList){
					if(review.contains("not bad") || review.contains("not worst") )
					{
						goodWordCount++;
					}
					if(goodWord.equalsIgnoreCase(g) && ot.name.equalsIgnoreCase(g)){
						testSet.add(goodWord);
						otStatusObj.setProductOtId(ot.id);
						otStatusObj.setOwMain(goodWord);					
						productOtList.add(otStatusObj);
						goodWordCount++;
						//continue;
						//break;
					}	
				}
				}
				List<String> badList=getBadWordList();
				for(ProductOT ot:otList){
				for(String badWord:badList){
					if(review.contains("not good") || review.contains("not satisfied")){
						badWordCount++;
					}
					
					if(badWord.equalsIgnoreCase(g) && ot.name.equalsIgnoreCase(g)){
						testSet.add(badWord);
						otStatusObj.setProductOtId(ot.id);
						otStatusObj.setOwMain(badWord);					
						productOtList.add(otStatusObj);
						badWordCount++;
						//continue;
						//break;
						
					}
				}
				}
	
		//List<String> goodList=getGoodWordList();
		//List<String> badList=getBadWordList();
		for(ProductOT ot:otList){
		for(String goodWord:goodList){
			if(g.toLowerCase().contains(goodWord.toLowerCase()) && g.toLowerCase().contains(ot.name.toLowerCase())){
				testSet.add(goodWord);
				otStatusObj.setProductOtId(ot.id);
				otStatusObj.setOwMain(goodWord);					
				productOtList.add(otStatusObj);
				goodWordCount++;
				//continue;
				//break;
			}
			
		}
		}
		//List<String> badList=getBadWordList();
		for(ProductOT ot:otList){
		for(String badWord:badList){
			if(g.toLowerCase().contains(badWord.toLowerCase()) && g.toLowerCase().contains(ot.name.toLowerCase())){
				testSet.add(badWord);
				otStatusObj.setProductOtId(ot.id);
				otStatusObj.setOwMain(badWord);					
				productOtList.add(otStatusObj);
				badWordCount++;
				//continue;
				//break;
			}
		}
		//break;
			}
		}
		 Iterator iterator = testSet.iterator(); 
		   // check values
		   String tem="";
		   while (iterator.hasNext()){
		   tem=tem+iterator.next().toString()+" ";
		   }
		   oTStatus.ow_main=tem; 
		
		/* List<ProductOT> otList=getOTs();
		
		List<OTStatus> productOtList = new ArrayList<OTStatus>(); */
		
		/* int x=0;
		for(ProductOT ot:otList){
		 for(String g: gg) {
			
				if(ot.name.equalsIgnoreCase(g)){
					OTStatus otStatusObj = new OTStatus();
					System.out.println("OT is : " +g);
					//oTStatus.product_ot_id=ot.id;
					otStatusObj.setProductOtId(ot.id);
					otStatusObj.setOwMain(tem);					
					productOtList.add(otStatusObj);
					x=1;
					//break;
				}
				
				
			}
			//if(x==1)break;
		} */

		
		 if(goodWordCount==badWordCount){
			oTStatus.ow="GOOD";
			oTStatus.ow="BAD";
		} 
		  
		if(goodWordCount>badWordCount){
			oTStatus.ow="GOOD";
		}
		if(goodWordCount<badWordCount){
			oTStatus.ow="BAD";
		}
		
		
		/* Iterator iterator = testSet.iterator(); 
		   // check values
		   String tem="";
		   while (iterator.hasNext()){
		   tem=tem+iterator.next().toString()+" ";
		   }
		   oTStatus.ow_main=tem; */
		
		return oTStatus; 
	}
	private List<String> getGoodWordList(){
		
		
		List<String> word=new ArrayList<String>();
		word.add("good");
		word.add("very good");
		word.add("osum");
		word.add("awesome");
		word.add("nice");
		word.add("cool");
		word.add("happy");
		word.add("fantastic");
		word.add("excellent");
		word.add("too good");
		
		return word;
	}
	
	private List<String> getBadWordList(){
		
		List<String> word=new ArrayList<String>();
		
		word.add("bad");
		word.add("very bad");
		word.add("worst");
		word.add("poor");
		return word; 
	}
	
	private List<ProductOT> getOTs(){
		List<ProductOT> word=new ArrayList<ProductOT>();
		try{
		Class.forName(driverName);
		Connection conn = DriverManager.getConnection(url, user, dbpsw);
		String sqls="select id,name from product_ot where product_id=?";
		PreparedStatement pss = conn.prepareStatement(sqls, Statement.RETURN_GENERATED_KEYS);
		pss.setString(1, pid);
		ResultSet rss=pss.executeQuery();
		while(rss.next()){
			ProductOT productOT=new ProductOT();
			productOT.id=rss.getString("id");
			productOT.name=rss.getString("name");
			word.add(productOT);
		}
		rss.close();
		pss.close();
		}catch(Exception e){
			
		}
		return word;
	}


}



String reviewType="";
ReviewEvaluator reviewEvaluator=new ReviewEvaluator();
OTStatus oTStatus=reviewEvaluator.evaluateReview(review);
	try{
		Class.forName(driverName);
		con = DriverManager.getConnection(url, user, dbpsw);
		ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
		ps.setString(1, pid);
		ps.setString(2, reviewer);
		ps.setString(3, review);
		ps.setString(4, website_id);
		ps.setString(5, user_id);
		ps.setString(6, ipAddress);
		ps.setString(7, CurrentDate);
		ps.executeUpdate();
		rs=ps.getGeneratedKeys();
		while(rs.next()){
			oTStatus.review_id=String.valueOf(rs.getInt(1));
		}
		
		int x=0;
		for(OTStatus ots : productOtList){
		sql="insert into ot_status(review_id,product_ot_id,ow,ow_main,product_id) values(?,?,?,?,?)";
		ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
		ps.setString(1, oTStatus.review_id);
		ps.setString(2, ots.getProductOtId());
		ps.setString(3, oTStatus.ow);
		ps.setString(4, ots.getOwMain());
		ps.setString(5, pid);
		System.out.println("Id:"+ots.getProductOtId());
		System.out.println("OwMain:"+ots.getOwMain());
		x=ps.executeUpdate();
	}
		if(x>0)
		{			
			response.sendRedirect("buy_products.jsp?product_id="+pid);
		}
		else
			response.sendRedirect("buy_products.jsp?product_id="+pid);
		
		ps.close();
		con.close();
		}
	catch(SQLException sqe)
	{
		out.println(sqe);
	}
	
%>
</body>
</html>
