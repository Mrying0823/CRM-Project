<%@ page contentType="text/html;charset=UTF-8" %>
<!-- 引入核心标签库 -->
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
    <%--所有资源文件基于一下链接访问--%>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/echarts/echarts.min.js"></script>

    <script type="text/javascript">

    </script>
    <title>echarts 图表</title>

</head>
<body>

</body>
</html>