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
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-3.3.7/js/bootstrap.min.js"></script>
<script type="text/javascript">

	function disableLoginButton() {
		// 禁用登录按钮
		const saveBtn = document.getElementById("saveBtn");
		saveBtn.disabled = true;
	}

	function enableLoginButton() {
		// 启用登录按钮
		const saveBtn = document.getElementById("saveBtn");
		saveBtn.disabled = false;
	}

	$(function () {
		// 给整个浏览器窗口添加键盘按下事件
		$(window).keydown(function (e) {
			// 按下回车键，提交插入请求
			if (e.keyCode === 13) {
				$("#saveBtn").click();
			}
		})

		// 给“保存”按钮添加点击事件
		$("#saveBtn").click(function () {
			// 前台收集参数
			const code = $.trim($("#code").val());
			const name = $.trim($("#name").val());
			const description = $.trim($("#description").val());

			// 发送请求
			$.ajax({
				url:"settings/dictionary/type/save.do",
				data: {
					code: code,
					name: name,
					description: description
				},
				type: "post",
				dataType: "json",
				success: function (data) {
					if(data.code === "1") {

						enableLoginButton();

						// 返回数据字典类型主界面
						window.location.href="settings/dictionary/type/index.do";
					}else {

						enableLoginButton();

						// 提示信息
						alert(data.message);
					}
				},
				error: function() {

					enableLoginButton();
					// 显示错误信息
					alert("请求失败，请稍后重试");
				},
				beforeSend: function () {

					/**
					 * 当 ajax 向后台发送请求之前，会自动执行本函数
					 * 该函数的返回值能够觉得 ajax 是否真正向后台发送请求
					 * true，ajax 真正向后台发送请求
					 * false，ajax 放弃向后台发送请求
					 */

					// 表单验证
					if(code === "") {
						alert("编码不为空");
						return false;
					}
					if(name === ""){
						alert("名称不为空");
						return false;
					}
					if(description === ""){
						alert("描述不为空");
						return false;
					}

					// 禁止多次按下登录按钮 post
					disableLoginButton();

					return true;
				}
			})
		})
	})
</script>
	<title>创建</title>
</head>
<body>

	<div style="position:  relative; left: 30px;">
		<h3>新增字典类型</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
			<button type="button" class="btn btn-default" onclick="window.history.back();">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form">
					
		<div class="form-group">
			<label class="col-sm-2 control-label">编码<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<label for="code"></label><input type="text" class="form-control" id="code" style="width: 200%;">
			</div>
		</div>
		
		<div class="form-group">
			<label class="col-sm-2 control-label">名称</label>
			<div class="col-sm-10" style="width: 300px;">
				<label for="name"></label><input type="text" class="form-control" id="name" style="width: 200%;">
			</div>
		</div>
		
		<div class="form-group">
			<label class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 300px;">
				<label for="description"></label><textarea class="form-control" rows="3" id="description" style="width: 200%;"></textarea>
			</div>
		</div>
	</form>
	
	<div style="height: 200px;"></div>
</body>
</html>