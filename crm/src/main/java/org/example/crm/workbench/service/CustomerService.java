package org.example.crm.workbench.service;

import org.example.crm.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerService {
    List<Customer> queryCustomerByConditionForPage(Map<String,Object> map);

    int queryCountOfCustomerByCondition(Map<String,Object> map);

    List<Customer> queryCustomerByName(String name);

    int insertCustomer(Customer customer);

    Customer queryCustomerForDetailById(String id);
}
