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
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-3.3.7/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

	<title>创建交易界面</title>
<script type="text/javascript">

	$(function () {

		$("#create-expectedDate").datetimepicker({
			format: "yyyy-mm-dd",
			minView: "month",
			initialDate: new Date(),
			language: "zh-CN",
			autoclose: true,
			todayBtn: true,
			clearBtn: true,
		});

		$("#create-nextContactTime").datetimepicker({
			format: "yyyy-mm-dd",
			minView: "month",
			initialDate: new Date(),
			language: "zh-CN",
			autoclose: true,
			todayBtn: true,
			clearBtn: true,
			pickerPosition: "top-right"
		});

		// 给“搜索联系人”按钮添加点击事件
		$("#searchContactsBtn").click(function () {
			$("#findContacts").modal("show");
		});

		// 给整个浏览器窗口添加键盘按下事件
		$(window).keydown(function (e) {
			// 按下回车键，阻止默认行为
			if (e.keyCode === 13) {
				return false;
			}
		});

		// 给“联系人”搜索框添加键盘弹起事件
		$("#searchContactsText").keyup(function () {
			// 收集参数
			var contactsName = this.value;
			var template = "";

			// 发送请求
			$.ajax({
				url: "workbench/tran/queryContactsForSaveByName.do",
				data: {
					name: contactsName
				},
				type: "post",
				dataType: "json",
				success: function (data) {
					$.each(data,function (index,obj) {
						var isActive = index % 2 === 0 ? "" : "active";

						template +=
							`<tr class=`+isActive+`>
								<td><input type="radio" contactsName="`+obj.fullname+`" value="`+obj.id+`"/></td>
								<td>`+obj.fullname+`</td>
								<td>`+obj.email+`</td>
								<td>`+obj.mphone+`</td>
							</tr>`
					});

					$("#contactsTBody").html(template);
				}
			});
		});
		
		// 给搜索到的联系人添加点击事件
		$("#contactsTBody").on("click","input[type = 'radio']",function () {
			var contactsId = this.value;
			var contactsName = $(this).attr("contactsName");

			$("#create-contactsId").val(contactsId);
			$("#create-contactsName").val(contactsName);

			// 关闭搜索联系人窗口
			$("#findContacts").modal("hide");
		});

		// 给“搜索市场活动”按钮添加点击事件
		$("#searchActivityBtn").click(function () {
			$("#findMarketActivity").modal("show");
		});
		
		// 给市场活动搜索框添加键盘弹起事件
		$("#searchActivityText").keyup(function () {
			// 收集参数
			var activityName = this.value;
			var template = "";

			// 发送请求
			$.ajax({
				url: "workbench/tran/queryActivityForSaveByName.do",
				data: {
					name: activityName
				},
				type: "post",
				dataType: "json",
				success: function (data) {
					$.each(data,function (index,obj) {
						var isActive = index % 2 === 0 ? "" : "active";

						template +=
							`<tr class=`+isActive+`>
								<td><input type="radio" activityName="`+obj.name+`" value="`+obj.id+`"/></td>
								<td>`+obj.name+`</td>
								<td>`+obj.startDate+`</td>
								<td>`+obj.endDate+`</td>
								<td>`+obj.owner+`</td>
							</tr>`
					});

					$("#activityTBody").html(template);
				}
			});
		});

		// 给搜索到的市场活动添加点击事件
		$("#activityTBody").on("click","input[type = 'radio']",function () {
			var activityId = this.value;
			var activityName = $(this).attr("activityName");

			$("#create-activityId").val(activityId);
			$("#create-activitySrc").val(activityName);

			// 关闭搜索联系人窗口
			$("#findMarketActivity").modal("hide");
		});

		// 给阶段选择框添加值改变事件
		$("#create-tranStage").change(function () {
			// 收集参数
			var id = this.value;
			// var value = $(this).find("option:selected").text();
			// var value = $("#create-tranStage option:selected").text();

			// 表单验证
			if(id === "") {
				$("#create-possibility").val("");
				return;
			}

			$.ajax({
				url: "workbench/tran/getPossibilityByStage.do",
				data: {
					id: id
				},
				type: "post",
				dataType: "json",
				success: function (data) {
					$("#create-possibility").val(data+"%");
				}
			});
		});

		// 客户名称支持自动补全
		$("#create-customerName").typeahead({
			source:function (request,response) {
				// 发送请求
				$.ajax({
					url: "workbench/tran/queryCustomerForSaveByName.do",
					data: {
						name: request
					},
					type: "post",
					dataType: "json",
					success: function (data) {
						response(data);
					}
				});
			}
		});
		
		// 给“保存”按钮添加点击事件
		$("#saveTranBtn").click(function () {
			// 收集参数
			var owner = $("#create-tranOwner").val();
			var money = $("#create-money").val();
			var name = $.trim($("#create-tranName").val());
			var expectedDate = $("#create-expectedDate").val();
			var customerName = $.trim($("#create-customerName").val());
			var stage = $("#create-tranStage").val();
			var type = $("#create-tranType").val();
			var source = $("#create-clueSource").val();
			var activityId = $("#create-activityId").val();
			var contactsId = $("#create-contactsId").val();
			var description = $.trim($("#create-description").val());
			var contactSummary = $.trim($("#create-contactSummary").val());
			var nextContactTime = $("#create-nextContactTime").val();

			// 表单验证
			if(name === "") {
				alert("名称不能为空");
				return;
			}

			if(customerName === "") {
				alert("客户名称不能为空");
				return;
			}

			if(expectedDate === "") {
				alert("预计成交日期不能为空");
				return;
			}

			if(stage === "") {
				alert("交易阶段不能为空");
				return;
			}

			var regExp=/^(([1-9]\d*)|0)$/;

			if(!regExp.test(money)) {
				alert("金额只能为非负数");
				return;
			}

			// 发送请求
			$.ajax({
				url: "workbench/tran/saveCreateTran.do",
				data: {
					owner: owner,
					money: money,
					name: name,
					expectedDate: expectedDate,
					customerName: customerName,
					stage: stage,
					type: type,
					source: source,
					activityId: activityId,
					contactsId: contactsId,
					description: description,
					contactSummary: contactSummary,
					nextContactTime: nextContactTime
				},
				type: "post",
				dataType: "json",
				success: function (data) {
					if(data.code === "1") {
						window.location.href = "workbench/tran/index.do";
					}else {
						alert(data.message);
					}
				}
			})
		});
	});

</script>
</head>
<body>

	<!-- 查找市场活动 -->	
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
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
					<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="activityTBody"></tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<!-- 查找联系人 -->	
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
							  <label>
								  <input id="searchContactsText" type="text" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
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
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="contactsTBody"></tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="saveTranBtn">保存</button>
			<a href="javascript:void(0);" onclick="window.history.back();"><button type="button" class="btn btn-default">取消</button></a>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="create-tranOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-tranOwner">
					<c:forEach items="${requestScope.userList}" var="user">
						<option value="${user.id}">${user.name}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-money" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-money">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-tranName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-tranName">
			</div>
			<label for="create-expectedDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-expectedDate" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-customerName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="create-customerId">
				<input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="create-tranStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="create-tranStage">
			  	<option></option>
				  <c:forEach items="${requestScope.stageList}" var="stage">
					  <option value="${stage.id}">${stage.value}</option>
				  </c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-tranType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-tranType">
				  <option></option>
					<c:forEach items="${requestScope.tranTypeList}" var="type">
						<option value="${type.id}">${type.value}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" id="searchContactsBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="create-contactsId">
				<input type="text" class="form-control" id="create-contactsName" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-clueSource">
				  <option></option>
					<c:forEach items="${requestScope.sourceList}" var="source">
						<option value="${source.id}">${source.value}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="searchActivityBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="create-activityId">
				<input type="text" class="form-control" id="create-activitySrc" readonly>
			</div>
		</div>

		<div class="form-group">
			<label for="create-possibility" class="col-sm-2 control-label">可能性&nbsp;&nbsp;</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-possibility" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-description" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-description"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-nextContactTime" readonly>
			</div>
		</div>
		
	</form>
</body>
</html>