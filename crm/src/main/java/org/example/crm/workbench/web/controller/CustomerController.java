package org.example.crm.workbench.web.controller;

import org.example.crm.commons.domain.ReturnObject;
import org.example.crm.commons.utils.DateUtils;
import org.example.crm.commons.utils.UUIDUtils;
import org.example.crm.commons.utils.contants.Constants;
import org.example.crm.settings.domain.User;
import org.example.crm.settings.service.UserService;
import org.example.crm.workbench.domain.Contacts;
import org.example.crm.workbench.domain.Customer;
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
public class CustomerController {

    private UserService userService;

    private CustomerService customerService;

    @Autowired
    public void setUserService(UserService userService) {
        this.userService = userService;
    }

    @Autowired
    public void setCustomerService(CustomerService customerService) {
        this.customerService = customerService;
    }

    @RequestMapping("/workbench/customer/index.do")
    public String index(HttpServletRequest request) {

        List<User> userList = userService.queryAllUsers();

        request.setAttribute("userList",userList);

        return "workbench/customer/index";
    }

    @RequestMapping("/workbench/customer/saveCreateCustomer.do")
    public @ResponseBody Object saveCreateCustomer(Customer customer, HttpSession session) {

        User user = (User) session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();

        // 补充前台没有的参数
        customer.setId(UUIDUtils.getUUID());
        customer.setCreateBy(user.getId());
        customer.setCreateTime(DateUtils.formatDateTime(new Date()));

        try {
            // 调用 service 层方法，保存创建的客户
            int ret = customerService.insertCustomer(customer);

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
     * 分页查询客户
     * @param name
     * @param owner
     * @param phone
     * @param website
     * @param pageNo
     * @param pageSize
     * @return
     */
    @RequestMapping("/workbench/customer/queryCustomerByConditionForPage.do")
    public @ResponseBody Object queryCustomerByConditionForPage(String name, String owner, String phone, String website,
                                                                int pageNo, int pageSize) {
        // 封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("phone",phone);
        map.put("website",website);
        map.put("beginNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);

        // 调用 service 层方法查询数据
        List<Customer> customerList = customerService.queryCustomerByConditionForPage(map);

        Integer totalRows = customerService.queryCountOfCustomerByCondition(map);

        // 根据查询结果，生成响应信息
        Map<String,Object> retMap = new HashMap<>();
        retMap.put("customerList",customerList);
        retMap.put("totalRows",totalRows);

        return retMap;
    }

    /**
     * 修改客户信息
     * @param id
     * @return
     */
    @RequestMapping("/workbench/customer/selectCustomerById.do")
    public @ResponseBody Object selectCustomerById(String id) {
        return customerService.queryCustomerById(id);
    }

    /**
     * 更新修改后的客户
     * @param customer
     * @param session
     * @return
     */
    @RequestMapping("/workbench/customer/saveEditCustomer.do")
    public @ResponseBody Object saveEditCustomer(Customer customer, HttpSession session) {

        User user = (User) session.getAttribute(Constants.SESSION_USER);

        ReturnObject returnObject = new ReturnObject();

        customer.setEditBy(user.getId());
        customer.setEditTime(DateUtils.formatDateTime(new Date()));

        try {
            int ret = customerService.saveEditCustomer(customer);

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
     * 跳转至客户明细界面
     * @param id
     * @param request
     * @return
     */
    @RequestMapping("/workbench/customer/detailCustomer.do")
    public String detailCustomer(String id, HttpServletRequest request) {

        Customer customer = customerService.queryCustomerForDetailById(id);

        request.setAttribute("customer",customer);

        return "workbench/customer/detail";
    }
}
