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
<link href="jquery/styles/styles.css" type="text/css" rel="stylesheet" />
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

		// 保存后未刷新的列表新增的市场活动备注没有编辑和删除鼠标悬停事件
		// 给动态元素添加事件
		// 给市场活动备注添加事件，图标的显示
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

		// 给”保存市场活动备注“按钮添加点击事件
		$("#saveBtn").click(function(){
			// 收集参数
			var noteContent = $.trim($("#remark").val());
			// jsp 的运行原理，先从作用域取数据
			var activityId = "${requestScope.activity.id}";

			// 表单验证
			if(noteContent === "") {
				alert("内容不为空");
				return;
			}

			// 发送请求
			$.ajax({
				url: "workbench/activity/saveCreateActivityRemark.do",
				data: {
					noteContent: noteContent,
					activityId: activityId
				},
				type: "post",
				dataType: "json",
				success: function (data) {
					// code 是 字符型
					if(data.code === "1") {
						// 清空输入框
						$("#remark").val("");

						// 刷新市场活动备注列表
						// 给 div 绑定 id，用于删除市场活动备注
						// div_ 拼接避免同一父标签下 id 重复
						// 跟据 id 找到要删除市场活动备注的 div
                        // 按照 div 的方法定位 h5，定义过多属性代码乱
                        // <h5 id="h5_`+data.retData.id+`">`+noteContent+`</h5>
                        var template =
								`<div id="div_`+data.retData.id+`" class="remarkDiv" style="height: 60px;">
									<img title=${sessionScope.sessionUser.name} src="image/user-thumbnail.png" style="width: 30px; height:30px;">
									<div style="position: relative; top: -40px; left: 40px;" >
										<h5>`+noteContent+`</h5>
										<font color="gray">市场活动</font> <font color="gray">-</font> <b>${requestScope.activity.name}</b> <small style="color: gray;"> `+data.retData.createTime+` by ${sessionScope.sessionUser.name}</small>
										<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
											<a class="myHref" name="editRemark" remarkId="`+data.retData.id+`"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
											&nbsp;&nbsp;&nbsp;&nbsp;
											<a class="myHref" name="deleteRemark" remarkId="`+data.retData.id+`"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
										</div>
									</div>
								</div>`;

						// 在市场活动备注输入窗口前显示保存的市场活动备注
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
				url: "workbench/activity/deleteActivityRemarkById.do",
				data: {
					id: id
				},
				type: "post",
				dataType: "json",
				success: function (data) {
					if(data.code === "1") {
						// 刷新市场活动备注列表
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
            // 获取市场活动备注的 id 和 noteContent
            var id = $(this).attr("remarkId");
            // 根据 div 找 h5
            // jQuery 选择器，根据元素的嵌套关系来选择元素，div 标签下有唯一的一个 h5 标签
            var noteContent = $("#div_"+id+" h5").text();

            // 把市场活动备注的 id 和 noteContent 显示到模态窗口
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
				url: "workbench/activity/saveEditActivityRemark.do",
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

						// 刷新市场活动备注列表
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
	});
</script>
		<title>市场活动明细</title>
</head>
<body>
	<!-- 修改市场活动备注的模态窗口 -->
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

    

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header no-wrap">
			<h3>市场活动-${requestScope.activity.name}
				<small>${requestScope.activity.startDate} ~ ${requestScope.activity.endDate}</small>
			</h3>
		</div>

	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.activity.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.activity.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.activity.startDate}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.activity.endDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.activity.cost}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.activity.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.activity.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.activity.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.activity.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${requestScope.activity.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 30px; left: 40px;" id="displayRemark">
		<div class="page-header">
			<h4>备注</h4>
		</div>

		<!-- JSTL 遍历 -->
		<c:forEach items="${requestScope.remarkList}" var="remark">
			<div id="div_${remark.id}" class="remarkDiv" style="height: 60px;">
				<img title=${remark.createBy} src="image/user-thumbnail.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5>${remark.noteContent}</h5>
					<font color="gray">市场活动</font> <font color="gray">-</font> <b>${requestScope.activity.name}</b> <small style="color: gray;"> ${remark.editFlag == "1"?remark.editTime:remark.createTime} ${remark.editFlag == "1"?"edited by":"by"} ${remark.editFlag == "1"?remark.editBy:remark.createBy}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
						<!-- 自定义属性保存市场活动 id。不是表单组件标签（input），不推荐使用value，推荐使用自定义属性-->
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
					<button id="saveBtn" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	<div style="height: 200px;"></div>
</body>
</html>