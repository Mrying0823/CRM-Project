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
<script type="text/javascript">
	$(function () {
		// 给“创建”按钮添加单击事件
		$("#saveBtn").click(function () {
			// 发送同步请求
			window.location.href="settings/dictionary/type/toSave.do";
		});

		// 给“编辑”按钮添加单击事件
		$("#editBtn").click(function () {
			// 发送同步请求
			window.location.href="settings/dictionary/type/toEdit.do";
		});

/*		// 在前端显示会话数据
		var tbody = $("#dictionaryTypeDisplay");
		$.each(function() {
			var row = $('<tr>');
			row.append($('<td>').text(${sessionScope.sessionDictionaryType.code}));
			row.append($('<td>').text(${sessionScope.sessionDictionaryType.name}));
			row.append($('<td>').text(${sessionScope.sessionDictionaryType.description}));
			tbody.append(row);
		});*/
	})
</script>
<title>数据字典类型主界面</title>
</head>
<body>

	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>字典类型列表</h3>
			</div>
		</div>
	</div>
	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
		<div class="btn-group" style="position: relative; top: 18%;">
		  <button type="button" class="btn btn-primary" id="saveBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
		  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
		  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	<div style="position: relative; left: 30px; top: 20px;">
		<table class="table table-hover" id="dictionaryTypeDisplay">
			<thead>
				<tr style="color: #B3B3B3;">
					<td><label><input type="checkbox" /></label></td>
					<td>序号</td>
					<td>编码</td>
					<td>名称</td>
					<td>描述</td>
				</tr>
			</thead>
			<tbody>
			</tbody>
		</table>
	</div>
	
</body>
</html>