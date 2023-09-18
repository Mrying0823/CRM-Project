<%@ page contentType="text/html;charset=UTF-8" %>
<!-- 引入核心标签库 -->
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});

		var displayRemark = $("#displayRemark");

		displayRemark.on("mouseover",".remarkDiv",function () {
			$(this).children("div").children("div").show();
		});

		displayRemark.on("mouseout",".remarkDiv",function () {
			$(this).children("div").children("div").hide();
		});

		// 给图标添加事件，颜色变化
		displayRemark.on("mouseover",".myHref",function () {
			$(this).children("span").css("color","red");
		});

		displayRemark.on("mouseout",".myHref",function () {
			$(this).children("span").css("color","#E6E6E6");
		});

		// 给”保存线索备注“按钮添加点击事件
		$("#saveBtn").click(function(){
			// 收集参数
			var noteContent = $.trim($("#remark").val());
			// jsp 的运行原理，先从作用域取数据
			var clueId = "${requestScope.clue.id}";

			// 表单验证
			if(noteContent === "") {
				alert("内容不为空");
				return;
			}

			// 发送请求
			$.ajax({
				url: "workbench/clue/saveCreateClueRemark.do",
				data: {
					noteContent: noteContent,
					clueId: clueId
				},
				type: "post",
				dataType: "json",
				success: function (data) {
					// code 是 字符型
					if(data.code === "1") {
						// 清空输入框
						$("#remark").val("");

						// 刷新线索备注列表
						// 给 div 绑定 id，用于删除线索备注
						// div_ 拼接避免同一父标签下 id 重复
						// 跟据 id 找到要删除线索备注的 div
						// 按照 div 的方法定位 h5，定义过多属性代码乱
						// <h5 id="h5_`+data.retData.id+`">`+noteContent+`</h5>
						var template =
								`<div id="div_`+data.retData.id+`" class="remarkDiv" style="height: 60px;">
									<img title="`+data.retData.createBy+`" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
										<div style="position: relative; top: -40px; left: 40px;" >
											<h5>`+noteContent+`</h5>
											<font color="gray">线索</font> <font color="gray">-</font> <b>${requestScope.clue.fullname}${requestScope.clue.appellation}-${requestScope.clue.company}</b> <small style="color: gray;"> `+data.retData.createTime+` by ${sessionScope.sessionUser.name}</small>
											<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
												<a class="myHref" name="editRemark" remarkId="`+data.retData.id+`"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
												&nbsp;&nbsp;&nbsp;&nbsp;
												<a class="myHref" name="deleteRemark" remarkId="`+data.retData.id+`"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
											</div>
										</div>
								</div>`

						// 在线索备注输入窗口前显示保存的线索备注
						$("#remarkDiv").before(template);
					}else {
						// 提示信息
						alert(data.message);
					}
				}
			})
		});

		// 给所有的“删除”图标添加点击事件
		// 针对 name 属性为 "deleteRemark" 的 <a> 元素添加点击事件处理程序
		displayRemark.on("click","a[name=deleteRemark]",function () {
			// 收集参数
			// 自定义的属性，不管是什么标签，只能用：jquery对象.attr("属性名");
			var id = $(this).attr("remarkId");

			// 发送请求
			$.ajax({
				url: "workbench/clue/deleteClueRemarkById.do",
				data: {
					id: id
				},
				type: "post",
				dataType: "json",
				success: function (data) {
					if(data.code === "1") {
						// 刷新线索备注列表
						$("#div_"+id).remove();
					}else {
						// 提示信息
						alert(data.message);
					}
				}
			})
		});

		// 给所有的“修改”图标添加点击事件
		displayRemark.on("click","a[name=editRemark]",function () {
			// 收集参数
			// 获取线索备注的 id 和 noteContent
			var id = $(this).attr("remarkId");
			// 根据 div 找 h5
			// jQuery 选择器，根据元素的嵌套关系来选择元素，div 标签下有唯一的一个 h5 标签
			var noteContent = $("#div_"+id+" h5").text();

			// 把线索备注的 id 和 noteContent 显示到模态窗口
			$("#edit-id").val(id);
			$("#edit-noteContent").val(noteContent);

			// 显示模态窗口
			$("#editRemarkModal").modal("show");
		});

		// 给“更新”按钮添加点击事件
		$("#updateRemarkBtn").click(function () {
			// 收集参数
			var id = $("#edit-id").val();
			var noteContent = $("#edit-noteContent").val();

			// 表单验证
			if(noteContent === "") {
				alert("备注内容不为空");
				return;
			}

			// 发送请求
			$.ajax({
				url: "workbench/clue/saveEditClueRemark.do",
				data: {
					id: id,
					noteContent: noteContent
				},
				type: "post",
				dataType: "json",
				success: function (data) {
					if(data.code === "1") {
						// 关闭模态窗口
						$("#editRemarkModal").modal("hide");

						// 刷新线索备注列表
						// 之所以 h5 前面有一个空格，是为了确保选择器能够正确选择目标元素。这里的空格表示一个元素选择器之后的后代元素选择器
						$("#div_"+id+" h5").text(noteContent);
						$("#div_"+id+" small").text(" "+data.retData.editTime+" edited by ${sessionScope.sessionUser.name}");
					}else {
						// 提示信息
						alert(data.message);

						// 模态窗口不关闭
						$("#editRemarkModal").modal("show");
					}
				}
			});
		});
        
        // 给”关联市场活动“按钮添加点击事件
        $("#bindActivityBtn").click(function () {
            // 弹出关联市场活动的模态窗口
            $("#bindActivityModal").modal("show");
        });

		// 给整个浏览器窗口添加键盘按下事件
		$(window).keydown(function (e) {
			// 按下回车键，阻止默认行为
			if (e.keyCode === 13) {
				return false;
			}
		});

        // 给市场活动搜索框添加键盘弹起事件
        $("#searchActivityText").keyup(function () {
            // 收集参数
            // 直接获取 dom 对象的内容
            var activityName = this.value;
            var clueId = "${requestScope.clue.id}";
            var template = "";

            // 发送请求
            $.ajax({
                url: "workbench/clue/queryActivityForDetailByNameAndClueId.do",
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
                            `<tr id="tr_`+obj.id+`" class=`+isActive+`>
								<td><label>
									<input type="checkbox" value="`+obj.id+`"/>
								</label></td>
								<td>`+obj.name+`</td>
								<td>`+obj.startDate+`</td>
								<td>`+obj.endDate+`</td>
								<td>`+obj.owner+`</td>
							</tr>`;
                    })

                    $("#tBody").html(template);
                }
            });
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

		// 给“关联”市场活动按钮添加点击事件
		$("#saveBindActivityBtn").click(function () {

			var template = "";

			// 收集参数
			// 获取列表中所有被选中的 checkbox
			var checkedIds = $("#tBody input[type = 'checkbox']:checked");

			// 表单验证
			if(checkedIds.size() === 0) {
				alert("每次至少关联一个市场活动");
				return;
			}

			// 选择的市场活动的 id
			var ids = "";
			$.each(checkedIds,function () {
				ids += "activityId="+this.value+"&";
			});

			// 选择的线索的 id
			ids += "clueId=${requestScope.clue.id}";

			// 发送请求
			$.ajax({
				url: "workbench/clue/saveBindClueActivity.do",
				data: ids,
				type: "post",
				dataType: "json",
				success: function (data) {
					if(data.code === "1") {
						// 关闭模态窗口
						$("#bindActivityModal").modal("hide");

						// 将关联的市场活动从模态窗口中删除
						$.each(checkedIds,function () {
							$("#tr_"+this.value).remove();
						});

						// 如果模态窗口中所有市场活动都被选中，关联后重置"全选"按钮
						$("#checkAll").prop("checked",false);

						// 刷新已经关联的市场活动列表
						$.each(data.retData,function (index,obj) {
							template +=
								`<tr id="tr_`+obj.id+`">
									<td>`+obj.name+`</td>
									<td>`+obj.startDate+`</td>
									<td>`+obj.endDate+`</td>
									<td>`+obj.owner+`</td>
									<td><a href="javascript:void(0);" activityId="`+obj.id+`" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
								</tr>`;
						});

						// 追加显示
						$("#relatedTBody").append(template);
					}else {
						// 提示信息
						alert(data.message);

						// 模态窗口不关闭
						$("#bindActivityModal").modal("show");
					}
				}
			});
		});

		// 给所有"解除关联"按钮添加点击事件
		$("#relatedTBody").on("click","a",function () {
			// 收集参数
			var activityId = $(this).attr("activityId");
			var clueId = "${requestScope.clue.id}"

			if(window.confirm("确认解除吗？")) {
				// 发送请求
				$.ajax({
					url: "workbench/clue/saveUnBindClueActivity.do",
					data: {
						activityId: activityId,
						clueId: clueId
					},
					type: "post",
					dataType: "json",
					success: function (data) {
						if (data.code === "1") {
							// 刷新已经关联的市场活动列表
							$("#tr_" + activityId).remove();
						} else {
							// 提示信息
							alert(data.message);
						}
					}
				});
			}
		});
		
		// 给“转换”按钮添加点击事件
		$("#convertClueBtn").click(function () {
			// 发送同步请求
			window.location.href="workbench/clue/toConvert.do?id=${requestScope.clue.id}";
		})
	});
	
</script>
		<title>线索详细</title>

</head>
<body>
	<!-- 修改线索备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 40%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改备注</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">

						<!-- 增加一个隐藏域，用于保存 id -->
						<input type="hidden" id="edit-id">

						<div class="form-group">
							<label for="edit-noteContent" class="col-sm-2 control-label">内容</label>
							<div class="col-sm-10" style="width: 81%;">
								<label for="edit-noteContent"></label><textarea class="form-control" rows="3" id="edit-noteContent"></textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 关联市场活动的模态窗口 -->
	<div class="modal fade" id="bindActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
							  <label>
								  <input type="text" id="searchActivityText" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
							  </label>
							  <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><label>
									<input type="checkbox" id="checkAll"/>
								</label></td>
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
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="saveBindActivityBtn">关联</button>
				</div>
			</div>
		</div>
	</div>


	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${requestScope.clue.fullname}${requestScope.clue.appellation}<small> - ${requestScope.clue.company}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" id="convertClueBtn"><span class="glyphicon glyphicon-retweet"></span> 转换</button>
			
		</div>
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.fullname}${requestScope.clue.appellation}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.clue.owner}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.company}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.clue.job}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.clue.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.clue.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">线索状态</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.state}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.clue.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.clue.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.clue.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${requestScope.clue.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${requestScope.clue.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
					${requestScope.clue.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 40px; left: 40px;" id="displayRemark">
		<div class="page-header">
			<h4>备注</h4>
		</div>

		<c:forEach items="${requestScope.remarkList}" var="remark">
			<div id="div_${remark.id}" class="remarkDiv" style="height: 60px;">
				<img title="${remark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5>${remark.noteContent}</h5>
					<font color="gray">线索</font> <font color="gray">-</font> <b>${requestScope.clue.fullname}${requestScope.clue.appellation}-${requestScope.clue.company}</b> <small style="color: gray;"> ${remark.editFlag == "1"?remark.editTime:remark.createTime} ${remark.editFlag == "1"?"edited by":"by"} ${remark.editFlag == "1"?remark.editBy:remark.createBy}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
						<a class="myHref" name="editRemark" remarkId="${remark.id}"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a class="myHref" name="deleteRemark" remarkId="${remark.id}"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div>
		</c:forEach>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<label for="remark"></label><textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2" placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="relatedTBody">
					<!-- 使用 JSTL（JavaServer Pages Standard Tag Library）的 c:forEach 标签中的 varStatus 属性来跟踪迭代的索引 -->
					<!-- 使用 c:set 标签来计算 isActive 变量，根据 status.index（迭代的索引）的奇偶性来设置 active 属性 -->
					<!-- 在 <tr> 标签中使用 isActive 作为类的值，以实现交替的 active 属性 -->
					<c:forEach items="${requestScope.activityList}" var="a" varStatus="status">
						<c:set var="isActive" value="${status.index % 2 == 0 ? '' : 'active'}" />
						<tr id="tr_${a.id}" class="${isActive}">
							<td>${a.name}</td>
							<td>${a.startDate}</td>
							<td>${a.endDate}</td>
							<td>${a.owner}</td>
							<td><a href="javascript:void(0);" activityId="${a.id}" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" id="bindActivityBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>

	<div style="height: 200px;"></div>
</body>
</html>