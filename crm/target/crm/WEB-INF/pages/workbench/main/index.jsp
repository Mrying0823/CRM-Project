<%@ page contentType="text/html;charset=UTF-8" %>
<%
String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
	<%--所有资源文件基于一下链接访问--%>
	<base href="<%=basePath%>">
<meta charset="UTF-8">
<link href="jquery/bootstrap-3.3.7/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-3.3.7/js/bootstrap.min.js"></script>
	<title>首页</title>

</head>
<body>
	<img src="image/149.jpg" style="width: 100vw;height: 100vh;object-fit: cover"/>
</body>
</html>