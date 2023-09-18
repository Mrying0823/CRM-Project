package org.example.crm.workbench.web.controller;

import org.example.crm.commons.domain.ReturnObject;
import org.example.crm.commons.utils.DateUtils;
import org.example.crm.commons.utils.UUIDUtils;
import org.example.crm.commons.utils.contants.Constants;
import org.example.crm.settings.domain.DicValue;
import org.example.crm.settings.domain.User;
import org.example.crm.settings.service.DicValueService;
import org.example.crm.settings.service.UserService;
import org.example.crm.workbench.domain.Activity;
import org.example.crm.workbench.domain.Clue;
import org.example.crm.workbench.domain.ClueActivityRelation;
import org.example.crm.workbench.domain.ClueRemark;
import org.example.crm.workbench.service.ActivityService;
import org.example.crm.workbench.service.ClueActivityRelationService;
import org.example.crm.workbench.service.ClueRemarkService;
import org.example.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
public class ClueController {
    private UserService userService;

    private DicValueService dicValueService;

    private ClueService clueService;

    private ClueRemarkService clueRemarkService;

    private ActivityService activityService;

    private ClueActivityRelationService clueActivityRelationService;

    @Autowired
    public void setUserService(UserService userService) {
        this.userService = userService;
    }

    @Autowired
    public void setDicValueService(DicValueService dicValueService) {
        this.dicValueService = dicValueService;
    }

    @Autowired
    public void setClueService(ClueService clueService) {
        this.clueService = clueService;
    }

    @Autowired
    public void setClueRemarkService(ClueRemarkService clueRemarkService) {
        this.clueRemarkService = clueRemarkService;
    }

    @Autowired
    public void setActivityService(ActivityService activityService) {
        this.activityService = activityService;
    }

    @Autowired
    public void setClueActivityRelationService(ClueActivityRelationService clueActivityRelationService) {
        this.clueActivityRelationService = clueActivityRelationService;
    }

    /**
     * 跳转至线索界面前的准备
     * @param request
     * @return
     */
    @RequestMapping("/workbench/clue/index.do")
    public String index(HttpServletRequest request) {
        // 调用 service 层方法，查询动态数据
        List<User> userList = userService.queryAllUsers();
        List<DicValue> appellationList = dicValueService.queryDicValueByTypeCode(Constants.DIC_VALUE_APPELLATION);
        List<DicValue> clueStateList = dicValueService.queryDicValueByTypeCode(Constants.DIC_VALUE_CLUE_STATE);
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode(Constants.DIC_VALUE_SOURCE);

        request.setAttribute("userList",userList);
        request.setAttribute("appellationList",appellationList);
        request.setAttribute("clueStateList",clueStateList);
        request.setAttribute("sourceList",sourceList);

        // 请求转发
        return "workbench/clue/index";
    }

    /**
     * 保存创建的线索
     * @param clue
     * @param session
     * @return
     */
    @RequestMapping("/workbench/clue/saveCreateClue.do")
    public @ResponseBody Object saveCreateClue(Clue clue, HttpSession session) {
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();

        // 封装参数
        clue.setId(UUIDUtils.getUUID());
        clue.setCreateBy(user.getId());
        clue.setCreateTime(DateUtils.formatDateTime(new Date()));

        try {
            // 调用 service 层方法，保存创建的线索
            int ret = clueService.saveCreateClue(clue);

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

    @RequestMapping("/workbench/clue/queryClueByConditionForPage.do")
    public @ResponseBody Object queryClueByConditionForPage(String fullname, String owner, String company, String phone,
                                                            String mphone, String state, String source,
                                                            Integer pageNo, Integer pageSize) {
        // 封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("fullname",fullname);
        map.put("owner",owner);
        map.put("company",company);
        map.put("phone",phone);
        map.put("mphone",mphone);
        map.put("state",state);
        map.put("source",source);
        map.put("beginNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);

        // 调用 service 层方法，根据条件查询数据
        List<Clue> clueList = clueService.queryClueByConditionForPage(map);

        Integer totalRows = clueService.queryCountOfClueByCondition(map);

        // 根据查询结果，生成响应信息
        Map<String,Object> retMap = new HashMap<>();
        retMap.put("clueList",clueList);
        retMap.put("totalRows",totalRows);

        return retMap;
    }

    /**
     * 根据 id 数组删除线索
     * @param id
     * @return
     */
    @RequestMapping("/workbench/clue/deleteClueByIds.do")
    public @ResponseBody Object deleteClueByIds(String[] id) {

        ReturnObject returnObject = new ReturnObject();

        try {
            // 调用 service 层方法，删除市场活动
            int ret = clueService.deleteClueByIds(id);

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
     * 根据 id 查询某一条线索
     * @param id
     * @return
     */
    @RequestMapping("/workbench/clue/selectClueById.do")
    public @ResponseBody Object selectClueById(String id) {
        // 调用 service 层方法，查询线索
        // 根据查询结果，返回响应信息
        return clueService.queryClueById(id);
    }

    /**
     * 更新修改后的线索
     * @param clue
     * @param session
     * @return
     */
    @RequestMapping("/workbench/clue/saveEditClue.do")
    // 返回 json 数据，所以返回类型是 Object
    public @ResponseBody Object saveEditClue(Clue clue, HttpSession session) {

        // 从登录时保存在 session 中的 user 对象获取用户 id
        User user = (User) session.getAttribute(Constants.SESSION_USER);

        ReturnObject returnObject = new ReturnObject();

        // 补充前台没有的参数 edit_time、edit_by
        clue.setEditBy(user.getId());
        clue.setEditTime(DateUtils.formatDateTime(new Date()));

        try {
            // 调用 service 层方法，更新修改后的市场活动
            int ret = clueService.saveEditClue(clue);

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
     * 查询线索明细、备注、与线索相关联的市场活动
     * @param id
     * @param request
     * @return
     */
    @RequestMapping("/workbench/clue/detailClue.do")
    public String detailClue(String id,HttpServletRequest request) {
        // 调用 service 层方法，查询线索
        Clue clue = clueService.queryDetailClueById(id);
        List<ClueRemark> remarkList = clueRemarkService.queryClueRemarkForDetailByClueId(id);
        List<Activity> activityList = activityService.queryActivityForDetailByClueId(id);

        request.setAttribute("clue",clue);
        request.setAttribute("remarkList",remarkList);
        request.setAttribute("activityList",activityList);

        return "workbench/clue/detail";
    }

    /**
     * 根据市场活动名称模糊查询市场活动
     * 根据 clueId 查询与该线索相关联的市场活动，排除这些市场活动
     * 最终得到与该线索未关联的市场活动
     * @param activityName
     * @param clueId
     * @return
     */
    @RequestMapping("/workbench/clue/queryActivityForDetailByNameAndClueId.do")
    public @ResponseBody Object queryActivityForDetailByNameAndClueId(String activityName,String clueId) {
        // 封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("activityName",activityName);
        map.put("clueId",clueId);

        // 调用 service 层方法，查询市场活动
        // 直接返回 json 字符串
        return activityService.queryActivityForDetailByNameAndClueId(map);
    }

    /**
     * 保存线索关联市场活动关系，刷新已关联市场活动列表
     * @param activityId
     * @param clueId
     * @return
     */
    @RequestMapping("/workbench/clue/saveBindClueActivity.do")
    public @ResponseBody Object saveBindClueActivity(String[] activityId,String clueId) {

        List<ClueActivityRelation> relationList = new ArrayList<>();
        ReturnObject returnObject = new ReturnObject();

        // 封装参数
        for(String ai:activityId) {
            ClueActivityRelation car = new ClueActivityRelation();
            car.setId(UUIDUtils.getUUID());
            car.setActivityId(ai);
            car.setClueId(clueId);
            relationList.add(car);
        }

        try {
            // 调用 service 层方法，批量保存线索和市场活动的关联关系
            int ret = clueActivityRelationService.saveCreateClueActivityRelationByList(relationList);

            if(ret > 0) {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);

                // 调用 service 层方法，根据 id 数组查询与线索相关联的市场活动的明细信息
                List<Activity> activityList = activityService.queryActivityForDetailByIds(activityId);

                returnObject.setRetData(activityList);
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
     * 解除线索和市场活动的关联关系·
     * @param relation
     * @return
     */
    @RequestMapping("/workbench/clue/saveUnBindClueActivity.do")
    public @ResponseBody Object saveUnBindClueActivity(ClueActivityRelation relation) {
        ReturnObject returnObject = new ReturnObject();

        // 调用 service 层方法，删除线索和市场活动的关联关系
        try {
            int ret = clueActivityRelationService.deleteClueActivityRelationByClueIdAndActivityId(relation);

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
     * 查询线索的明细信息以及数据字典阶段的值转发至线索转换界面
     * @param id
     * @param request
     * @return
     */
    @RequestMapping("/workbench/clue/toConvert.do")
    public String toConvert(String id,HttpServletRequest request) {
        // 调用 service 层方法，查询线索的明细信息，直接使用前面的方法
        Clue clue = clueService.queryDetailClueById(id);
        List<DicValue> clueStageList = dicValueService.queryDicValueByTypeCode(Constants.DIC_VALUE_STAGE);

        request.setAttribute("clue",clue);
        request.setAttribute("clueStageList",clueStageList);

        return "workbench/clue/convert";
    }

    /**
     * 根据市场活动名称模糊查询市场活动 根据 clueId 查询与该线索相关联的市场活动
     * @param activityName
     * @param clueId
     * @return
     */
    @RequestMapping("/workbench/clue/queryActivityForConvertByNameAndClueId.do")
    public @ResponseBody Object queryActivityForConvertByNameAndClueId(String activityName,String clueId) {
        // 封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("activityName",activityName);
        map.put("clueId",clueId);

        // 调用 service 层方法，查询市场活动
        // 直接返回 json 字符串
        return activityService.queryActivityForConvertByNameAndClueId(map);
    }

    @RequestMapping("/workbench/clue/convertClue.do")
    public @ResponseBody Object convertClue(String clueId,String money,String name,String expectedDate,String stage,String activityId,String isCreateTran,HttpSession session) {
        ReturnObject returnObject = new ReturnObject();

        // 封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("clueId",clueId);
        map.put("money",money);
        map.put("name",name);
        map.put("expectedDate",expectedDate);
        map.put("stage",stage);
        map.put("activityId",activityId);
        map.put("isCreateTran",isCreateTran);
        map.put(Constants.SESSION_USER,session.getAttribute(Constants.SESSION_USER));

        try {
            // 调用 service 层方法，保存线索转换
            clueService.saveConvertClue(map);

            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        }catch (Exception e) {
            e.printStackTrace();

            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙，请稍后重试......");
        }

        return returnObject;
    }
}
