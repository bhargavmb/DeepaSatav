<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Reviews</title>
</head>
<body>

<% String pid = request.getParameter("pid"); %>

 <sql:setDataSource var="dbsource" driver="com.mysql.jdbc.Driver"
                           url="jdbc:mysql://localhost:3306/marketingportal"
                           user="root" password="root"/>
	<table>
	  <caption><h2>List Of Review Data</h2></caption>
	  <tr>
	     <th>Customer Name</th>
	     <th>Customer Comment</th>
	     <th>Customer Rate</th>
	     <th>Review Date</th>
	     
	  </tr>
	  
	  
	  <c:forEach var="reviews" items="${result}">
	  	<tr>
	  	  
	  	  <td><c:out value="${reviews.customerName}"></c:out>
	  	  <td><c:out value="${reviews.customerComment}"></c:out>
	  	  <td><c:out value="${reviews.customerRate}"></c:out>
	  	  <td><c:out value="${reviews.customerCommentDate}"></c:out>
	  	</tr>
	  	</c:forEach>
	 </table> 	
	  	<c:forEach var="result" items="${result}">
		<sql:update dataSource="${dbsource }" var="reviews">

			<%-- update real_time_reviews set customerName = ?, customerRate=?, custometCommentDate=?  where product_id='${param.id}';
 --%>
 
	insert into real_time_reviews (customerName,customerComment,customerRate,customerCommentDate,product_id) values (?,?,?,?,?); 

		<sql:param value="${result.customerName }"></sql:param>
		<sql:param value="${result.customerComment }"></sql:param>
		<sql:param value="${result.customerRate }"></sql:param>
		<sql:param value="${result.customerCommentDate }"></sql:param>
		<sql:param value="${result.pid }"></sql:param>
		</sql:update>
		</c:forEach>
</body>
</html>