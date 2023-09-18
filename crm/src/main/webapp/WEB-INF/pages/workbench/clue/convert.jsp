<%@ page contentType="text/html;charset=UTF-8" %>
<!-- 引入核心标签库 -->
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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


<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">
	$(function(){
		$("#isCreateTran").click(function(){
			if(this.checked){
				$("#create-transaction2").show(200);
			}else{
				$("#create-transaction2").hide(200);
			}
		});

		$("#expectedDate").datetimepicker({
			format: "yyyy-mm-dd",
			minView: "month",
			initialDate: new Date(),
			language: "zh-CN",
			autoclose: true,
			todayBtn: true,
			clearBtn: true,
		});

		// 给“搜索市场活动”按钮添加点击事件
		$("#searchActivityBtn").click(function () {
			// 打开搜索市场活动模态窗口
			$("#searchActivityModal").modal("show");
		});

		// 给整个浏览器窗口添加键盘按下事件
		$(window).keydown(function (e) {
			// 按下回车键，阻止默认行为
			if (e.keyCode === 13) {
				return false;
			}
		});

		// 给“市场活动源”搜索框添加键盘弹起事件
		$("#searchActivityText").keyup(function () {
			// 收集参数
			var activityName = this.value;
			// 获取作用域数据要加双引号
			var clueId = "${requestScope.clue.id}";
			var template = "";

			// 发送请求
			$.ajax({
				url: "workbench/clue/queryActivityForConvertByNameAndClueId.do",
				data: {
					activityName: activityName,
					clueId: clueId
				},
				type: "post",
				dataType: "json",
				success: function (data) {
					// 遍历 data，显示搜索到的市场活动
					$.each(data,function (index,obj) {
						var isActive = index % 2 === 0 ? "" : "active";

						template +=
								`<tr class=`+isActive+`>
									<td><input type="radio" value="`+obj.id+`" activityName="`+obj.name+`" name="activity"/></td>
									<td>`+obj.name+`</td>
									<td>`+obj.startDate+`</td>
									<td>`+obj.endDate+`</td>
									<td>`+obj.owner+`</td>
								</tr>`;
					});

					$("#tBody").html(template);
				}
			});
		});

		// 给所有市场活动选择按钮添加点击事件
		$("#tBody").on("click","input[type = 'radio']",function () {
			// 获取市场活动的 id 和 name
			var activityId = this.value;
			var activityName = $(this).attr("activityName");

			// 把市场活动的 id 写到隐藏域，把 name 写到输入框中
			$("#activityId").val(activityId);
			$("#activityName").val(activityName);

			// 关闭搜索市场活动的模态窗口
			$("#searchActivityModal").modal("hide");
		});
		
		// 给“转换”按钮添加点击事件
		$("#saveConvertClueBtn").click(function () {
			// 收集参数
			var clueId = "${requestScope.clue.id}";
			var money = $.trim($("#money").val());
			var name = $.trim($("#name").val());
			var expectedDate = $("#expectedDate").val();
			var stage = $("#stage").val();
			var activityId = $("#activityId").val();
			var isCreateTran = $("#isCreateTran").prop("checked");

			// 表单验证
			var regExp=/^(([1-9]\d*)|0)$/;

			if(!regExp.test(money)) {
				alert("金额只能为非负数");
				return;
			}

			// 发送请求
			$.ajax({
				url: "workbench/clue/convertClue.do",
				data: {
					clueId: clueId,
					money: money,
					name: name,
					expectedDate: expectedDate,
					stage: stage,
					activityId: activityId,
					isCreateTran: isCreateTran
				},
				type: "post",
				dataType: "json",
				success: function (data) {
					if(data.code === "1") {
						// 跳转至线索主界面
						window.location.href = "workbench/clue/index.do";
					}else {
						alert(data.message);
					}
				}
			})
		})
	});
</script>

</head>
<body>
	
	<!-- 搜索市场活动的模态窗口 -->
	<div class="modal fade" id="searchActivityModal" role="dialog" >
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">搜索市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
							  <label>
								  <input id="searchActivityText" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
							  </label>
							  <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="tBody"></tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<div id="title" class="page-header" style="position: relative; left: 20px;">
		<h4>转换线索 <small>${requestScope.clue.fullname}${requestScope.clue.appellation}-${requestScope.clue.company}</small></h4>
	</div>
	<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
		新建客户：${requestScope.clue.company}
	</div>
	<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
		新建联系人：${requestScope.clue.fullname}${requestScope.clue.appellation}
	</div>
	<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
		<input type="checkbox" id="isCreateTran"/><label for="isCreateTran">为客户创建交易</label>
	</div>
	<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >
	
		<form>
		  <div class="form-group" style="width: 400px; position: relative; left: 20px;">
		    <label for="money">金额</label>
		    <input type="text" class="form-control" id="money">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="name">交易名称</label>
		    <input type="text" class="form-control" id="name" value="${requestScope.clue.company}-">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="expectedDate">预计成交日期</label>
		    <input type="text" class="form-control" id="expectedDate" readonly>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="stage">阶段</label>
		    <select id="stage"  class="form-control">
		    	<option></option>
				<c:forEach items="${requestScope.clueStageList}" var="stage">
					<option value="${stage.id}">${stage.value}</option>
				</c:forEach>
		    </select>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label>市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="searchActivityBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
			  <input type="hidden" id="activityId">
			  <label for="activityName"></label><input type="text" class="form-control" id="activityName" placeholder="点击上面搜索" readonly>
		  </div>
		</form>
		
	</div>
	
	<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
		记录的所有者：<br>
		<b>${requestScope.clue.owner}</b>
	</div>
	<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
		<input id="saveConvertClueBtn" class="btn btn-primary" type="button" value="转换">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input class="btn btn-default" type="button" value="取消">
	</div>
</body>
</html>