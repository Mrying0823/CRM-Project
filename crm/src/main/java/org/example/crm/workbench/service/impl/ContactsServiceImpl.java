package org.example.crm.workbench.service.impl;

import org.example.crm.commons.utils.DateUtils;
import org.example.crm.commons.utils.UUIDUtils;
import org.example.crm.commons.utils.contants.Constants;
import org.example.crm.settings.domain.User;
import org.example.crm.workbench.domain.Contacts;
import org.example.crm.workbench.domain.Customer;
import org.example.crm.workbench.mapper.ContactsMapper;
import org.example.crm.workbench.mapper.CustomerMapper;
import org.example.crm.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Service("contactsService")
public class ContactsServiceImpl implements ContactsService {

    private ContactsMapper contactsMapper;

    private CustomerMapper customerMapper;

    @Autowired
    public void setContactsMapper(ContactsMapper contactsMapper) {
        this.contactsMapper = contactsMapper;
    }

    @Autowired
    public void setCustomerMapper(CustomerMapper customerMapper) {
        this.customerMapper = customerMapper;
    }

    @Override
    public List<Contacts> queryContactsByConditionForPage(Map<String, Object> map) {
        return contactsMapper.selectContactsByConditionForPage(map);
    }

    @Override
    public int queryCountOfContactsByCondition(Map<String, Object> map) {
        return contactsMapper.selectCountOfContactsByCondition(map);
    }

    @Override
    @Transactional
    public void saveCreateContacts(Map<String,Object> map) {

        Contacts contacts = (Contacts) map.get("contacts");
        User user = (User) map.get(Constants.SESSION_USER);
        String customerName = (String) map.get("customerName");

        // 如果从前端没有获取到 customerId，就创建一个新客户
        if(contacts.getCustomerId().equals("")) {
            Customer customer = new Customer();
            customer.setId(UUIDUtils.getUUID());
            customer.setOwner(user.getId());
            customer.setName(customerName);
            customer.setCreateBy(user.getId());
            customer.setCreateTime(DateUtils.formatDateTime(new Date()));

            contacts.setCustomerId(customer.getId());

            customerMapper.insertCustomer(customer);
        }

        // 封装参数
        contacts.setId(UUIDUtils.getUUID());
        contacts.setCreateBy(user.getId());
        contacts.setCreateTime(DateUtils.formatDateTime(new Date()));

        contactsMapper.insertContacts(contacts);
    }

    @Override
    public Contacts queryContactsForDetailById(String id) {
        return contactsMapper.selectContactsForDetailById(id);
    }

    @Override
    public List<Contacts> queryContactsForSaveByName(String name) {
        return contactsMapper.selectContactsForSaveByName(name);
    }
}
