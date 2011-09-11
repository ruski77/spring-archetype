#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="adcowebsolutions.utils.WebUtils" %>
<%@ page import="adcowebsolutions.utils.StringUtils" %>
<%@ taglib uri='http://java.sun.com/jsp/jstl/fmt' prefix='fmt'%>
<%@ taglib uri='http://java.sun.com/jsp/jstl/core' prefix='c'%>
<%
	String errorCode = request.getParameter("status");
	String titleMsg = "Error";
	String errorMsg = "";
	if (errorCode != null) {
		if (errorCode.equals("exception")) {
			errorMsg = "An application error has occurred.";
		} else if (errorCode.equals("404")) {
			titleMsg = "Page Not Found";
			errorMsg = "The page you are looking for cannot be found.";
		} else if (errorCode.equals("408")) {
			titleMsg = "Time out";
			errorMsg = "Your request has timed out.";
		} else if (errorCode.equals("500")) {
			titleMsg = "Internal Server Error";
			errorMsg = "An internal server error has occurred.";
		} else if (errorCode.equals("503")) {
			titleMsg = "Service unavailable";
			errorMsg = "The web site is currently unable to handle the HTTP request due to a temporary overloading or maintenance of the server.";
		} else if (errorCode.equals("504")) {
			titleMsg = "Time out";
			errorMsg = "Your request has timed out.";
		}
	}
	
	Throwable exception = (Throwable) request.getAttribute("javax.servlet.error.exception");
	boolean exceptionFound = false;
	String exceptionMessage = "";
    if (exception != null) {
       Throwable rootCause = WebUtils.unwrap(exception);
       exceptionMessage = rootCause.getMessage();
       exceptionFound = true;
    }
%>
<html>
<head>
	<title><%=titleMsg%></title>
	<link href="<%=request.getContextPath()%>/style/default.css" rel="stylesheet" type="text/css" />
	<fmt:setBundle basename="Messages"/>
</head>
<body>
	
	<div class="outer-container">
	
		<div class="inner-container">
			
			<div class="header">
				<div class="title">
					<span class="sitename"><a href="<%=request.getContextPath()%>/app/home"><fmt:message key="website_title"/></a></span>
					<div class="slogan"><fmt:message key="label_template"/></div>
				</div>
			</div>
					
			<div class="menu">
			
				<div class="clearer"></div>	
						
			</div>
			
			<div class="main">
	
				<div class="content">
					
					<div id="errorPage">
	          
		          		<h2><fmt:message key="header_how_embarrassing"/></h2>
	      				<p style="padding:10px 0px 10px 0px;font-weight:bold;font-size:1.1em;color:#666666;"><%=errorMsg%></p>
	                    <% if (exceptionFound) { %>
	                    	<p style="font-weight:bold;font-size:1.1em;color:#666666;"><fmt:message key="label_error_message"/>:</p>
	                    	<ul>
	                    		<li>
	                    			<% if (StringUtils.hasValue(exceptionMessage)) { %>
	                    				<%=exceptionMessage%>
	                    			<% } else { %>
	                    				<fmt:message key="label_unknown"/>
	                    			<% }%>
	                    		</li>
	                    	</ul>
	                    <% }%>
						<p style="padding:10px 0px 0px 0px;font-weight:bold;font-size:1.1em;color:#666666;"><fmt:message key="label_additional_info"/>:</p>
		      			<ul>
		      				<li><c:out value="${symbol_dollar}{header['User-Agent']}"/></li>
		      			</ul>
		      			<p style="padding-top:10px;"><fmt:message key="label_if_problem_persists"/>&#160;<a href="mailto:<fmt:message key='support_email'/><fmt:message key='label_error_subject'/>&#160;<fmt:message key='website_name'/>"><fmt:message key="label_here"/></a>&#160;<fmt:message key="label_error_additional_details"/>.</p>
		      			<p><a href="javascript:history.back(1);"><fmt:message key="label_back_to_previous"/></a></p> 
	      			
	     	 		</div>

				</div>
	
				<div class="clearer"></div>
	
			</div>
	
			<div class="footer">
			
				<span class="left">&#169;&#160;<a target="_blank" href="<fmt:message key='adcowebsolutions_url}'/>"><fmt:message key="adcowebsolutions_name"/></a> 2011</span> 
				
				<div class="clearer"></div>
	
			</div>
			
		</div>
			
	</div>

</body>
</html>