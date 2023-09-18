package org.example.crm.workbench.web.controller;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.example.crm.commons.domain.ReturnObject;
import org.example.crm.commons.utils.DateUtils;
import org.example.crm.commons.utils.ExcelCellUtils;
import org.example.crm.commons.utils.ExportActivityUtils;
import org.example.crm.commons.utils.UUIDUtils;
import org.example.crm.commons.utils.contants.Constants;
import org.example.crm.settings.domain.User;
import org.example.crm.settings.service.UserService;
import org.example.crm.workbench.domain.Activity;
import org.example.crm.workbench.domain.ActivityRemark;
import org.example.crm.workbench.service.ActivityRemarkService;
import org.example.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.util.*;

@Controller
public class ActivityController {

    private UserService userService;

    private ActivityService activityService;

    private ActivityRemarkService activityRemarkService;

    @Autowired
    public void setUserService(UserService userService) {
        this.userService = userService;
    }

    @Autowired
    public void setActivityService(ActivityService activityService) {
        this.activityService = activityService;
    }

    @Autowired
    public void setActivityRemarkService(ActivityRemarkService activityRemarkService){
        this.activityRemarkService = activityRemarkService;
    }

    /**
     * 查询所有在职员工
     * @param request
     * @return
     */
    @RequestMapping("/workbench/activity/index.do")
    public String index(HttpServletRequest request) {
        // 调用 service 层方法，查询所有在职用户
        List<User> userList = userService.queryAllUsers();

        // 把数据保存到 request 中
        request.setAttribute(Constants.REQUEST_USER_LIST,userList);

        // 请求转发到市场活动的主页面
        return "workbench/activity/index";
    }

    /**
     * 保存创建的市场活动
     * @param activity
     * @param session
     * @return
     */
    @RequestMapping("/workbench/activity/saveCreateActivity.do")
    public @ResponseBody Object saveCreateActivity(Activity activity, HttpSession session) {

        // 从登录时保存在 session 中的 user 对象获取用户 id
        User user = (User) session.getAttribute(Constants.SESSION_USER);

        ReturnObject returnObject = new ReturnObject();

        // 补充前台没有的三个参数 id、create_time、create_by
        activity.setId(UUIDUtils.getUUID());
        activity.setCreateTime(DateUtils.formatDateTime(new Date()));
        activity.setCreateBy(user.getId());

        try {
            // 调用 service 层方法，保存创建的市场活动
            int ret = activityService.saveCreateActivity(activity);

            if(ret > 0) {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙，请稍后重试......");
            }
        }catch (Exception e) {
            e.printStackTrace();

            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙，请稍后重试......");
        }

        return returnObject;
    }

    // 返回 json 字符串
    /**
     * 控制器编写查询数据并返回查询结果代码
     * @param name
     * @param owner
     * @param startDate
     * @param endDate
     * @param pageNo
     * @param pageSize
     * @return
     */
    @RequestMapping("/workbench/activity/queryActivityByConditionForPage.do")
    public @ResponseBody Object queryActivityByConditionForPage(String name, String owner, String startDate, String endDate,
                                                                Integer pageNo, Integer pageSize) {
        // 封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("beginNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);

        // 调用 service 层方法查询数据
        List<Activity> activityList = activityService.queryActivityByConditionForPage(map);

        Integer totalRows = activityService.queryCountOfActivityByCondition(map);

        // 根据查询结果，生成响应信息
        Map<String,Object> retMap = new HashMap<>();
        retMap.put("activityList",activityList);
        retMap.put("totalRows",totalRows);

        return retMap;
    }

    /**
     * 删除批量选择的市场活动
     * @param id
     * @return
     */
    @RequestMapping("/workbench/activity/deleteActivityByIds.do")
    // 传入的参数是 id 而不是 ids
    // 如果前端传入的参数不为空，而后端获取的参数为空，可能是参数命名不对
    public @ResponseBody Object deleteActivityByIds(String[] id) {

        ReturnObject returnObject = new ReturnObject();

        try {
            // 调用 service 层方法，删除市场活动
            int ret = activityService.deleteActivityByIds(id);

            if(ret > 0) {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙，请稍后重试......");
            }
        }catch (Exception e) {
            e.printStackTrace();

            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙，请稍后重试......");
        }

        return returnObject;
    }

    /**
     * 根据 id 查询某一条市场活动
     * @param id
     * @return
     */
    @RequestMapping("/workbench/activity/selectActivityById.do")
    public @ResponseBody Object selectActivityById(String id) {
        // 调用 service 层方法，查询市场活动
        // 根据查询结果，返回响应信息
        return activityService.queryActivityById(id);
    }

    /**
     * 更新修改后的市场活动
     * @param activity
     * @param session
     * @return
     */
    @RequestMapping("/workbench/activity/saveEditActivity.do")
    // 返回 json 数据，所以返回类型是 Object
    public @ResponseBody Object saveEditActivity(Activity activity,HttpSession session) {

        // 从登录时保存在 session 中的 user 对象获取用户 id
        User user = (User) session.getAttribute(Constants.SESSION_USER);

        ReturnObject returnObject = new ReturnObject();

        // 补充前台没有的参数 edit_time、edit_by
        activity.setEditBy(user.getId());
        activity.setEditTime(DateUtils.formatDateTime(new Date()));

        try {
            // 调用 service 层方法，更新修改后的市场活动
            int ret = activityService.saveEditActivity(activity);

            if(ret > 0) {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙，请稍后重试......");
            }
        }catch (Exception e) {
            e.printStackTrace();

            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙，请稍后重试......");
        }
        return returnObject;
    }

    /**
     * 批量导出市场活动
     * 不借助值返回文件，返回流
     * @param response
     * @throws IOException
     */
    @RequestMapping("/workbench/activity/exportAllActivity.do")
    public void exportAllActivity(HttpServletResponse response) throws IOException {
        // 调用 service 层方法查询数据
        List<Activity> activityList = activityService.queryAllActivity();

        String[] headers = {"ID","所有者","名称","开始日期","结束日期","成本","描述","创建时间","创建者","修改时间","修改者"};

        ExportActivityUtils.generateExcel(response,"市场活动列表",headers,activityList);
    }

    /**
     * 选择导出市场活动
     * @param ids
     * @param response
     * @throws IOException
     */
    @RequestMapping("/workbench/activity/exportActivityByIds.do")
    public void exportActivityByIds(@RequestParam String[] ids,HttpServletResponse response) throws IOException {
        // 调用 service 层方法查询数据
        List<Activity> activityList = activityService.queryActivityByIds(ids);

        String[] headers = {"ID","所有者","名称","开始日期","结束日期","成本","描述","创建时间","创建者","修改时间","修改者"};

        ExportActivityUtils.generateExcel(response,"市场活动列表",headers,activityList);
    }

    /**
     * 配置 SpringMVC 的文件上传解析器
     */
    @RequestMapping("/workbench/activity/importActivity.do")
    public @ResponseBody Object importActivity(HttpSession session,MultipartFile activityFile) throws Exception{

        // 从登录时保存在 session 中的 user 对象获取用户 id
        User user = (User) session.getAttribute(Constants.SESSION_USER);

        ReturnObject returnObject = new ReturnObject();

        List<Activity> activityList = new ArrayList<>();

        try {
            // 获取输入流
            InputStream in = activityFile.getInputStream();

            HSSFWorkbook workbook = new HSSFWorkbook(in);

            // 根据 workbook 获取 HSSDSheet 对象，封装了一页的所有信息
            // getSheetAt 根据页的下标获取，下标从 0 开始，依次增加
            HSSFSheet sheet = workbook.getSheetAt(0);

            HSSFRow row = null;
            HSSFCell cell = null;

            // 根据最后一行的下标，逐一获取行
            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                // getRow 根据行的下标获取，下标从 0 开始，依次增加
                row = sheet.getRow(i);

                Activity activity = new Activity();

                // 根据最后一列的下标，逐一获取列
                for (int j = 0; j < row.getLastCellNum(); j++) {
                    // getCell 根据列的下标获取，下标从 0 开始，依次增加
                    cell = row.getCell(j);

                    // 根据指定模板导入数据
                    // 市场活动的 ID 自动生成
                    activity.setId(UUIDUtils.getUUID());
                    // 所有者 owner 解决方案：1、公共账号 2、当前登录用户
                    activity.setOwner(user.getId());
                    // 创建时间
                    activity.setCreateTime(DateUtils.formatDateTime(new Date()));
                    // 创建者
                    activity.setCreateBy(user.getId());
                    // 修改时间
                    activity.setEditTime(null);
                    // 修改者
                    activity.setEditBy(null);

                    // 获取列中的数据
                    String cellValue = ExcelCellUtils.getStringCellValue(cell);

                    switch (j) {
                        case 0:
                            activity.setName(cellValue);
                            break;
                        case 1:
                            activity.setStartDate(cellValue);
                            break;
                        case 2:
                            activity.setEndDate(cellValue);
                            break;
                        case 3:
                            activity.setCost(cellValue);
                            break;
                        case 4:
                            activity.setDescription(cellValue);
                            break;
                    }
                }

                // 每一行中所有的列都封装完成后，将 activity 保存至 activityList 中
                activityList.add(activity);
            }

            // 调用 service 层方法，保存市场活动
            int ret = activityService.saveImportActivityByList(activityList);

            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            returnObject.setRetData(ret);
            in.close();
        }catch (Exception e) {
            e.printStackTrace();

            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙，请稍后重试......");
        }

        return returnObject;
    }

    /**
     * 查看市场活动明细
     * @param id
     * @param request
     * @return
     */
    @RequestMapping("/workbench/activity/detailActivity.do")
    public String detailActivity(@RequestParam String id,HttpServletRequest request) {
        // 调用 service 层方法，查询市场活动
        // 根据查询结果，返回响应信息
        Activity activity = activityService.queryDetailActivityById(id);
        List<ActivityRemark> remarkList = activityRemarkService.queryActivityRemarkForDetailByActivityId(id);

        request.setAttribute("activity",activity);
        request.setAttribute("remarkList",remarkList);

        return "workbench/activity/detail";
    }
}
