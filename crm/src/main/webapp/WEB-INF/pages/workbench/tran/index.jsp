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

	function queryTranByConditionForPage(pageNo,pageSize) {
		// 收集参数
		// 查询不需要去空格，不需要做表单验证，查询参数不合规自然查询不到数据
		var name = $("#query-name").val();
		var owner = $("#query-owner").val();
		var customerId = $("#query-customerName").val();
		var contactsId = $("#query-contactsName").val();
		var stage = $("#query-stage").val();
		var type = $("#query-type").val();
		var source = $("#query-source").val();

		// 缓存选择器结果
		var tBody = $("#tBody");

		// 用于模板字符串
		var template = "";

		// 发送请求
		$.ajax({
			url: "workbench/tran/queryTranByConditionForPage.do",
			data: {
				name: name,
				owner: owner,
				customerId: customerId,
				stage: stage,
				type: type,
				source: source,
				contactsId: contactsId,
				pageNo: pageNo,
				pageSize: pageSize
			},
			type: "post",
			dataType: "json",
			success: function (data) {
				$.each(data.tranList,function (index,obj) {
					// 根据索引来选择是否选中显示
					var isActive = index % 2 === 0 ? "" : "active";

					template +=
						`<tr class=`+isActive+`>
                            <td><input type="checkbox" value="`+obj.id+`"/></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick=window.location.href="workbench/tran/detailTran.do?id=`+obj.id+`";>`+obj.customerId+`-`+obj.name+`</a></td>
                            <td>`+obj.customerId+`</td>
                            <td>`+obj.stage+`</td>
                            <td>`+obj.type+`</td>
                            <td>`+obj.owner+`</td>
                            <td>`+obj.source+`</td>
                            <td>`+obj.contactsId+`</td>
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
		$("#createTranBtn").click(function () {
			window.location.href = "workbench/tran/toSave.do";
		});

		queryTranByConditionForPage(1,10);

		// 给“查询”按钮添加点击事件
		$("#queryTranBtn").click(function () {
			// 查询所有符合条件数据的第一页以及所有符合条件数据的总条数
			// getOption 可以获取指定参数的数据
			queryTranByConditionForPage(1,$("#bs_pagination").bs_pagination("getOption", "rowsPerPage"));
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

	});
	
</script>
	<title>交易界面</title>
</head>
<body>

	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>交易列表</h3>
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
				      <input class="form-control" type="text" id="query-owner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="query-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input class="form-control" type="text" id="query-customerName">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">阶段</div>
					  <select class="form-control" id="query-stage">
					  	<option></option>
					    <c:forEach items="${requestScope.stageList}" var="stage">
							<option value="${stage.id}">${stage.value}</option>
						</c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">类型</div>
					  <select class="form-control" id="query-type">
					  	<option></option>
						  <c:forEach items="${requestScope.tranTypeList}" var="type">
							  <option value="${type.id}">${type.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="query-source">
						  <option></option>
						  <c:forEach items="${requestScope.sourceList}" var="source">
							  <option value="${source.id}">${source.value}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人名称</div>
				      <input class="form-control" type="text" id="query-contactsName">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="queryTranBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createTranBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" onclick="window.location.href='edit.html';"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAll"/></td>
							<td>名称</td>
							<td>客户名称</td>
							<td>阶段</td>
							<td>类型</td>
							<td>所有者</td>
							<td>来源</td>
							<td>联系人名称</td>
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