package org.example.crm.workbench.service.impl;

import org.example.crm.commons.utils.DateUtils;
import org.example.crm.commons.utils.UUIDUtils;
import org.example.crm.commons.utils.contants.Constants;
import org.example.crm.settings.domain.User;
import org.example.crm.workbench.domain.*;
import org.example.crm.workbench.mapper.*;
import org.example.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service("clueService")
public class ClueServiceImpl implements ClueService {
    private ClueMapper clueMapper;

    private CustomerMapper customerMapper;

    private ContactsMapper contactsMapper;

    private ClueRemarkMapper clueRemarkMapper;

    private CustomerRemarkMapper customerRemarkMapper;

    private ContactsRemarkMapper contactsRemarkMapper;

    private ClueActivityRelationMapper clueActivityRelationMapper;

    private ContactsActivityRelationMapper contactsActivityRelationMapper;

    private TranMapper tranMapper;

    private TranRemarkMapper tranRemarkMapper;

    @Autowired
    public void setClueMapper(ClueMapper clueMapper) {
        this.clueMapper = clueMapper;
    }

    @Autowired
    public void setCustomerMapper(CustomerMapper customerMapper) {
        this.customerMapper = customerMapper;
    }

    @Autowired
    public void setContactsMapper(ContactsMapper contactsMapper) {
        this.contactsMapper = contactsMapper;
    }

    @Autowired
    public void setClueRemarkMapper(ClueRemarkMapper clueRemarkMapper) {
        this.clueRemarkMapper = clueRemarkMapper;
    }

    @Autowired
    public void setCustomerRemarkMapper(CustomerRemarkMapper customerRemarkMapper) {
        this.customerRemarkMapper = customerRemarkMapper;
    }

    @Autowired
    public void setContactsRemarkMapper(ContactsRemarkMapper contactsRemarkMapper) {
        this.contactsRemarkMapper = contactsRemarkMapper;
    }

    @Autowired
    public void setClueActivityRelationMapper(ClueActivityRelationMapper clueActivityRelationMapper) {
        this.clueActivityRelationMapper = clueActivityRelationMapper;
    }

    @Autowired
    public void setContactsActivityRelationMapper(ContactsActivityRelationMapper contactsActivityRelationMapper) {
        this.contactsActivityRelationMapper = contactsActivityRelationMapper;
    }

    @Autowired
    public void setTranMapper(TranMapper tranMapper) {
        this.tranMapper = tranMapper;
    }

    @Autowired
    public void setTranRemarkMapper(TranRemarkMapper tranRemarkMapper) {
        this.tranRemarkMapper = tranRemarkMapper;
    }

    @Override
    public int saveCreateClue(Clue clue) {
        return clueMapper.insertClue(clue);
    }

    @Override
    public List<Clue> queryClueByConditionForPage(Map<String, Object> map) {
        return clueMapper.selectClueByConditionForPage(map);
    }

    @Override
    public Integer queryCountOfClueByCondition(Map<String, Object> map) {
        return clueMapper.selectCountOfClueByCondition(map);
    }

    @Override
    public int deleteClueByIds(String[] ids) {
        return clueMapper.deleteClueByIds(ids);
    }

    @Override
    public Clue queryClueById(String id) {
        return clueMapper.selectClueById(id);
    }

    @Override
    public int saveEditClue(Clue clue) {
        return clueMapper.updateClue(clue);
    }

    @Override
    public Clue queryDetailClueById(String id) {
        return clueMapper.selectDetailClueById(id);
    }

    @Override
    @Transactional
    public void saveConvertClue(Map<String, Object> map) {
        String clueId = (String) map.get("clueId");
        User user = (User) map.get(Constants.SESSION_USER);
        String money = (String) map.get("money");
        String name = (String) map.get("name");
        String expectedDate = (String) map.get("expectedDate");
        String stage = (String) map.get("stage");
        String activityId = (String) map.get("activityId");
        String isCreateTran = (String) map.get("isCreateTran");

        // 根据 id 查询线索明细
        Clue clue = clueMapper.selectClueById(clueId);

        // 把该线索中有关公司的信息转换到客户表中
        Customer customer = new Customer();
        customer.setId(UUIDUtils.getUUID());
        customer.setOwner(user.getId());
        customer.setName(clue.getCompany());
        customer.setWebsite(clue.getWebsite());
        customer.setPhone(clue.getPhone());
        customer.setCreateBy(user.getId());
        customer.setCreateTime(DateUtils.formatDateTime(new Date()));
        customer.setContactSummary(clue.getContactSummary());
        customer.setNextContactTime(clue.getNextContactTime());
        customer.setDescription(clue.getDescription());
        customer.setAddress(clue.getAddress());

        customerMapper.insertCustomer(customer);

        // 把线索有关个人的信息转换到联系人表中
        Contacts contacts = new Contacts();
        contacts.setId(UUIDUtils.getUUID());
        contacts.setOwner(user.getId());
        contacts.setSource(clue.getSource());
        contacts.setCustomerId(customer.getId());
        contacts.setFullname(clue.getFullname());
        contacts.setAppellation(clue.getAppellation());
        contacts.setEmail(clue.getEmail());
        contacts.setMphone(clue.getMphone());
        contacts.setJob(clue.getJob());
        contacts.setCreateBy(user.getId());
        contacts.setCreateTime(DateUtils.formatDateTime(new Date()));
        contacts.setDescription(clue.getDescription());
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setAddress(clue.getAddress());

        contactsMapper.insertContacts(contacts);

        // 编写根据 clue_id 查询线索备注，把该线索下所有的备注转换到客户备注表
        List<ClueRemark> clueRemarkList = clueRemarkMapper.selectClueRemarkByClueId(clueId);
        List<CustomerRemark> customerRemarkList = new ArrayList<>();
        List<ContactsRemark> contactsRemarkList = new ArrayList<>();

        // 把该线索下所有的备注转换到客户备注表
        // 把该线索下所有的备注转换到联系人备注表中
        if(clueRemarkList != null && clueRemarkList.size() > 0) {
            // 遍历线索备注列表，封装客户备注
            for(ClueRemark clueRemark:clueRemarkList) {
                CustomerRemark customerRemark = new CustomerRemark();
                customerRemark.setId(UUIDUtils.getUUID());
                customerRemark.setNoteContent(clueRemark.getNoteContent());
                customerRemark.setCreateBy(user.getId());
                customerRemark.setCreateTime(DateUtils.formatDateTime(new Date()));
                customerRemark.setEditBy(clueRemark.getEditBy());
                customerRemark.setEditTime(clueRemark.getEditTime());
                customerRemark.setEditFlag(clueRemark.getEditFlag());
                customerRemark.setCustomerId(customer.getId());

                customerRemarkList.add(customerRemark);

                ContactsRemark contactsRemark = new ContactsRemark();
                contactsRemark.setId(UUIDUtils.getUUID());
                contactsRemark.setNoteContent(clueRemark.getNoteContent());
                contactsRemark.setCreateBy(user.getId());
                contactsRemark.setCreateTime(DateUtils.formatDate(new Date()));
                contactsRemark.setEditBy(clueRemark.getEditBy());
                contactsRemark.setEditTime(clueRemark.getEditTime());
                contactsRemark.setEditFlag(clueRemark.getEditFlag());
                contactsRemark.setContactsId(contacts.getId());

                contactsRemarkList.add(contactsRemark);
            }

            customerRemarkMapper.insertCustomerRemarkByList(customerRemarkList);

            contactsRemarkMapper.insertContactsRemarkByList(contactsRemarkList);
        }

        // 根据 clueId 查询线索和市场活动的关联关系
        List<ClueActivityRelation> clueActivityRelationList = clueActivityRelationMapper.selectClueActivityRelationByClueId(clueId);
        List<ContactsActivityRelation> cARelationList = new ArrayList<>();

        // 把线索和市场活动的关联关系转换到联系人和市场活动的关联关系表中
        if(clueActivityRelationList != null && clueActivityRelationList.size() > 0) {
            // 遍历线索和市场关联关系列表，封装联系人和市场活动关联关系
            for(ClueActivityRelation clueActivityRelation:clueActivityRelationList) {
                ContactsActivityRelation cARelation = new ContactsActivityRelation();
                cARelation.setId(UUIDUtils.getUUID());
                cARelation.setContactsId(contacts.getId());
                cARelation.setActivityId(clueActivityRelation.getActivityId());

                cARelationList.add(cARelation);
            }

            contactsActivityRelationMapper.insertContactsActivityRelationByList(cARelationList);
        }

        if(isCreateTran.equals("true")) {
            // 创建交易，往交易表中添加一条记录
            Tran tran = new Tran();
            tran.setId(UUIDUtils.getUUID());
            tran.setOwner(user.getId());
            tran.setMoney(money);
            tran.setName(name);
            tran.setExpectedDate(expectedDate);
            tran.setCustomerId(customer.getId());
            tran.setStage(stage);
            tran.setActivityId(activityId);
            tran.setContactsId(contacts.getId());
            tran.setCreateBy(user.getId());
            tran.setCreateTime(DateUtils.formatDateTime(new Date()));

            tranMapper.insertTran(tran);

            // 把线索的备注信息转换到交易备注表
            if(clueRemarkList != null && clueRemarkList.size() != 0) {

                List<TranRemark> tranRemarkList = new ArrayList<>();

                for(ClueRemark clueRemark:clueRemarkList) {
                    TranRemark tranRemark = new TranRemark();
                    tranRemark.setId(UUIDUtils.getUUID());
                    tranRemark.setNoteContent(clueRemark.getNoteContent());
                    tranRemark.setCreateBy(user.getId());
                    tranRemark.setCreateTime(clueRemark.getCreateTime());
                    tranRemark.setEditBy(clueRemark.getEditBy());
                    tranRemark.setEditTime(clueRemark.getEditTime());
                    tranRemark.setEditFlag(clueRemark.getEditFlag());
                    tranRemark.setTranId(tran.getId());

                    tranRemarkList.add(tranRemark);
                }

                tranRemarkMapper.insertTranRemarkByList(tranRemarkList);
            }
        }

        // 删除与线索有关的所有备注
        clueRemarkMapper.deleteClueRemarkByClueId(clueId);

        // 删除线索和市场活动的关联关系
        clueActivityRelationMapper.deleteClueActivityRelationByClueId(clueId);

        // 删除线索
        clueMapper.deleteClueById(clueId);
    }
}
