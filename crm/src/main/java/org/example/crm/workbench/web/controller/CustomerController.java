package org.example.crm.workbench.web.controller;

import org.example.crm.workbench.domain.Contacts;
import org.example.crm.workbench.domain.Customer;
import org.example.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class CustomerController {

    private CustomerService customerService;

    @Autowired
    public void setCustomerService(CustomerService customerService) {
        this.customerService = customerService;
    }

    @RequestMapping("/workbench/customer/index.do")
    public String index() {
        return "workbench/customer/index";
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
