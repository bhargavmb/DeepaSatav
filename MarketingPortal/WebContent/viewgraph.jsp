
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="java.util.*" %>
<%@page import="com.google.gson.*" %>

<%
    
/* 
    The following 4 code lines contain the database connection information.
    Alternatively, you can move these code lines to a separate file and
    include the file here. You can also modify this code based on your 
    database connection. 
 */

   String hostdb = "localhost:3306";  // MySQl host
   String userdb = "root";  // MySQL username
   String passdb = "root";  // MySQL password
   String namedb = "marketingportal";  // MySQL database name

    // Establish a connection to the database
    DriverManager.registerDriver(new com.mysql.jdbc.Driver());
    Connection con = DriverManager.getConnection("jdbc:mysql://" + hostdb + "/" + namedb , userdb , passdb);
   
    %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Graph </title>
<!-- Step 1: Include the `fusioncharts.js` file. This file is needed to
        render the chart. Ensure that the path to this JS file is correct.
        Otherwise, it may lead to JavaScript errors.
--> 
    <script src="scripts/fusioncharts.js"></script>
    </head>
    <body>
    <div class="container-fluid">
    <div class="row">
         <div id="chart" class="col-sm-6" style="float:left;"></div>
           <div class="col-sm-6" style="width: 37%; float: left; margin-top: 74px; margin-left: 170px;">
                           <hr>
                    <b style="text-align: center;color: #337ab7;tab-size: 25px">Review Count</b>
                    <div class="row" style="overflow: scroll;border: 1px solid #0088cc;margin-left: auto;margin-right: auto;">
                       
                        <table class="table table-responsive" style="text-align: center">
                            <thead>
                            
                            <%
                          
                           String product_id=request.getParameter("product_id");
                           String subcategpry_id=request.getParameter("subcategory_id");
                           String product_ot_id= null;
                           String  [] product_ot_name= new String[4];
                           int i=0;
                           String ot_status="select distinct product_ot_id from ot_status where product_id="+product_id; 
                           String product_ot="select * from product_ot where product_id="+product_id;
                           String users_sql = "SELECT * FROM ots where subcategory_id="+subcategpry_id;
                           
                           
                            // Execute the query.
                            
                            PreparedStatement pt=con.prepareStatement(users_sql);    
                            ResultSet rs=pt.executeQuery(); 
                            
                            PreparedStatement pt3=con.prepareStatement(ot_status);    
                            ResultSet rs3=pt3.executeQuery();
                            
                            PreparedStatement pt4=con.prepareStatement(product_ot);    
                            ResultSet rs4=pt4.executeQuery();
                           
                            
                               %>
                               
                               <% while(rs4.next()){
                            	   /* String id3=rs3.getString("id"); */
                            	  // int i=0;
                            	  // out.println("ot_id:"+rs4.getString("name"));
                            	   product_ot_name[i]=rs4.getString("name");
                            	   i++;
                            	   
                               } %>
                               
                               <% while(rs3.next()){
                            	   /* String id3=rs3.getString("id"); */
                            	   
                            	   //out.println("ot_id:"+rs3.getString("product_ot_id"));
                            	   product_ot_id=rs3.getString("product_ot_id");
                               } %>
                               
                               <%
                              /*  System.out.print(product_ot_name[0]);
                               System.out.print(product_ot_name[1]);
                               System.out.print(product_ot_name[2]); */

                               String ot_name=product_ot_name[0];
                               //System.out.print("ot_name"+ ot_name);
                              
                              
                               
                               %>
                               
                                <tr style="color: red;background-color: yellow">
                                 
                                   
                                    <td>Name</td>
                                    <td>Positive Review Count</td>
                                    <td>Negative Review Count</td>
                                    
                                </tr>
                            </thead>
                            <tbody>
                              <%
                              i=0;
                                while (rs.next()) {
                                	String id=rs.getString("id");
                                	
                                	
                                %>
                                <tr>
<%--                                     <td><%=rs.getString("name")%></td>
 --%>                                     
 										<td><%=product_ot_name[i]%></td>
 										
 										
                                     <% 
                                     String positive="select id, count(*)AS positive from ot_status where product_id="+product_id+" and ow='GOOD' and product_ot_id=(select id from product_ot where product_id='"+product_id+"'and name='"+product_ot_name[i]+"')";
                                     String negative="select id, count(*)AS negative from ot_status where product_id="+product_id+" and ow='BAD' and product_ot_id=(select id from product_ot where product_id='"+product_id+"'and name='"+product_ot_name[i]+"')";

                                     PreparedStatement pt1=con.prepareStatement(positive);    
                                     ResultSet rs1=pt1.executeQuery(); 
                                     PreparedStatement pt2=con.prepareStatement(negative);    
                                     ResultSet rs2=pt2.executeQuery(); 
                                     
                                     while(rs1.next() && rs2.next()) {
                                    	 
                                     	 String id3=rs1.getString("id");
                                     	String id4=rs2.getString("id"); 
                                     %>
                                     <td><%=rs1.getString("positive")%></td>
                                     <td><%=rs2.getString("negative")%></td>
                                
                              
                               
                              
                                <%   }i++;}
                              
                                %>
                               
                                    <td></td>
                                     <td></td>
                               
                                 </tr>
                 
                            </tbody>
                        </table>
                    </div>
                    <hr>
                </div>
                </div>
                </div>
         
<!--    Step 2: Include the `FusionCharts.java` file as a package in your 
        project.
-->
        <%@page import="fusioncharts.FusionCharts" %>
        
<!--    Step 3:Include the package in the file where you want to show 
        FusionCharts as follows.
        
        Step 4: Create a chart object using the FusionCharts JAVA class 
        constructor. Syntax for the constructor: 
        `FusionCharts("type of chart", "unique chart id", "width of chart",
                        "height of chart", "div id to render the chart", 
                        "data format", "data source")`   
-->           
<% String name=request.getParameter("username"); 
               

               System.out.println(product_id);
               System.out.println(name);
               %>
        <%
         /*
            google-gson
    
            Gson is a Java library that can be used to convert Java Objects into 
            their JSON representation. It can also be used to convert a JSON string to 
            an equivalent Java object. Gson can work with arbitrary Java objects including
            pre-existing objects that you do not have source-code of.
           
         */
    
            Gson gson = new Gson();
            
            
            // Form the SQL query that returns the top 10 most populous countries
            String sql="select id,count(product_id) as product_id from reviews where product_id="+product_id;
			
            // Execute the query.
            pt=con.prepareStatement(sql);    
            rs=pt.executeQuery();
            
            // The 'chartobj' map object holds the chart attributes and data.
            Map<String, String> chartobj = new HashMap<String, String>();
            
            chartobj.put("caption", "Marketing Portal");
            chartobj.put("subCaption" , "Pictorial Graph");
            chartobj.put("xAxisName","Total Review Count");
          
            chartobj.put("yAxisName","Review Count");
            chartobj.put("xAxisFont" , "10");
        
       
            
            chartobj.put("paletteColors" , "#0075c2,#1aaf5d,#f2c500,#f45b00,#8e0000");
            chartobj.put("bgColor" , "#ffffff");
            chartobj.put("showBorder" , "0");
            chartobj.put("use3DLighting" , "10");
            chartobj.put("showShadow" , "0");
            chartobj.put("enableSmartLabels" , "50");
            chartobj.put("startingAngle" , "0");
            chartobj.put("showPercentValues" , "5");
            chartobj.put("showPercentInTooltip" , "0");
            chartobj.put("decimals" , "1");
            chartobj.put("captionFontSize" , "16");
            chartobj.put("subcaptionFontSize" , "14");
            chartobj.put("subcaptionFontBold" , "0");
            chartobj.put("toolTipColor" , "#ffffff");
            chartobj.put( "toolTipBorderThickness" , "0");
            chartobj.put("toolTipBgColor" , "#000000");
            chartobj.put("toolTipBgAlpha" , "80");
            chartobj.put("toolTipBorderRadius" , "2");
            chartobj.put("toolTipPadding" , "5");
            chartobj.put("showHoverEffect" , "1");
            chartobj.put("showLegend" , "1");
            chartobj.put("legendBgColor" , "#ffffff");
            chartobj.put("legendBorderAlpha" , "0");
            chartobj.put("legendShadow" , "0");
            chartobj.put("legendItemFontSize" , "10");
            chartobj.put("legendItemFontColor" , "#666666");
            chartobj.put("useDataPlotColorForLabels" , "1");
 
            // Push the data into the array using map object.
            ArrayList arrData = new ArrayList();
            while(rs.next())
            {
                Map<String, String> lv = new HashMap<String, String>();
               
                lv.put("label", "");
                lv.put("value", rs.getString("product_id"));
               //lv.put("value", rs.getString("signature_gap")); 
                arrData.add(lv);    
                  
            }
            
            //close the connection.
            rs.close();
 
            //create 'dataMap' map object to make a complete FC datasource.
             Map<String, String> dataMap = new LinkedHashMap<String, String>();  
        /*
            gson.toJson() the data to retrieve the string containing the
            JSON representation of the data in the array.
        */
             dataMap.put("chart", gson.toJson(chartobj));
             dataMap.put("data", gson.toJson(arrData));
             

            FusionCharts columnChart= new FusionCharts(
            "column3d",// chartType
                        "chart1",// chartId
                        "600","300",// chartWidth, chartHeight
                        "chart",// chartContainer
                        "json",// dataFormat
                        gson.toJson(dataMap) //dataSource
                    );
           
            %>
            
<!--    Step 5: Render the chart    -->                
            <%=columnChart.render()%>
        
    </body>
</html>
