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

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/echarts/echarts.min.js"></script>

<script type="text/javascript">
    
    $(function () {

        // 在初始化echarts的时候，echarts.js 规定只能使用 dom 原生方法获取标签
        var myChart = echarts.init(document.getElementById("chart"));

        $.ajax({
            url: "workbench/chart/tran/queryCountOfTranGroupByStage.do",
            type: "post",
            dataType: "json",
            success: function (data) {
                var option = {
                    title: {
                        text: '阶段分析'
                    },
                    tooltip: {
                        trigger: 'item',
                        formatter: '{a} <br/>{b} : {c}'
                    },
                    toolbox: {
                        feature: {
                            dataView: { readOnly: false },
                            restore: {},
                            saveAsImage: {}
                        }
                    },
                    legend: {
                        data: data.map(function (obj) {
                            return obj.name;
                        })
                    },
                    series: [
                        {
                            name: '阶段',
                            type: 'funnel',
                            left: '10%',
                            top: 60,
                            bottom: 60,
                            width: '80%',
                            sort: 'descending',
                            gap: 2,
                            label: {
                                show: true,
                                position: 'inside'
                            },
                            labelLine: {
                                length: 10,
                                lineStyle: {
                                    width: 1,
                                    type: 'solid'
                                }
                            },
                            itemStyle: {
                                borderColor: '#fff',
                                borderWidth: 1
                            },
                            emphasis: {
                                label: {
                                    fontSize: 20
                                }
                            },
                            data: data
                        }
                    ]
                };

                myChart.setOption(option);
            }
        });
    });
</script>
    <title>echarts 图表</title>

</head>
<body>
    <div id="chart" style="width: 100vw;height: 100vh;object-fit: cover"></div>
</body>
</html>