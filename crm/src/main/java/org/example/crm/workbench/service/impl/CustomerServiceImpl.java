package org.example.crm.workbench.service.impl;

import org.example.crm.workbench.domain.Customer;
import org.example.crm.workbench.mapper.CustomerMapper;
import org.example.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("customerService")
public class CustomerServiceImpl implements CustomerService {

    private CustomerMapper customerMapper;

    @Autowired
    public void setCustomerMapper(CustomerMapper customerMapper){
        this.customerMapper = customerMapper;
    }

    @Override
    public List<Customer> queryCustomerByConditionForPage(Map<String, Object> map) {
        return customerMapper.selectCustomerByConditionForPage(map);
    }

    @Override
    public int queryCountOfCustomerByCondition(Map<String, Object> map) {
        return customerMapper.selectCountOfCustomerByCondition(map);
    }

    @Override
    public List<Customer> queryCustomerByName(String name) {
        return customerMapper.selectCustomerByName(name);
    }

    @Override
    public int insertCustomer(Customer customer) {
        return customerMapper.insertCustomer(customer);
    }

    @Override
    public Customer queryCustomerForDetailById(String id) {
        return customerMapper.selectCustomerForDetailById(id);
    }

    @Override
    public Customer queryCustomerById(String id) {
        return customerMapper.selectCustomerById(id);
    }

    @Override
    public int saveEditCustomer(Customer customer) {
        return customerMapper.updateCustomer(customer);
    }
}
