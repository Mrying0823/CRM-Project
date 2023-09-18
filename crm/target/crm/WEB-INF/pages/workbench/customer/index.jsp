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

<script type="text/javascript">

	function queryCustomerByConditionForPage(pageNo,pageSize) {
		// 收集参数
		// 查询不需要去空格，不需要做表单验证，查询参数不合规自然查询不到数据
		var name = $("#query-name").val();
		var owner = $("#query-owner").val();
		var phone = $("#query-phone").val();
		var website = $("#query-website").val();

		// 缓存选择器结果
		var tBody = $("#tBody");

		// 用于模板字符串
		var template = "";

		// 发送请求
		$.ajax({
			url: "workbench/customer/queryCustomerByConditionForPage.do",
			data: {
				name: name,
				owner: owner,
				phone: phone,
				website: website,
				pageNo: pageNo,
				pageSize: pageSize
			},
			type: "post",
			dataType: "json",
			success: function (data) {
				$.each(data.customerList,function (index,obj) {
					// 根据索引来选择是否选中显示
					var isActive = index % 2 === 0 ? "" : "active";

					template +=
						`<tr class=`+isActive+`>
							<td><label><input type="checkbox" value="`+obj.id+`" /></label></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick=window.location.href="workbench/customer/detailCustomer.do?id=`+obj.id+`";>`+obj.name+`</a></td>
							<td>`+obj.owner+`</td>
							<td>`+obj.phone+`</td>
							<td>`+obj.website+`</td>
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

		queryCustomerByConditionForPage(1,10);

		// 给“查询”按钮添加点击事件
		$("#queryCustomerBtn").click(function () {
			// 查询所有符合条件数据的第一页以及所有符合条件数据的总条数
			// getOption 可以获取指定参数的数据
			queryCustomerByConditionForPage(1,$("#bs_pagination").bs_pagination("getOption", "rowsPerPage"));
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
	<title>客户界面</title>
</head>
<body>

	<!-- 创建客户的模态窗口 -->
	<div class="modal fade" id="createCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-customerOwner">
								  <option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>
								</select>
							</div>
							<label for="create-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-customerName">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-website">
                            </div>
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
						</div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
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
                                    <input type="text" class="form-control" id="create-nextContactTime">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address1" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address1"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改客户的模态窗口 -->
	<div class="modal fade" id="editCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-customerOwner">
								  <option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>
								</select>
							</div>
							<label for="edit-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-customerName" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
                            </div>
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="create-contactSummary1" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="create-contactSummary1"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="create-nextContactTime2" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control" id="create-nextContactTime2">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address">北京大兴大族企业湾</textarea>
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
				<h3>客户列表</h3>
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
						<label for="query-name"></label><input class="form-control" type="text" id="query-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
						<label for="query-owner"></label><input class="form-control" type="text" id="query-owner">
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
				      <div class="input-group-addon">公司网站</div>
						<label for="query-website"></label><input class="form-control" type="text" id="query-website">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="queryCustomerBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#createCustomerModal"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" data-toggle="modal" data-target="#editCustomerModal"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><label>
								<input type="checkbox" id="checkAll"/>
							</label></td>
							<td>名称</td>
							<td>所有者</td>
							<td>公司座机</td>
							<td>公司网站</td>
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