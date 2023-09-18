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
<link href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet">

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-3.3.7/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.min.js"></script>

<script type="text/javascript">

	function queryClueByConditionForPage(pageNo,pageSize) {
		// 根据条件查询线索
		// 收集参数
		// 查询不需要去空格，不需要做表单验证
		var fullname = $("#query-fullname").val();
		var owner = $("#query-owner").val();
		var company = $("#query-company").val();
		var phone = $("#query-phone").val();
		var mphone = $("#query-mphone").val();
		var state = $("#query-state").val();
		var source = $("#query-source").val();
		// 模板字符串
		var template = "";

		// 列表
		var tBody = $("#tBody");

		$.ajax({
			url: "workbench/clue/queryClueByConditionForPage.do",
			data: {
				fullname: fullname,
				owner: owner,
				company: company,
				phone: phone,
				mphone: mphone,
				state: state,
				source: source,
				pageNo: pageNo,
				pageSize: pageSize
			},
			type: "post",
			dataType: "json",
			success: function (data) {
				// 显示线索的列表
				// 遍历 clueList，拼接所有行数据
				// 使用模板字符串
				$.each(data.clueList,function (index,obj) {
					var isActive = index % 2 === 0 ? "" : "active";

					template +=
							`<tr class=`+isActive+`>
									<td><label><input type="checkbox" value="`+obj.id+`"/></label></td>
									<td><a style="text-decoration: none; cursor: pointer;" onclick=window.location.href="workbench/clue/detailClue.do?id=`+obj.id+`";>`+obj.fullname+``+obj.appellation+`</a></td>
									<td>`+obj.company+`</td>
									<td>`+obj.phone+`</td>
									<td>`+obj.mphone+`</td>
									<td>`+obj.source+`</td>
									<td>`+obj.owner+`</td>
									<td>`+obj.state+`</td>
								</tr>`;
				});

				// 覆盖显示
				tBody.html(template);

				// 取消“全选”按钮的选中状态，列表生成后默认不选中状态
				$("#checkAll").prop("checked",false);

				// 计算总页数
				// Math.ceil 向上取整
				var totalPages = Math.ceil(data.totalRows/pageSize);

				// 调用 bs_pagination 工具函数显示翻页信息
				$("#bs_pagination").bs_pagination({
					// 当前页码
					currentPage: pageNo,

					// 每页显示的行数
					rowsPerPage: pageSize,
					// 总行数
					totalRows: data.totalRows,
					// 总页数
					totalPages: totalPages,

					// 可见的页码链接数量
					visiblePageLinks: 5,

					// 是否显示跳转到指定页码的输入框和按钮
					showGoToPage: true,
					// 是否显示跳转到指定页码的输入框和按钮
					showRowsPerPage: true,
					// 是否显示当前页行数信息
					showRowsInfo: true,

					// 当页码链接被点击时触发的回调函数 onChangePage
					// 每次返回切换页号之后的 pageNo 和 pageSize
					onChangePage: function (event, pageObj) {
						// js 代码
						queryClueByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage)
					}
				})
			},
			error: function () {
				alert("系统繁忙，请稍后重试......");
			}
		});
	}

	$(function() {
		// 给“创建”按钮添加点击事件
		$("#createClueBtn").click(function () {
			// 初始化表单
			$("#createClueForm").get(0).reset();

			// 弹出创建线索模态窗口
			$("#createClueModal").modal("show");
		});

		// 当线索主页面加载完成，查询所有数据的第一页以及所有数据的总条数
		queryClueByConditionForPage(1,10);

		$(".my-date").datetimepicker({
			format: "yyyy-mm-dd",
			minView: "month",
			initialDate: new Date(),
			language: "zh-CN",
			autoclose: true,
			todayBtn: true,
			clearBtn: true,
			pickerPosition: "top-right"
		});

		// 给“保存”按钮添加点击事件
		$("#saveCreateClueBtn").click(function () {
			// 收集参数
			// 参数比较多的情况下可以使用编辑列模式选择，navicat 复制列名，统一编写代码
			var fullname = $.trim($("#create-surname").val());
			var appellation = $("#create-call").val();
			var owner = $("#create-clueOwner").val();
			var company = $.trim($("#create-company").val());
			var job = $.trim($("#create-job").val());
			var email = $.trim($("#create-email").val());
			var phone = $.trim($("#create-phone").val());
			var website = $.trim($("#create-website").val());
			var mphone = $.trim($("#create-mphone").val());
			var state = $("#create-status").val();
			var source = $("#create-source").val();
			var description = $.trim($("#create-description").val());
			var contactSummary = $.trim($("#create-contactSummary").val());
			var nextContactTime = $("#create-nextContactTime").val();
			var address = $.trim($("#create-address").val());

			// 表单验证
			if (company === "") {
				alert("公司不为空");
				return;
			}

			if (fullname === "") {
				alert("姓名不为空");
				return;
			}

			// Email地址：^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$
			var emailRegExp = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;

			// 电话号码("XXX-XXXXXXX"、"XXXX-XXXXXXXX"、"XXX-XXXXXXX"、"XXX-XXXXXXXX"、"XXXXXXX"和"XXXXXXXX)：^(\(\d{3,4}-)|\d{3.4}-)?\d{7,8}$
			var telRegExp = /^(\(\d{3,4}-)?\d{7,8}$/;

			// InternetURL：[a-zA-z]+://[^\s]* 或 ^(https?:\/\/)?([\w-]+\.)+[\w-]+(\/[\w-./?%&=]*)?$
			// 添加 i 选项以表示大小写不敏感匹配
			var urlRegExp = /^(https?:\/\/)?([\w-]+\.)+[\w-]+(\/[\w-./?%&=]*)?$/i;

			// 手机号码：^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$
			var phRegExp = /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/;

			if (email !== "") {
				if (!emailRegExp.test(email)) {
					alert("邮箱格式不正确");
					return;
				}
			}

			if (phone !== "") {
				if (!telRegExp.test(phone)) {
					alert("公司座机号码格式不正确");
					return;
				}
			}

			if (mphone !== "") {
				if (!phRegExp.test(mphone)) {
					alert("手机号码格式不正确");
					return;
				}
			}

			if (website !== "") {
				if (!urlRegExp.test(website)) {
					alert("公司网站格式不正确");
					return;
				}
			}

			// 发送请求
			$.ajax({
				url: "workbench/clue/saveCreateClue.do",
				data: {
					fullname: fullname,
					appellation: appellation,
					owner: owner,
					company: company,
					job: job,
					email: email,
					phone: phone,
					website: website,
					mphone: mphone,
					state: state,
					source: source,
					description: description,
					contactSummary: contactSummary,
					nextContactTime: nextContactTime,
					address: address
				},
				type: "post",
				dataType: "json",
				success: function (data) {
					if (data.code === "1") {
						// 关闭模态窗口
						$("#createClueModal").modal("hide");

						// 刷新线索列表，显示第一页数据，保持每一页显示条数不变
						queryClueByConditionForPage(1,$("#bs_pagination").bs_pagination("getOption", "rowsPerPage"));

					} else {
						// 提示信息
						alert(data.message);

						// 模态窗口不关闭
						$("#createClueModal").modal("show");
					}
				}
			});
		});

		// 给“查询”按钮添加点击事件
		$("#queryClueCoditionBtn").click(function () {
			// 查询所有符合条件数据的第一页以及所有符合条件数据的总条数
			// getOption 可以获取指定参数的数据
			queryClueByConditionForPage(1,$("#bs_pagination").bs_pagination("getOption", "rowsPerPage"));
		});

		// 给“全选”按钮添加点击事件
		$("#checkAll").click(function () {
			// 如果“全选”按钮是选中状态，则列表中所有 checkbox 都选中
			// this 代表当前事件的 dom 对象
			$("#tBody input[type = 'checkbox']").prop("checked",this.checked);
		});

		// 使用 jQuery 对象逻辑不生效，采用使用 jquery 的 on 函数
		$("#tBody").on("click","input[type = 'checkbox']",function () {
			// 如果列表中所有的 checkbox 都选中，则“全选”按钮也选中
			if($("#tBody input[type = 'checkbox']").size() === $("#tBody input[type = 'checkbox']:checked").size()) {
				$("#checkAll").prop("checked",true);
			}else {
				// 如果列表中所有 checkbox 至少有一个没选中，则“全选”取消选中
				$("#checkAll").prop("checked",false);
			}
		});

		// 给“删除”按钮添加点击事件
		$("#deleteClueBtn").click(function () {
			// 收集参数
			var checkedIds = $("#tBody input[type = 'checkbox']:checked");

			// 0 选中
			if(checkedIds.size() === 0) {
				alert("请选择需要删除的线索");
				return;
			}

			if(window.confirm("确定删除吗？")) {
				// 遍历数组
				// JSTL 提供的 c:forEach 标签，可用于循环遍历集合，但是要遍历的数组不在作用域
				// JSP EL 可以在 JSP 页面中通过表达式操作 JavaBean 的属性。虽然 EL 通常用于访问对象的属性，但也可以在某种程度上用于遍历数组
				// JSTL 需要结合 EL(Expression Language) 一起使用
				// 使用 jQuery.each 遍历，jQuery 本身就是 js 代码
				var ids = "";

				$.each(checkedIds, function () {
					ids += `id=` + this.value + `&`;
				});

				// 数组用 .size()，字符串用 .length，删除拼接字符串的多余的“&”
				ids = ids.substring(0, ids.length - 1);

				$.ajax({
					url: "workbench/clue/deleteClueByIds.do",
					// data 数据格式有多种可以采用
					// URL 查询字符串的常见表示方式
					// data:k1=v1&k2=v2&....
					// data 虽然写的是 ids，但是传入后端的参数的键是 id
					data: ids,
					type: "post",
					dataType: "json",
					success: function (data) {
						if (data.code === "1") {
							// 刷新线索列表，显示第一页数据，保持每一页显示条数不变
							queryClueByConditionForPage(1, $("#bs_pagination").bs_pagination("getOption", "rowsPerPage"));
						} else {
							// 提示信息
							alert(data.message);
						}
					}
				});
			}
		});

		// 给“修改”按钮添加点击事件
		$("#editClueBtn").click(function () {
			// 添加点击事件，替代 toggle 打开模态窗口
			// 初始化工作
			// 编写 js 代码
			$("#editClueForm").get(0).reset();

			// 收集参数
			// 获取列表中被选中的 checkbox
			var checkedIds = $("#tBody input[type = 'checkbox']:checked");

			// 0 选中
			if(checkedIds.size() === 0) {
				alert("请选择需要修改的线索");
				return;
			}
			if(checkedIds.size()>1) {
				alert("每次只能修改一条线索");
				return;
			}

			// 获取 dom 对象里的参数
			var id = checkedIds.get(0).value;

			// 发送请求
			$.ajax({
				url: "workbench/clue/selectClueById.do",
				data: {
					id: id
				},
				type: "post",
				dataType: "json",
				success: function (data) {
					$("#edit-id").val(data.id),
					$("#edit-clueOwner").val(data.owner),
					$("#edit-company").val(data.company),
					$("#edit-call").val(data.appellation),
					$("#edit-surname").val(data.fullname),
					$("#edit-job").val(data.job),
					$("#edit-email").val(data.email),
					$("#edit-phone").val(data.phone),
					$("#edit-website").val(data.website),
					$("#edit-mphone").val(data.mphone),
					$("#edit-status").val(data.state),
					$("#edit-source").val(data.source),
					$("#edit-description").val(data.description),
					$("#edit-contactSummary").val(data.contactSummary),
					$("#edit-nextContactTime").val(data.nextContactTime),
					$("#edit-address").val(data.address)
				}
			});

			// 弹出修改市场活动的模态窗口
			$("#editClueModal").modal("show");
		});

		// 给“更新”按钮添加点击事件
		$("#updateClueBtn").click(function () {
			// 收集参数
			// 参数比较多的情况下可以使用编辑列模式选择，navicat 复制列名，统一编写代码
			var id = $("#edit-id").val();
			var fullname = $.trim($("#edit-surname").val());
			var appellation = $("#edit-call").val();
			var owner = $("#edit-clueOwner").val();
			var company = $.trim($("#edit-company").val());
			var job = $.trim($("#edit-job").val());
			var email = $.trim($("#edit-email").val());
			var phone = $.trim($("#edit-phone").val());
			var website = $.trim($("#edit-website").val());
			var mphone = $.trim($("#edit-mphone").val());
			var state = $("#edit-status").val();
			var source = $("#edit-source").val();
			var description = $.trim($("#edit-description").val());
			var contactSummary = $.trim($("#edit-contactSummary").val());
			var nextContactTime = $("#edit-nextContactTime").val();
			var address = $.trim($("#edit-address").val());

			// 表单验证
			if (company === "") {
				alert("公司不为空");
				return;
			}

			if (fullname === "") {
				alert("姓名不为空");
				return;
			}

			// Email地址：^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$
			var emailRegExp = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;

			// 电话号码("XXX-XXXXXXX"、"XXXX-XXXXXXXX"、"XXX-XXXXXXX"、"XXX-XXXXXXXX"、"XXXXXXX"和"XXXXXXXX)：^(\(\d{3,4}-)|\d{3.4}-)?\d{7,8}$
			var telRegExp = /^(\(\d{3,4}-)?\d{7,8}$/;

			// InternetURL：[a-zA-z]+://[^\s]* 或 ^(https?:\/\/)?([\w-]+\.)+[\w-]+(\/[\w-./?%&=]*)?$
			// 添加 i 选项以表示大小写不敏感匹配
			var urlRegExp = /^(https?:\/\/)?([\w-]+\.)+[\w-]+(\/[\w-./?%&=]*)?$/i;

			// 手机号码：^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$
			var phRegExp = /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/;

			if (email !== "") {
				if (!emailRegExp.test(email)) {
					alert("邮箱格式不正确");
					return;
				}
			}

			if (phone !== "") {
				if (!telRegExp.test(phone)) {
					alert("公司座机号码格式不正确");
					return;
				}
			}

			if (mphone !== "") {
				if (!phRegExp.test(mphone)) {
					alert("手机号码格式不正确");
					return;
				}
			}

			if (website !== "") {
				if (!urlRegExp.test(website)) {
					alert("公司网站格式不正确");
					return;
				}
			}

			// 缓存选择器结果
			var bs_pagination = $("#bs_pagination");

			// 发送请求
			$.ajax({
				url: "workbench/clue/saveEditClue.do",
				data: {
					id: id,
					fullname: fullname,
					appellation: appellation,
					owner: owner,
					company: company,
					job: job,
					email: email,
					phone: phone,
					website: website,
					mphone: mphone,
					state: state,
					source: source,
					description: description,
					contactSummary: contactSummary,
					nextContactTime: nextContactTime,
					address: address
				},
				type: "post",
				dataType: "json",
				success: function (data) {
					if(data.code === "1") {
						// 关闭模态窗口
						$("#editClueModal").modal("hide");

						// 刷新线索列表，显示第当前页数据，保持每一页显示条数不变
						queryClueByConditionForPage(bs_pagination.bs_pagination("getOption", "currentPage"),bs_pagination.bs_pagination("getOption", "rowsPerPage"));

					}else {
						// 提示信息
						alert(data.message);

						// 模态窗口不关闭
						$("#editClueModal").modal("show");
					}
				}
			})
		});
	});
</script>
</head>
<body>

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="createClueForm">
					
						<div class="form-group">
							<label for="create-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-clueOwner">
									<!-- 遍历 userList 循环变量 u -->
									<!-- 使用 c:set 标签来设置 JavaBean 对象的属性 -->
									<c:set var="userList" value="${requestScope.userList}" />
									<c:forEach items="${userList}" var="u">
										<option value="${u.id}">${u.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-call">
									<option></option>
									<c:set var="appellationList" value="${requestScope.appellationList}" />
									<c:forEach items="${appellationList}" var="app">
										<option value="${app.id}">${app.value}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-surname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-status">
									<option></option>
									<c:set var="clueStateList" value="${requestScope.clueStateList}" />
									<c:forEach items="${clueStateList}" var="cs">
										<option value="${cs.id}">${cs.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  	<option></option>
									<c:set var="sourceList" value="${requestScope.sourceList}" />
									<c:forEach items="${sourceList}" var="s">
										<option value="${s.id}">${s.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control my-date" id="create-nextContactTime" readonly>
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveCreateClueBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="editClueForm">

						<!-- 增加一个隐藏域，用于保存 id -->
						<input type="hidden" id="edit-id">
					
						<div class="form-group">
							<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueOwner">
									<c:set var="userList" value="${requestScope.userList}" />
									<c:forEach items="${userList}" var="u">
										<option value="${u.id}">${u.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company" value="">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-call">
								  	<option></option>
									<c:set var="appellationList" value="${requestScope.appellationList}" />
									<c:forEach items="${appellationList}" var="app">
										<option value="${app.id}">${app.value}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-surname" value="">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" value="">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="">
							</div>
							<label for="edit-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-status">
								  <option></option>
									<c:set var="clueStateList" value="${requestScope.clueStateList}" />
									<c:forEach items="${clueStateList}" var="cs">
										<option value="${cs.id}">${cs.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <option></option>
									<c:set var="sourceList" value="${requestScope.sourceList}" />
									<c:forEach items="${sourceList}" var="s">
										<option value="${s.id}">${s.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control my-date" id="edit-nextContactTime" value="" readonly>
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateClueBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
						<label for="query-fullname"></label><input class="form-control" type="text" id="query-fullname">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
						<label for="query-company"></label><input class="form-control" type="text" id="query-company">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
						<label for="query-phone"></label><input class="form-control" type="text" id="query-phone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select class="form-control" id="query-source">
					  	  <option></option>
						  <c:set var="sourceList" value="${requestScope.sourceList}" />
						  <c:forEach items="${sourceList}" var="s">
							  <option value="${s.id}">${s.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
						<label for="query-owner"></label><input class="form-control" type="text" id="query-owner">
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
						<label for="query-mphone"></label><input class="form-control" type="text" id="query-mphone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select class="form-control" id="query-state">
					  	<option></option>
						  <c:set var="clueStateList" value="${requestScope.clueStateList}" />
						  <c:forEach items="${clueStateList}" var="cs">
							  <option value="${cs.id}">${cs.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>

					<!-- 不采用 submit，采用异步请求 -->
				  <button type="button" class="btn btn-default" id="queryClueCoditionBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createClueBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editClueBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteClueBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><label for="checkAll"></label><input type="checkbox" id="checkAll"/></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="tBody"></tbody>
				</table>
				<!-- 分页插件 -->
				<div id="bs_pagination"></div>
			</div>
		</div>
	</div>
</body>
</html>