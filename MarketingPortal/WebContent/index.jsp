<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Marketing Portal</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width;initial-scale=1;maximum-scale=1.0;user-scalable=0;">
<link rel="stylesheet" href="./css/bootstrap.min.css"/>
<link rel="stylesheet" href="./css/bootstrap-theme.min.css"/>
<script src="./js/jquery.min.js"></script>
<script src="./js/bootstrap.min.js"></script>
<link href="./images/favicon.ico" rel="icon" type="image/x-icon"/><!-- main window icon-->
<script language="JavaScript">
function checkLogin(aaa)
{
	if(aaa.usertype.value.trim().length==0)
	{
	document.getElementById("loginError").innerHTML="* usertype required";
	return false;
	}
if(aaa.username.value.trim().length==0)
{
document.getElementById("loginError").innerHTML="* username required";
aaa.username.focus();
return false;
}
if(aaa.password.value.trim().length==0)
{
document.getElementById("loginError").innerHTML="* password required";
aaa.password.focus();
return false;
}
document.getElementById("loginError").innerHTML="";
return true;
}

function checkSignup(aaa)
{
	if(aaa.name.value.trim().length==0)
	{
	document.getElementById("signupError").innerHTML="* name required";
	aaa.name.focus();
	return false;
	}
	
	if(aaa.username.value.trim().length==0)
	{
	document.getElementById("signupError").innerHTML="* username required";
	aaa.username.focus();
	return false;
	}

	if(aaa.email.value.trim().length==0)
	{
	document.getElementById("signupError").innerHTML="* email required";
	aaa.email.focus();
	return false;
	}

	if(aaa.password.value.trim().length==0)
	{
	document.getElementById("signupError").innerHTML="* password required";
	aaa.password.focus();
	return false;
	}
document.getElementById("signupError").innerHTML="";
return true;
}
</script>
<style type="text/css">
header{
  position: relative;
  width: 100%;
  text-align: center;
  font-size: 72px;
  line-height: 108px;
  height: 108px;
  background: #335C7D;
  color: #fff;
  font-family: 'PT Sans', sans-serif;
}

</style>
</head>
<body>
<header><h2><label style="margin-left: 20px;margin-top: 20px;float:left">Extracting Opinion Target and Opinion Word</label></h2></header>
    <div class="container">    
        <div id="loginbox" style="margin-top:50px;" class="mainbox col-md-6 col-md-offset-3 col-sm-8 col-sm-offset-2">                    
            <div class="panel panel-info" >
                    <div class="panel-heading">
                        <div class="panel-title">Sign In</div>
<!--                         <div style="float:right; font-size: 80%; position: relative; top:-10px"><a href="#">Forgot password?</a></div>
 -->                    </div>     

                    <div style="padding-top:30px" class="panel-body" >

                        <div style="display:none" id="login-alert" class="alert alert-danger col-sm-12"></div>
                            
                        <form id="loginform" class="form-horizontal" role="form" method="post" action="/MarketingPortal/login.jsp" onsubmit="return checkLogin(this)">
                            <div style="margin-bottom: 25px" class="input-group">
							  
							  <select class="form-control" name="usertype" id="sel1">
								    <option value="">--Select UserType--</option>
								    <option value="AMAZON">AMAZON</option>
								    <option value="FLIPKART">FLIPKART</option>
								    <option value="SNAPDEAL">SNAPDEAL</option>
							    	<option value="ADMIN">ADMIN</option>
							  </select>
							</div>        
                            <div style="margin-bottom: 25px" class="input-group">
                                        <span class="input-group-addon"><i class="glyphicon glyphicon-user"></i></span>
                                        <input id="login-username" type="text" class="form-control" name="username" value="" placeholder="username">                                        
                                    </div>
                                
                            <div style="margin-bottom: 25px" class="input-group">
                                        <span class="input-group-addon"><i class="glyphicon glyphicon-lock"></i></span>
                                        <input id="login-password" type="password" class="form-control" name="password" placeholder="password">
                                    </div>
                                    

                                
                            <div class="input-group" style="margin-bottom: 25px">
                                      <div class="checkbox">
                                        <label>
                                          <input id="login-remember" type="checkbox" name="remember" value="1"> Remember me
                                        </label>
                                      </div>
                            </div>

                            <div class="input-group">
                                        <p class="text-danger" id="loginError"></p>
                            </div>


                                <div style="margin-top:10px" class="form-group">
                                    <!-- Button -->

                                    <div class="col-sm-12 controls">
                                      <button type="submit" class="btn btn-success">Login</button>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <div class="col-md-12 control">
                                        <div style="border-top: 1px solid#888; padding-top:15px; font-size:85%" >
                                            Don't have an account! 
                                         <a href="#" onClick="$('#loginbox').hide(2000); $('#signupbox').show()">
                                            Sign Up Here
                                        </a>
                                        </div>
                                    </div>
                                </div>    
                            </form>     
                        </div>                     
                    </div>  
        </div>
        <div id="signupbox" style="display:none; margin-top:50px" class="mainbox col-md-6 col-md-offset-3 col-sm-8 col-sm-offset-2">
                    <div class="panel panel-info">
                        <div class="panel-heading">
                            <div class="panel-title">Sign Up</div>
                            <div style="float:right; font-size: 85%; position: relative; top:-10px"><a id="signinlink" href="#" onclick="$('#signupbox').hide(); $('#loginbox').show()">Sign In</a></div>
                        </div>  
                        <div class="panel-body" >
                            <form id="signupform" class="form-horizontal" role="form" method="post" action="/MarketingPortal/signup.jsp" onsubmit="return checkSignup(this)">
                                
                                <div id="signupalert" style="display:none" class="alert alert-danger">
                                    <p>Error:</p>
                                    <span></span>
                                </div>
                                    
                                
                                <div class="form-group">
                                    <label for="firstname" class="col-md-3 control-label">Name</label>
                                    <div class="col-md-9">
                                        <input type="text" class="form-control" name="name" placeholder="Name" required="required">
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="firstname" class="col-md-3 control-label">Username</label>
                                    <div class="col-md-9">
                                        <input type="text" class="form-control" name="username" placeholder="Username">
                                    </div>
                                </div>                                
                                  
                                <div class="form-group">
                                    <label for="email" class="col-md-3 control-label">Email</label>
                                    <div class="col-md-9">
                                        <input type="text" class="form-control" name="email" placeholder="Email Address">
                                    </div>
                                </div>
                                                                    
                                <div class="form-group">
                                    <label for="password" class="col-md-3 control-label">Password</label>
                                    <div class="col-md-9">
                                        <input type="password" class="form-control" name="password" placeholder="Password">
                                    </div>
                                </div>
								
							<div class="input-group">
                                        <p class="text-danger" id="signupError"></p>
                            </div>
								
    
                                <div class="form-group">
                                    <!-- Button -->                                        
                                    <div class="col-md-offset-3 col-md-9">
                                        <button id="btn-signup" type="submit" class="btn btn-info"><i class="icon-hand-right"></i> &nbsp Sign Up</button>
                                        <!-- <span style="margin-left:8px;">or</span> -->  
                                    </div>
                                </div>
                                <!-- 
                                <div style="border-top: 1px solid #999; padding-top:20px"  class="form-group">
                                    
                                    <div class="col-md-offset-3 col-md-9">
                                        <button id="btn-fbsignup" type="button" class="btn btn-primary"><i class="icon-facebook"></i>   Sign Up with Facebook</button>
                                    </div>                                           
                                        
                                </div> -->
                            </form>
                         </div>
                    </div>
         </div> 
    </div>
    
</body>
</html>