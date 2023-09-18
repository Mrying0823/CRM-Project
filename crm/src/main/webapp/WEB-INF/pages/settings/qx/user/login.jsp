<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%--改成动态链接，不写死--%>
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
<script type="text/javascript" src="jquery/crypto-js_4.1.1.js"></script>
<script type="text/javascript" src="jquery/bootstrap-3.3.7/js/bootstrap.min.js"></script>
<script type="text/javascript">
	const dots = [".","..","...","....",".....","......"];
	let currentDotIndex = 0;
	let animationInterval;

	function animateDots() {
		// 获取要显示省略号的元素
		const msgElement = document.getElementById("msg");

		// 更新文本内容为对应的省略号
		msgElement.textContent = "验证中" + dots[currentDotIndex];

		// 更新省略号索引，循环显示省略号
		currentDotIndex = (currentDotIndex + 1) % dots.length;
	}

	function startAnimation() {
		// 开始动画，每500毫秒刷新一次
		animationInterval = setInterval(animateDots, 500);
	}

	function stopAnimation() {
		// 停止动画，清除定时器
		clearInterval(animationInterval);
		animationInterval = null;

		// 更新文本内容为默认状态
		const msgElement = document.getElementById("msg");
		msgElement.textContent = "";
	}

	function disableLoginButton() {
		// 禁用登录按钮
		const loginBtn = document.getElementById("loginBtn");
		loginBtn.disabled = true;
	}

	function enableLoginButton() {
		// 启用登录按钮
		const loginBtn = document.getElementById("loginBtn");
		loginBtn.disabled = false;
	}

	$(function () {
		$(document).ready(function() {
			// 给整个浏览器窗口添加键盘按下事件
			$(window).keydown(function (e) {
				// 按下回车键，提交登录请求
				if (e.keyCode === 13) {
					$("#loginBtn").click();
				}
			})
		});

		// 将本地存储的密码自动写入密码输入框
		// 密码输入框只写入原始密码
		$(document).ready(function() {
			document.getElementById("loginAct").value = localStorage.getItem("loginAct");
			document.getElementById("loginPwd").value = localStorage.getItem("loginOriPwd");

			const loginAct = $.trim($("#loginAct").val());
			const loginPwd = $.trim($("#loginPwd").val());

			// 如果用户名输入框和密码输入框均不为空，记住密码复选框打勾
			if (loginAct !== "" && loginPwd !== "") {
				$("#isRemPwd").prop("checked", true);
			}
		});

		// 给“登录”按钮添加点击事件
		$("#loginBtn").click(function () {
			// 前台收集参数
			const loginAct = $.trim($("#loginAct").val());
			const loginOriPwd = $.trim($("#loginPwd").val());
			const isRemPwd = $("#isRemPwd").prop("checked");

			// 重置
			currentDotIndex = 0;

			// 使用 MD5 加密算法进行加密
			const loginPwd = CryptoJS.MD5(loginOriPwd).toString().toLowerCase();

			// 发送请求
			$.ajax({
				url:"settings/qx/user/login.do",
				data: {
					loginAct: loginAct,
					loginPwd: loginPwd,
				},
				type: "post",
				dataType: "json",
				success: function (data) {
					if(data.code === "1") {

						// 请求成功，停止动画
						stopAnimation();

						enableLoginButton();

						if(isRemPwd) {
							// 如果记住密码，则将用户名和密码存储在LocalStorage中
							// 为了防止加密密码覆盖原始密码存入 localStorage，区别 loginPwd 和 loginOriPwd
							localStorage.setItem("loginAct",loginAct);
							localStorage.setItem("loginOriPwd",loginOriPwd);
						}else {
							// 如果不记住密码，则清除LocalStorage中保存的用户名和密码
							localStorage.clear();
						}

						// 跳转业务主界面
						window.location.href="workbench/index.do";
					}else {

						// 停止动画
						stopAnimation();

						enableLoginButton();

						// 提示信息
						$("#msg").text(data.message);
					}
				},
				error: function() {
					// 请求失败，停止动画
					stopAnimation();
					enableLoginButton();
					// 显示错误信息
					$("#msg").text("请求失败，请稍后重试");
				},
				beforeSend: function () {

					/**
					 * 当 ajax 向后台发送请求之前，会自动执行本函数
					 * 该函数的返回值能够觉得 ajax 是否真正向后台发送请求
					 * true，ajax 真正向后台发送请求
					 * false，ajax 放弃向后台发送请求
					 */

					// 表单验证
					if(loginAct === "") {
						alert("用户名不为空");
						return false;
					}
					if(loginPwd === ""){
						alert("密码不为空");
						return false;
					}

					startAnimation();

					// 禁止多次按下登录按钮 post
					disableLoginButton();

					return true;
				}
			})
		})
	})
</script>
	<title>登录界面</title>
</head>
<body>
	<div style="position: absolute; top: 0; left: 0; width: 60%;">
		<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;" alt="">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman',sans-serif">CRM &nbsp;<span style="font-size: 12px;">&copy;2019&nbsp;动力节点</span></div>
	</div>

	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form action="workbench/index" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<label for="loginAct"></label><input class="form-control" id="loginAct" type="text" placeholder="用户名">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<label for="loginPwd"></label><input class="form-control" id="loginPwd" type="password" placeholder="密码">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						<label>
							<input type="checkbox" id="isRemPwd">
							记住密码
						</label>
						&nbsp;&nbsp;
						<span id="msg" style="color: red"></span>
					</div>
					<button type="button" id="loginBtn" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>