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
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.min.js"></script>
<script type="text/javascript" src="jquery/jquery-ui-1.12.1.js"></script>

<script type="text/javascript">

	function queryContactsByConditionForPage(pageNo,pageSize) {
		// 收集参数
		// 查询不需要去空格，不需要做表单验证，查询参数不合规自然查询不到数据
		var fullname = $("#query-fullname").val();
		var owner = $("#query-owner").val();
		var customerId = $("#query-customerId").val();
		var source = $("#query-source").val();

		// 缓存选择器结果
		var tBody = $("#tBody");

		// 用于模板字符串
		var template = "";

		// 发送请求
		$.ajax({
			url: "workbench/contacts/queryContactsByConditionForPage.do",
			data: {
				name: name,
				owner: owner,
				customerId: customerId,
				source: source,
				pageNo: pageNo,
				pageSize: pageSize
			},
			type: "post",
			dataType: "json",
			success: function (data) {
				$.each(data.contactsList,function (index,obj) {
					// 根据索引来选择是否选中显示
					var isActive = index % 2 === 0 ? "" : "active";

					template +=
							`<tr class=`+isActive+`>
							<td><label><input type="checkbox" value="`+obj.id+`" /></label></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick=window.location.href="workbench/contacts/detailContacts.do?id=`+obj.id+`";>`+obj.fullname+`</a></td>
							<td>`+obj.customerId+`</td>
							<td>`+obj.owner+`</td>
							<td>`+obj.source+`</td>
						</tr>`;


				});

				// 在指定的标签中显示jsp页面片段：选择器.html(jsp页面片段的字符串); //覆盖显示
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
						queryCustomerByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage)
					}
				})
			},
			error: function () {
				alert("系统繁忙，请稍后重试......");
			}
		});
	}

	$(function(){
		
		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });

		queryContactsByConditionForPage(1,10);

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

		// 给“查询”按钮添加点击事件
		$("#queryContactsBtn").click(function () {
			// 查询所有符合条件数据的第一页以及所有符合条件数据的总条数
			// getOption 可以获取指定参数的数据
			queryContactsByConditionForPage(1,$("#bs_pagination").bs_pagination("getOption", "rowsPerPage"));
		});

		// 给“全选”按钮添加点击事件
		$("#checkAll").click(function () {
			$("#tBody input[type = 'checkbox']").prop("checked",this.checked);
		});

		// 获取一个 jQuery 对象
		// jQuery 只能给固有元素添加事件，模板字符串里的 checkbox 均为动态生成的元素
		// 实现全选与取消全选逻辑
		$("#tBody input[type = 'checkbox']").click(function () {
			// 如果列表中所有的 checkbox 都选中，则“全选”按钮也选中
			if($("#tBody input[type = 'checkbox']").size() === $("#tBody input[type = 'checkbox']:checked").size()) {
				$("#checkAll").prop("checked",true);
			}else {
				// 如果列表中所有 checkbox 至少有一个没选中，则“全选”取消选中
				$("#checkAll").prop("checked",false);
			}
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

		var suggestions = $("#suggestions");
		suggestions.hide();

		suggestions.on("mouseover",".myHref",function () {
			$(this).children("li").css("color","red");
		});

		suggestions.on("mouseout",".myHref",function () {
			$(this).children("li").css("color","#E6E6E6");
		});

		// 搜索框实现自动补全功能
		$("#create-customerName").autocomplete({
			source: function (request,response) {
				$.ajax({
					url: "workbench/contacts/queryCustomerByName.do",
					data: {
						name: request.term
					},
					type: "post",
					dataType: "json",
					success: function (data) {

						var template = "";

						response($.map(data,function (item) {
							template +=
								`<div class="myHref">
									<li class="suggestion-li" data-id="`+item.id+`" style="color: #E6E6E6">`+item.name+`</li>
								</div>`;
						}));

						if(template !== "") {
							suggestions.html("");
							suggestions.html(template);
							suggestions.show();
						}else {
							suggestions.html("");
							suggestions.hide();
						}

						// 添加点击事件处理程序
						$(".suggestion-li").click(function () {
							// 获取被点击的 span 的文本内容
							var customerName = $(this).text();
							// 获取关联的数据 Id
							var customerId = $(this).data("id");

							// 将选定的内容设置为搜索框的值
							$("#create-customerName").val(customerName);
							$("#create-customerId").val(customerId);

							// 隐藏建议框
							$("#suggestions").hide();
						});
					}
				});
			}
		});

		// 给“创建”按钮添加点击事件
		$("#createContactsBtn").click(function () {
			// 初始化模态窗口表格
			$("#createContactsForm").get(0).reset();

			// 弹出创建联系人的模态窗口
			$("#createContactsModal").modal("show");
		});

		// 给“保存”按钮添加点击事件
		$("#saveContactsBtn").click(function () {
			// 收集参数
			var owner = $("#create-contactsOwner").val();
			var source = $("#create-clueSource").val();
			var customerId = $("#create-customerId").val();
			var customerName = $.trim($("#create-customerName").val());
			var fullname = $.trim($("#create-surname").val());
			var appellation = $("#create-call").val();
			var email = $.trim($("#create-email").val());
			var mphone = $.trim($("#create-mphone").val());
			var job = $.trim($("#create-job").val());
			var description = $.trim($("#create-description").val());
			var contactSummary = $.trim($("#create-contactSummary").val());
			var nextContactTime = $("#create-nextContactTime").val();
			var address = $.trim($("#create-address").val());

			// 表单验证
			if (fullname === "") {
				alert("姓名不为空");
				return;
			}

			// Email地址：^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$
			var emailRegExp = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;

			// 手机号码：^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$
			var phRegExp = /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/;

			if (email !== "") {
				if (!emailRegExp.test(email)) {
					alert("邮箱格式不正确");
					return;
				}
			}

			if (mphone !== "") {
				if (!phRegExp.test(mphone)) {
					alert("手机号码格式不正确");
					return;
				}
			}

			// 发送请求
			$.ajax({
				url: "workbench/contacts/saveCreateContacts.do",
				data: {
					owner: owner,
					source: source,
					customerId: customerId,
					customerName: customerName,
					fullname: fullname,
					appellation: appellation,
					email: email,
					mphone: mphone,
					job: job,
					description: description,
					contactSummary: contactSummary,
					nextContactTime: nextContactTime,
					address: address
				},
				type: "post",
				dataType: "json",
				success: function (data) {
					if(data.code === "1") {
						// 刷新联系人界面
						queryContactsByConditionForPage(1,$("#bs_pagination").bs_pagination("getOption", "rowsPerPage"));

						// 关闭模态窗口
						$("#createContactsModal").modal("hide");
					}else {
						alert(data.message);
					}
				}
			});
		});
	});
	
</script>
		<title>联系人界面</title>
</head>
<body>

	
	<!-- 创建联系人的模态窗口 -->
	<div class="modal fade" id="createContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabelx">创建联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="createContactsForm">
					
						<div class="form-group">
							<label for="create-contactsOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-contactsOwner">
									<c:forEach items="${requestScope.userList}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-clueSource">
								  <option></option>
								  <c:forEach items="${requestScope.sourceList}" var="source">
									  <option value="${source.id}">${source.value}</option>
								  </c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-surname">
							</div>
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-call">
								  <option></option>
									<c:forEach items="${requestScope.appellationList}" var="appellation">
										<option value="${appellation.id}">${appellation.value}</option>
									</c:forEach>
								</select>
							</div>
							
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
							<label for="create-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="hidden" id="create-customerId">
								<input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">
								<ul id="suggestions" style="position: absolute; border: grey 1px solid; background-color: white; max-height: 400px; overflow-y: auto; z-index: 999; width: 270px"></ul>
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
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
									<input type="text" class="my-date form-control" id="create-nextContactTime" readonly>
								</div>
							</div>
						</div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
									<label for="create-address"></label><textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveContactsBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改联系人的模态窗口 -->
	<div class="modal fade" id="editContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">修改联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-contactsOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-contactsOwner">
								  <option selected>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>
								</select>
							</div>
							<label for="edit-clueSource1" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueSource1">
								  <option></option>
									<c:forEach items="${requestScope.sourceList}" var="source">
										<option value="${source.id}">${source.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-surname" value="李四">
							</div>
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-call">
								  <option></option>
								  <option selected>先生</option>
								  <option>夫人</option>
								  <option>女士</option>
								  <option>博士</option>
								  <option>教授</option>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
							<label for="edit-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-customerName" placeholder="支持自动补全，输入客户不存在则新建" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-desctiption" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-desctiption">这是一条线索的描述信息</textarea>
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
									<input type="text" class="form-control" id="edit-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address2" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address2">北京大兴区大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>联系人列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
						<label>
							<input class="form-control" type="text" id="query-owner">
						</label>
					</div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">姓名</div>
						<label>
							<input class="form-control" type="text" id="query-fullname">
						</label>
					</div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
						<label>
							<input class="form-control" type="text" id="query-customerId">
						</label>
					</div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
						<label for="query-source"></label><select class="form-control" id="query-source">
						  <option></option>
						  <c:forEach items="${requestScope.sourceList}" var="source">
							  <option value="${source.id}">${source.value}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="queryContactsBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createContactsBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" data-toggle="modal" data-target="#editContactsModal"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 20px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><label>
								<input type="checkbox" id="checkAll"/>
							</label></td>
							<td>姓名</td>
							<td>客户名称</td>
							<td>所有者</td>
							<td>来源</td>
						</tr>
					</thead>
					<tbody id="tBody"></tbody>
				</table>
				<div id="bs_pagination"></div>
			</div>
		</div>
	</div>
</body>
</html>