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
<!-- 注意引入顺序 -->
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-3.3.7/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.min.js"></script>

<script type="text/javascript">

	function queryActivityByConditionForPage(pageNo,pageSize) {
		// 收集参数
		// 查询不需要去空格，不需要做表单验证，查询参数不合规自然查询不到数据
		var name = $("#query-name").val();
		var owner = $("#query-owner").val();
		var startDate = $("#query-startDate").val();
		var endDate = $("#query-endDate").val();

		// 缓存选择器结果
		var tBody = $("#tBody");

/*		var pageNo = 1;
		// 默认每页显示 10 条数据
		var pageSize = 10;*/

		// 用于模板字符串
		var template = "";

		// 发送请求
		$.ajax({
			url: "workbench/activity/queryActivityByConditionForPage.do",
			data: {
				name: name,
				owner: owner,
				startDate: startDate,
				endDate: endDate,
				pageNo: pageNo,
				pageSize: pageSize
			},
			type: "post",
			dataType: "json",
			success: function (data) {

				// B 表示 b 标签，b 标签用于字体的加粗
				// $("#totalRowsB").text(data.totalRows);

				// 显示市场活动的列表
				// 遍历 activityList，拼接所有行数据
				// 定义一个大字符串 var htmlStr = "";
				// 使用模板字符串
				$.each(data.activityList,function (index,obj) {
					// 根据索引来选择是否选中显示
					var isActive = index % 2 === 0 ? "" : "active";

					template +=
							`<tr class=`+isActive+`>
							<td><label><input type="checkbox" value="`+obj.id+`" /></label></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick=window.location.href="workbench/activity/detailActivity.do?id=`+obj.id+`";>`+obj.name+`</a></td>
							<td>`+obj.owner+`</td>
							<td>`+obj.startDate+`</td>
							<td>`+obj.endDate+`</td>
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
                        queryActivityByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage)
                    }
				})
			},
			error: function () {
				alert("系统繁忙，请稍后重试......");
			}
		})
	}

	$(function(){

		// 给“创建”按钮添加点击事件
		$("#createActivityBtn").click(function () {
			// 添加点击事件，替代 toggle 打开模态窗口
			// 初始化工作
			// 编写 js 代码
			// $("#createActivityForm")[0].reset(); 两种初始方式
			$("#createActivityForm").get(0).reset();

			// 弹出创建市场活动的模态窗口
			$("#createActivityModal").modal("show");
		});

		// 给“保存”按钮添加点击事件
		$("#saveCreateActivityBtn").click(function () {
			// 收集参数
			var owner=$("#create-marketActivityOwner").val();
			var name=$("#create-marketActivityName").val();

			// 日期要自动生成
			var startDate=$("#create-startDate").val();
			var endDate=$("#create-endDate").val();

			var cost=$.trim($("#create-cost").val());
			var description=$.trim($("#create-description").val());

			// 表单验证
			if(owner === "") {
				alert("所有者不能为空");
				return;
			}

			if(name === "") {
				alert("名称不能为空");
				return;
			}

			if(startDate !== "" && endDate !== "") {
				// 使用字符串的大小代替日期的大小
				if(endDate < startDate) {
					alert("结束日期不能小于开始日期");
					return;
				}
			}

			/*
				正则表达式：
					1、语言、语法：定义字符串的匹配模式，可以用来判断指定的具体字符串是否符号匹配模式
					2、语法通则：
						1) //：在 js 中定义一个正则表达式，var regExp=/....../;
						2) ^：匹配字符串的开头位置
						   $：匹配字符串的结尾
						3) []：匹配指定字符串中的一位字符，var regExp=/[abc]/;
													 var regExp=/^[a-z0-9]$/;
						4) {}：匹配次数.var regExp=/^[abc]{5}$/;
							   {m}：匹配 m 次
							   {m,n}：匹配 m 次到 n 次
							   {m,}：匹配 m 次或者更多次
						5) 特殊符号：
							\d：匹配一位数字，相当于 [0-9]
							\D：匹配一位非数字
							\w：匹配所有字符，包括字母、数字、下划线
							\W：匹配非字符、除了字母、数字、下划线之外的字符

							*：匹配 0 次或者多次，相当于 {0,}
							+：匹配 1 次或者多次，相当于 {1,}
							？：匹配 0 次或者 1 次，相当于 {0,1}
			 */

			/**
			 * 从外至内一一分析每个符号的意义
			 * "/....../" 在 js 中定义一个正则表达式
			 * "^" 匹配字符串的开头位置
			 * "[1-9]\d*" 匹配 0 次或多次 1-9 中的一位数字（匹配非 0 正整数）
			 * "|0" 或者匹配 0
			 * "$" 匹配字符串的结尾
			 * 非负整数：^(([1-9]\d*)|0)$
			 * @type {RegExp}
			 */
			var regExp=/^(([1-9]\d*)|0)$/;

			if(!regExp.test(cost)) {
				alert("成本只能为非负数");
				return;
			}

			// 发送请求
			$.ajax({
				url: "workbench/activity/saveCreateActivity.do",
				data: {
					owner: owner,
					name: name,
					startDate: startDate,
					endDate: endDate,
					cost: cost,
					description: description
				},
				type: "post",
				dataType: "json",
				success: function (data) {
					if(data.code === "1") {
						// 关闭模态窗口
						$("#createActivityModal").modal("hide");

						// 刷新市场活动列表，显示第一页数据，保持每一页显示条数不变
						queryActivityByConditionForPage(1,$("#bs_pagination").bs_pagination("getOption", "rowsPerPage"));

					}else {
						// 提示信息
						alert(data.message);

						// 模态窗口不关闭
						$("#createActivityModal").modal("show");
					}
				}
			});
		});

		// 当市场活动主页面加载完成，查询所有数据的第一页以及所有数据的总条数
		queryActivityByConditionForPage(1,10);

		// 当容器加载完成，对容器调用工具函数
		// 使用 jQuery 的属性过滤器，选择具有特定属性的输入框
		// $("input[name="my-date"]").datetimepicker({}) name 属性需要手动加入
		// 使用类选择器
		// 初始化 datetimepicker 必须在 queryActivityByConditionForPage 之后，否则会出现显示问题，不知道是何原因出现的冲突
		$(".my-date").datetimepicker({
			format: "yyyy-mm-dd",
			minView: "month",
			initialDate: new Date(),
			language: "zh-CN",
			autoclose: true,
			todayBtn: true,
			clearBtn: true
		});

		// 给“查询”按钮添加点击事件
		$("#queryActivityBtn").click(function () {
			// 查询所有符合条件数据的第一页以及所有符合条件数据的总条数
			// getOption 可以获取指定参数的数据
			queryActivityByConditionForPage(1,$("#bs_pagination").bs_pagination("getOption", "rowsPerPage"));
		});

        // 给“全选”按钮添加点击事件
        $("#checkAll").click(function () {
            // 如果“全选”按钮是选中状态，则列表中所有 checkbox 都选中
            // this 代表当前事件的 dom 对象
/*            if(this.checked) {
                // “>”某一标签下的一级标签，直接子标签
                // “ ”空格可以获取某一标签下的所有子标签
                $("#tBody input[type = 'checkbox']").prop("checked",true);
            }else {
                $("#tBody input[type = 'checkbox']").prop("checked",false);
            }*/

            // 以上代码可以简略
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

		// 给“删除”按钮添加点击事件
        $("#deleteActivityBtn").click(function () {
            // 收集参数
            var checkedIds = $("#tBody input[type = 'checkbox']:checked");

			// 0 选中
			if(checkedIds.size() === 0) {
				alert("请选择需要删除的市场活动");
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
					url: "workbench/activity/deleteActivityByIds.do",
					// data 数据格式有多种可以采用
					// URL 查询字符串的常见表示方式
					// data:k1=v1&k2=v2&....
					// data 虽然写的是 ids，但是传入后端的参数的键是 id
					data: ids,
					type: "post",
					dataType: "json",
					success: function (data) {
						if (data.code === "1") {
							// 刷新市场活动列表，显示第一页数据，保持每一页显示条数不变
							queryActivityByConditionForPage(1, $("#bs_pagination").bs_pagination("getOption", "rowsPerPage"));
						} else {
							// 提示信息
							alert(data.message);
						}
					}
				});
			}
        });

		// 给“修改”按钮添加点击事件
		$("#editActivityBtn").click(function () {
			// 添加点击事件，替代 toggle 打开模态窗口
			// 初始化工作
			// 编写 js 代码
			$("#editActivityForm").get(0).reset();

			// 收集参数
			// 获取列表中被选中的 checkbox
			var checkedIds = $("#tBody input[type = 'checkbox']:checked");

			// 0 选中
			if(checkedIds.size() === 0) {
				alert("请选择需要修改的市场活动");
				return;
			}
			if(checkedIds.size()>1) {
				alert("每次只能修改一条市场活动");
				return;
			}

			// 获取 dom 对象里的参数
			var id = checkedIds.get(0).value;

			// 发送请求
			$.ajax({
				url: "workbench/activity/selectActivityById.do",
				data: {
					id: id
				},
				type: "post",
				dataType: "json",
				success: function (data) {
					$("#edit-id").val(data.id);
					$("#edit-marketActivityOwner").val(data.owner);
					$("#edit-marketActivityName").val(data.name);
					$("#edit-startDate").val(data.startDate);
					$("#edit-endDate").val(data.endDate);
					$("#edit-cost").val(data.cost);
					$("#edit-description").val(data.description);
				}
			});

			// 弹出修改市场活动的模态窗口
			$("#editActivityModal").modal("show");
		});

		// 给“更新”按钮添加点击事件
		$("#updateActivityBtn").click(function () {
			// 收集参数
			// 隐藏域 id
			var id=$("#edit-id").val();

			var owner=$("#edit-marketActivityOwner").val();
			var name=$("#edit-marketActivityName").val();

			// 日期要自动生成
			var startDate=$("#edit-startDate").val();
			var endDate=$("#edit-endDate").val();

			var cost=$.trim($("#edit-cost").val());
			var description=$.trim($("#edit-description").val());

			// 表单验证
			if(owner === "") {
				alert("所有者不能为空");
				return;
			}

			if(name === "") {
				alert("名称不能为空");
				return;
			}

			if(startDate !== "" && endDate !== "") {
				// 使用字符串的大小代替日期的大小
				if(endDate < startDate) {
					alert("结束日期不能小于开始日期");
					return;
				}
			}

			/**
			 * 从外至内一一分析每个符号的意义
			 * "/....../" 在 js 中定义一个正则表达式
			 * "^" 匹配字符串的开头位置
			 * "[1-9]\d*" 匹配 0 次或多次 1-9 中的一位数字（匹配非 0 正整数）
			 * "|0" 或者匹配 0
			 * "$" 匹配字符串的结尾
			 * 非负整数：^(([1-9]\d*)|0)$
			 * @type {RegExp}
			 */
			var regExp=/^(([1-9]\d*)|0)$/;

			if(!regExp.test(cost)) {
				alert("成本只能为非负数");
				return;
			}

			// 缓存选择器结果
			var bs_pagination = $("#bs_pagination");

			// 发送请求
			$.ajax({
				url: "workbench/activity/saveEditActivity.do",
				data: {
					id: id,
					owner: owner,
					name: name,
					startDate: startDate,
					endDate: endDate,
					cost: cost,
					description: description
				},
				type: "post",
				dataType: "json",
				success: function (data) {
					if(data.code === "1") {
						// 关闭模态窗口
						$("#editActivityModal").modal("hide");

						// 刷新市场活动列表，显示第当前页数据，保持每一页显示条数不变
						queryActivityByConditionForPage(bs_pagination.bs_pagination("getOption", "currentPage"),bs_pagination.bs_pagination("getOption", "rowsPerPage"));

					}else {
						// 提示信息
						alert(data.message);

						// 模态窗口不关闭
						$("#editActivityModal").modal("show");
					}
				}
			})
		});

		// 给“批量导出”按钮添加点击事件
		$("#exportActivityAllBtn").click(function () {
			// 发送同步请求
            window.location.href="workbench/activity/exportAllActivity.do";
		});

		// 给“选择导出”按钮添加点击事件
		$("#exportActivityXzBtn").click(function () {
			// 收集参数
			var checkedIds = $("#tBody input[type = 'checkbox']:checked");

			// 0 选中
			if(checkedIds.size() === 0) {
				alert("请选择需要导出的市场活动");
				return;
			}

			var ids = [];
			// 使用 jQuery.each 遍历，jQuery 本身就是 js 代码
			$.each(checkedIds,function (){
				ids.push(this.value);
			});

			// 使用 encodeURIComponent 编码数组参数
			var encodedIds = ids.map(function(param) {
				return encodeURIComponent(param);
			});

            // 使用 .join(",") 方法将数组元素连接起来，确保参数以逗号分隔的方式传递给后端
            // 发送同步请求
			window.location.href = "workbench/activity/exportActivityByIds.do?ids=" + encodedIds.join(",");
		});

		// 上传列表数据（导入）,打开模态窗口
		$("#importActivityListBtn").click(function () {
			// 添加点击事件，替代 toggle 打开模态窗口
			// 初始化工作
			// 编写 js 代码
			// 弹出创建市场活动的模态窗口
			$("#importActivityModal").modal("show");
		});

		// 给“导入”按钮添加单击事件
		$("#importBtn").click(function () {
			var activityFile = $("#activityFile");

			// 收集参数
			var activityFileName = activityFile.val();

			// 获取文件后缀名
			var suffix = activityFileName.substring(activityFileName.lastIndexOf(".")+1).toLocaleLowerCase();
			// 检查文件格式
			if(suffix !== "xls") {
				alert("仅支持 xls 文件");
				return;
			}

			// 获取文件本身
			activityFile = activityFile[0].files[0];

			// 检查文件大小是否小于等于 5MB
			if(activityFile.size > 5*1024*1024) {
				alert("文件大小不超过 5MB");
				return;
			}

			// FormData 是 ajax 提供的接口，可以模拟键值对向后台提交参数
			// FormData 的最大优势是不但能够提交文本数据，还能提交二进制数据
			var formData = new FormData();
			formData.append("activityFile",activityFile);

			// 发送请求
			$.ajax({
				url: "workbench/activity/importActivity.do",
				data: formData,
				// 默认情况下，ajax 会将所有参数转换为字符串
				// 设置为 false，禁止转为字符串
				processData: false,
				// 默认情况下，ajax 会将所有参数按 urlencoded 进行编码
				// 设置为 false，禁止进行 urlencoded 编码
				contentType: false,
                type: "post",
                dataType: "json",
                success: function (data) {
                    if(data.code === "1") {
                        // 提示成功导入记录条数
                        alert("成功导入"+data.retData+"条记录");

                        // 关闭模态窗口
                        $("#importActivityModal").modal("hide");

                        // 刷新市场活动列表，显示第一页数据，保持每页显示条数不变
                        queryActivityByConditionForPage(1, $("#bs_pagination").bs_pagination("getOption", "rowsPerPage"));
                    }else {
                        // 提示信息
                        alert(data.message);

                        // 模态窗口不关闭
                        $("#importActivityModal").modal("show");
                    }
                }
			});
		});
	});

</script>
	<title>市场活动</title>
</head>
<body>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">

					<!-- 添加 id,拿取 dom 对象 -->
					<form id="createActivityForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">
									<!-- 遍历 userList 循环变量 u -->
									<!-- 使用 c:set 标签来设置 JavaBean 对象的属性 -->
									<c:set var="userList" value="${requestScope.userList}" />
									<c:forEach items="${userList}" var="u">
										<option value="${u.id}">${u.name}</option>
									</c:forEach>
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control my-date" name="create-startDate" id="create-startDate" readonly>
							</div>
							<label for="create-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control my-date" id="create-endDate" readonly>
							</div>
						</div>

                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>

						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveCreateActivityBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">

					<!-- 添加 id,拿取 dom 对象 -->
					<form class="form-horizontal" role="form" id="editActivityForm">

						<!-- 增加一个隐藏域，用于保存 id -->
						<input type="hidden" id="edit-id">

						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">
									<!-- 遍历 userList，采用的是 JSTL 结合 EL -->
									<c:set var="userList" value="${requestScope.userList}" />
									<c:forEach items="${userList}" var="u">
										<option value="${u.id}">${u.name}</option>
									</c:forEach>
								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control my-date" id="edit-startDate" readonly>
							</div>
							<label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control my-date" id="edit-endDate" readonly>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateActivityBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 导入市场活动的模态窗口 -->
    <div class="modal fade" id="importActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
                </div>
                <div class="modal-body" style="height: 350px;">
                    <div style="position: relative;top: 20px; left: 50px;">
                        请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
                    </div>
                    <div style="position: relative;top: 40px; left: 50px;">
                        <input type="file" id="activityFile">
                    </div>
                    <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                        <h3>重要提示</h3>
                        <ul>
                            <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                            <li>给定文件的第一行将视为字段名。</li>
                            <li>请确认您的文件大小不超过5MB。</li>
                            <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                            <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                            <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                            <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="importBtn" type="button" class="btn btn-primary">导入</button>
                </div>
            </div>
        </div>
    </div>
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
						<label>
							<input class="form-control" type="text" id="query-name">
						</label>
					</div>
				  </div>
				  
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
				      <div class="input-group-addon">开始日期</div>
						<label for="query-startDate"></label><input class="form-control" type="text" id="query-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
						<label for="query-endDate"></label><input class="form-control" type="text" id="query-endDate">
				    </div>
				  </div>

					<!-- submit 提交，同步请求 -->
					<!-- 这里应采用异步请求 -->
				  <button type="button" class="btn btn-default" id="queryActivityBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
					<!-- toggle 实现弹窗无法进行数据的初始化 -->
				  <button type="button" class="btn btn-primary" id="createActivityBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editActivityBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteActivityBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
                    <button type="button" id="importActivityListBtn" class="btn btn-default"><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
                    <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）</button>
                    <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
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
							<td>开始日期</td>
							<td>结束日期</td>
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