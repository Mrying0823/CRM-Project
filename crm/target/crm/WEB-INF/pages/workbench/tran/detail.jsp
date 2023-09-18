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

<style type="text/css">
.mystage{
	font-size: 20px;
	vertical-align: middle;
	cursor: pointer;
}
.closingDate{
	font-size : 15px;
	cursor: pointer;
	vertical-align: middle;
}
</style>
	
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

		var myStage = $(".myStage")

		//阶段提示框
		myStage.popover({
            trigger:'manual',
            placement : 'bottom',
            html: 'true',
            animation: false
        }).on("mouseenter", function () {
                    var _this = this;
                    $(this).popover("show");
                    $(this).siblings(".popover").on("mouseleave", function () {
                        $(_this).popover('hide');
                    });
                }).on("mouseleave", function () {
                    var _this = this;
                    setTimeout(function () {
                        if (!$(".popover:hover").length) {
                            $(_this).popover("hide")
                        }
                    }, 100);
                });

		myStage.click(function () {
			// .data(): 这个方法用于获取和设置元素的数据属性（data-* 属性）的值，数据缓存在 jQuery 内部
			var stageId = $(this).data("id");
			var stageNo = $(this).data("no");
			var stageName = $(this).data("content");
			var tranId = "${requestScope.tran.id}";
			var money = "${requestScope.tran.money}";
			var expectedDate = "${requestScope.tran.expectedDate}";
			var template = "";

			if("${requestScope.tran.possibility}" === "100" || $(this).hasClass("cant")) {
				alert("已经成交的交易不能修改阶段");
				return;
			}

			if($(this).hasClass("current")) {
				alert("选择修改的阶段与当前阶段重复");
				return;
			}

			$.ajax({
				url: "workbench/tran/saveEditTranStage.do",
				data: {
					id: tranId,
					money: money,
					expectedDate: expectedDate,
					stageId: stageId
				},
				type: "post",
				dataType: "json",
				success:function (data) {
					if(data.code === "1") {
						// 遍历每个元素并根据条件修改属性样式
						myStage.each(function (index,obj) {
							// 移除所有的 glyphicon 类名
							$(obj).removeClass("glyphicon-map-marker glyphicon-ok-circle glyphicon-record current cant");

							if(data.retData.possibility === "100") {
								$(obj).addClass("cant");
							}

							if (index === stageNo-1) {
								$(obj).addClass("glyphicon-map-marker current");
								$(obj).css("color", "#90F790");
							} else if (index < stageNo-1) {
								$(obj).addClass("glyphicon-ok-circle");
								$(obj).css("color", "#90F790");
							} else if (index > stageNo-1) {
								$(obj).addClass("glyphicon-record");
								$(obj).css("color", "black");
							}
						});

						// 更新交易基本信息
						$("#stageB").text(data.retData.stageName);
						$("#possibilityB").text(data.retData.possibility+"%");

						// 添加交易阶段历史
						template +=
							`<tr>
								<td>`+stageName+`</td>
								<td>`+data.retData.tranHistory.money+`</td>
								<td>`+data.retData.tranHistory.expectedDate+`</td>
								<td>`+data.retData.tranHistory.createByName+`</td>
								<td>`+data.retData.tranHistory.createTime+`</td>
							</tr>`

						$("#historyTBody").append(template);
					} else {
						alert(data.message);
					}
				}
			});
		});
	});
	
	
	
</script>
	<title>交易明细界面</title>

</head>
<body>
	
	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${requestScope.tran.customerId}-${requestScope.tran.name} <small>￥${requestScope.tran.money}</small></h3>
		</div>
		
	</div>

	<br/>
	<br/>
	<br/>

	<!-- 阶段状态 -->
	<div style="position: relative; left: 40px; top: -50px;" id="stageIcon">
		阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<!-- 遍历 stageList，依次显示每一个阶段对应的图标 -->
		<c:forEach items="${requestScope.stageList}" var="stage">
			<!-- 如果 stage 就是当前交易所处阶段，则图标显示为 map-marker，颜色显示为绿色 -->
			<c:if test="${stage.value == requestScope.tran.stage}">
				<span class="glyphicon glyphicon-map-marker myStage current" data-toggle="popover" data-placement="bottom" data-content="${stage.value}" style="color: #90F790;" data-id="${stage.id}" data-no="${stage.orderNo}"></span>
				-----------
			</c:if>

			<!-- 如果 stage 处在当前交易所处阶段前边，则图标显示为 ok-circle，颜色显示为绿色 -->
			<c:if test="${stage.orderNo < requestScope.tran.orderNo}">
				<span class="glyphicon glyphicon-ok-circle myStage" data-toggle="popover" data-placement="bottom" data-content="${stage.value}" style="color: #90F790;" data-id="${stage.id}" data-no="${stage.orderNo}"></span>
				-----------
			</c:if>

			<!-- 如果 stage 处在当前交易所处阶段后边，则图标显示为 record，颜色显示为黑色 -->
			<c:if test="${stage.orderNo > requestScope.tran.orderNo}">
				<span class="glyphicon glyphicon-record myStage" data-toggle="popover" data-placement="bottom" data-content="${stage.value}" style="color: black;" data-id="${stage.id}" data-no="${stage.orderNo}"></span>
				-----------
			</c:if>
		</c:forEach>
		<span class="closingDate">${requestScope.tran.expectedDate}</span>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: 0;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">金额</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.tran.money}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.customerId}-${requestScope.tran.name}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">预计成交日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.tran.expectedDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">客户名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.customerId}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">阶段</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="stageB">${requestScope.tran.stage}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">类型</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.type}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">可能性</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="possibilityB">${requestScope.tran.possibility}%</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">来源</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.source}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">市场活动源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.tran.activityId}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">联系人名称</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.contactsId}</b></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.tran.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.tran.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${requestScope.tran.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${requestScope.tran.contactSummary}&nbsp;
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 100px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.nextContactTime}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 100px; left: 40px;" id="displayRemark">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<c:forEach items="${requestScope.tranRemarkList}" var="remark">
			<div id="div_${remark.id}" class="remarkDiv" style="height: 60px;">
				<img title="${remark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5>${remark.noteContent}</h5>
					<font color="gray">交易</font> <font color="gray">-</font> <b>${requestScope.tran.customerId}-${requestScope.tran.name}</b> <small style="color: gray;"> ${remark.editFlag == "1"?remark.editTime:remark.createTime} ${remark.editFlag == "1"?"edited by":"by"} ${remark.editFlag == "1"?remark.editBy:remark.createBy}</small>
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
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 阶段历史 -->
	<div>
		<div style="position: relative; top: 100px; left: 40px;">
			<div class="page-header">
				<h4>阶段历史</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>阶段</td>
							<td>金额</td>
							<td>预计成交日期</td>
							<td>创建人</td>
							<td>创建时间</td>
						</tr>
					</thead>
					<tbody id="historyTBody">
					<c:forEach items="${requestScope.tranHistoryList}" var="th" varStatus="status">
						<c:set var="isActive" value="${status.index % 2 == 0 ? '' : 'active'}" />
						<tr class="${isActive}">
							<td>${th.stage}</td>
							<td>${th.money}</td>
							<td>${th.expectedDate}</td>
							<td>${th.createBy}</td>
							<td>${th.createTime}</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
			</div>
			
		</div>
	</div>
	
	<div style="height: 200px;"></div>
	
</body>
</html>