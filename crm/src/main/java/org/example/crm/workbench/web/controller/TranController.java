package org.example.crm.workbench.web.controller;

import org.example.crm.commons.domain.ReturnObject;
import org.example.crm.commons.utils.DateUtils;
import org.example.crm.commons.utils.UUIDUtils;
import org.example.crm.commons.utils.contants.Constants;
import org.example.crm.settings.domain.DicValue;
import org.example.crm.settings.domain.User;
import org.example.crm.settings.service.DicValueService;
import org.example.crm.settings.service.UserService;
import org.example.crm.workbench.domain.Tran;
import org.example.crm.workbench.domain.TranHistory;
import org.example.crm.workbench.domain.TranRemark;
import org.example.crm.workbench.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
public class TranController {

    private DicValueService dicValueService;

    private UserService userService;

    private ContactsService contactsService;

    private ActivityService activityService;

    private CustomerService customerService;

    private TranService tranService;

    private TranRemarkService tranRemarkService;

    private TranHistoryService tranHistoryService;

    @Autowired
    public void setDicValueService(DicValueService dicValueService) {
        this.dicValueService = dicValueService;
    }

    @Autowired
    public void setUserService(UserService userService) {
        this.userService = userService;
    }

    @Autowired
    public void setContactsService(ContactsService contactsService) {
        this.contactsService = contactsService;
    }

    @Autowired
    public void setActivityService(ActivityService activityService) {
        this.activityService = activityService;
    }

    @Autowired
    public void setCustomerService(CustomerService customerService) {
        this.customerService = customerService;
    }

    @Autowired
    public void setTranService(TranService tranService) {
        this.tranService = tranService;
    }

    @Autowired
    public void setTranRemarkService(TranRemarkService tranRemarkService) {
        this.tranRemarkService = tranRemarkService;
    }

    @Autowired
    public void setTranHistoryService(TranHistoryService tranHistoryService) {
        this.tranHistoryService = tranHistoryService;
    }

    @RequestMapping("/workbench/tran/index.do")
    public String index(HttpServletRequest request) {

        List<DicValue> tranTypeList = dicValueService.queryDicValueByTypeCode(Constants.DIC_VALUE_TRANSACTION_TYPE);
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode(Constants.DIC_VALUE_SOURCE);
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode(Constants.DIC_VALUE_STAGE);

        request.setAttribute("tranTypeList",tranTypeList);
        request.setAttribute("sourceList",sourceList);
        request.setAttribute("stageList",stageList);

        return "workbench/tran/index";
    }

    @RequestMapping("/workbench/tran/queryTranByConditionForPage.do")
    public @ResponseBody Object queryTranByConditionForPage(String owner, String name, String customerId, String stage,
                                                                String type, String source, String contactsId,
                                                                int pageNo, int pageSize) {
        // 封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("customerId",customerId);
        map.put("source",source);
        map.put("type",type);
        map.put("contactsId",contactsId);
        map.put("stage",stage);
        map.put("beginNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);

        // 调用 service 层方法查询数据
        List<Tran> tranList = tranService.queryTranByConditionForPage(map);

        Integer totalRows = tranService.queryCountOfTranByCondition(map);

        // 根据查询结果，生成响应信息
        Map<String,Object> retMap = new HashMap<>();
        retMap.put("tranList",tranList);
        retMap.put("totalRows",totalRows);

        return retMap;
    }

    @RequestMapping("/workbench/tran/toSave.do")
    public String toSave(HttpServletRequest request) {

        List<DicValue> tranTypeList = dicValueService.queryDicValueByTypeCode(Constants.DIC_VALUE_TRANSACTION_TYPE);
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode(Constants.DIC_VALUE_SOURCE);
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode(Constants.DIC_VALUE_STAGE);
        List<User> userList = userService.queryAllUsers();

        request.setAttribute("tranTypeList",tranTypeList);
        request.setAttribute("sourceList",sourceList);
        request.setAttribute("stageList",stageList);
        request.setAttribute("userList",userList);

        return "workbench/tran/save";
    }

    /**
     * 根据 name 模糊查询联系人
     * @param name
     * @return
     */
    @RequestMapping("/workbench/tran/queryContactsForSaveByName.do")
    public @ResponseBody Object queryContactsForSaveByName(String name) {
        return contactsService.queryContactsForSaveByName(name);
    }

    /**
     * 根据 name 模糊查询市场活动
     * @param name
     * @return
     */
    @RequestMapping("/workbench/tran/queryActivityForSaveByName.do")
    public @ResponseBody Object queryActivityForSaveByName(String name) {
        return activityService.queryActivityForSaveByName(name);
    }

    @RequestMapping("/workbench/tran/getPossibilityByStage.do")
    public @ResponseBody Object getPossibilityByStage(String id) {
        // 解析 properties 配置文件
        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        return bundle.getString(id);
    }

    @RequestMapping("/workbench/tran/queryCustomerForSaveByName.do")
    public @ResponseBody Object queryCustomerForSaveByName(String name) {
        return customerService.queryCustomerByName(name);
    }

    /**
     * 根据选中的客户名称精确查询客户的 Id
     * @param customerName
     * @return
     */
    @RequestMapping("/workbench/tran/saveCreateTran.do")
    public @ResponseBody Object saveCreateTran(Tran tran, String customerName, HttpSession session) {

        ReturnObject returnObject = new ReturnObject();

        Map<String,Object> map = new HashMap<>();
        map.put(Constants.SESSION_USER,session.getAttribute(Constants.SESSION_USER));
        map.put("tran",tran);
        map.put("customerName",customerName);

        try {
            tranService.saveCreateTran(map);

            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        }catch (Exception e) {
            e.printStackTrace();

            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙，请稍后重试......");
        }

        return returnObject;
    }

    @RequestMapping("/workbench/tran/detailTran.do")
    public String detailTran(String id, HttpServletRequest request) {
        // 调用 service 层方法，查询数据
        Tran tran = tranService.queryTranForDetailById(id);
        List<TranRemark> tranRemarkList = tranRemarkService.queryTranRemarkForDetailByTranId(id);
        List<TranHistory> tranHistoryList = tranHistoryService.queryTranHistoryForDetailByTranId(id);

        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        tran.setPossibility(bundle.getString(tran.getStageId()));
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode(Constants.DIC_VALUE_STAGE);

        request.setAttribute("tran",tran);
        request.setAttribute("tranRemarkList",tranRemarkList);
        request.setAttribute("tranHistoryList",tranHistoryList);
        request.setAttribute("stageList",stageList);

        return "workbench/tran/detail";
    }

    /**
     * 保存交易修改阶段
     * @param tran
     * @param session
     * @return
     */
    @RequestMapping("/workbench/tran/saveEditTranStage.do")
    public @ResponseBody Object saveEditTranStage(Tran tran, HttpSession session) {
        ReturnObject returnObject = new ReturnObject();

        User user = (User) session.getAttribute(Constants.SESSION_USER);

        TranHistory tranHistory = new TranHistory();

        tranHistory.setId(UUIDUtils.getUUID());
        // 使用拓展属性，stageId 表示更明白
        // 为了尽可能避免不必要的数据库查询
        tranHistory.setStage(tran.getStageId());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setCreateBy(user.getId());
        tranHistory.setCreateTime(DateUtils.formatDateTime(new Date()));
        tranHistory.setTranId(tran.getId());
        tranHistory.setCreateByName(user.getName());

        Map<String,Object> map = new HashMap<>();
        map.put("tran",tran);
        map.put("tranHistory",tranHistory);

        try {
            tranService.saveEditTranStage(map);

            DicValue stage = dicValueService.queryStageNameById(tran.getStageId());

            ResourceBundle bundle = ResourceBundle.getBundle("possibility");
            String possibility = bundle.getString(tran.getStageId());

            // 根据查询结果，生成响应信息
            Map<String,Object> retMap = new HashMap<>();

            retMap.put("tranHistory",tranHistory);
            retMap.put("stageName",stage.getValue());
            retMap.put("possibility",possibility);

            returnObject.setRetData(retMap);

            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        }catch (Exception e) {
            e.printStackTrace();

            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙，请稍后重试......");
        }

        return returnObject;
    }
}
