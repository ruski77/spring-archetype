<%
String userAgent = request.getHeader("user-agent");

if (userAgent != null) {
	if (userAgent.indexOf("Android") != -1 ||
	    userAgent.indexOf("webOS") != -1 ||
	    userAgent.indexOf("iPhone") != -1 ||
	    userAgent.indexOf("iPod") != -1 ||
	    userAgent.indexOf("Windows Phone OS") != -1 ||
	    userAgent.indexOf("Nokia") != -1 ||
	    userAgent.indexOf("Blackberry") != -1) {
		
		response.sendRedirect("app/mobile/home");
	} else {
		response.sendRedirect("app/home");
	}
} else {
	response.sendRedirect("app/home");	
}
%>