package org.example.crm.workbench.web.controller;

import org.example.crm.commons.domain.ReturnObject;
import org.example.crm.commons.utils.DateUtils;
import org.example.crm.commons.utils.UUIDUtils;
import org.example.crm.commons.utils.contants.Constants;
import org.example.crm.settings.domain.DicValue;
import org.example.crm.settings.domain.User;
import org.example.crm.settings.service.DicValueService;
import org.example.crm.settings.service.UserService;
import org.example.crm.workbench.domain.Contacts;
import org.example.crm.workbench.domain.Customer;
import org.example.crm.workbench.service.ContactsService;
import org.example.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class ContactsController {

    private DicValueService dicValueService;

    private ContactsService contactsService;

    private UserService userService;

    private CustomerService customerService;

    @Autowired
    public void setDicValueService(DicValueService dicValueService) {
        this.dicValueService = dicValueService;
    }

    @Autowired
    public void setContactsService(ContactsService contactsService) {
        this.contactsService = contactsService;
    }

    @Autowired
    public void setUserService(UserService userService) {
        this.userService = userService;
    }

    @Autowired
    public void setCustomerService(CustomerService customerService) {
        this.customerService = customerService;
    }

    @RequestMapping("/workbench/contacts/index.do")
    public String index(HttpServletRequest request) {

        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode(Constants.DIC_VALUE_SOURCE);
        List<User> userList = userService.queryAllUsers();
        List<DicValue> appellationList = dicValueService.queryDicValueByTypeCode(Constants.DIC_VALUE_APPELLATION);

        request.setAttribute("sourceList",sourceList);
        request.setAttribute("userList",userList);
        request.setAttribute("appellationList",appellationList);

        return "workbench/contacts/index";
    }

    /**
     * 分页查询联系人
     * @param fullname
     * @param owner
     * @param customerId
     * @param source
     * @param pageNo
     * @param pageSize
     * @return
     */
    @RequestMapping("/workbench/contacts/queryContactsByConditionForPage.do")
    public @ResponseBody Object queryContactsByConditionForPage(String fullname, String owner, String customerId, String source,
                                                                int pageNo, int pageSize) {
        // 封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("fullname",fullname);
        map.put("owner",owner);
        map.put("customerId",customerId);
        map.put("source",source);
        map.put("beginNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);

        // 调用 service 层方法查询数据
        List<Contacts> contactsList = contactsService.queryContactsByConditionForPage(map);

        Integer totalRows = contactsService.queryCountOfContactsByCondition(map);

        // 根据查询结果，生成响应信息
        Map<String,Object> retMap = new HashMap<>();
        retMap.put("contactsList",contactsList);
        retMap.put("totalRows",totalRows);

        return retMap;
    }

    /**
     * 根据名字模糊查询客户
     * @param name
     * @return
     */
    @RequestMapping("/workbench/contacts/queryCustomerByName.do")
    public @ResponseBody Object queryCustomerByName(String name) {
        return customerService.queryCustomerByName(name);
    }

    /**
     * 保存创建的联系人
     * @param contacts
     * @param session
     * @return
     */
    @RequestMapping("/workbench/contacts/saveCreateContacts.do")
    public @ResponseBody Object saveCreateContacts(Contacts contacts, HttpSession session, String customerName) {

        ReturnObject returnObject = new ReturnObject();

        // 封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("contacts",contacts);
        map.put("customerName",customerName);
        map.put(Constants.SESSION_USER,session.getAttribute(Constants.SESSION_USER));

        try {
            // 调用 service 层方法，保存创建的联系人
            contactsService.saveCreateContacts(map);

            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        }catch (Exception e) {
            e.printStackTrace();

            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙，请稍后重试......");
        }

        return returnObject;
    }

    /**
     * 跳转至联系人明细界面
     * @param id
     * @param request
     * @return
     */
    @RequestMapping("/workbench/contacts/detailContacts.do")
    public String detailContacts(String id,HttpServletRequest request) {

        Contacts contacts = contactsService.queryContactsForDetailById(id);

        request.setAttribute("contacts",contacts);

        return "workbench/contacts/detail";
    }
}
