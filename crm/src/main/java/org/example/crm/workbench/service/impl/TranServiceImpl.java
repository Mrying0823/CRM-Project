package org.example.crm.workbench.service.impl;

import org.example.crm.commons.utils.DateUtils;
import org.example.crm.commons.utils.UUIDUtils;
import org.example.crm.commons.utils.contants.Constants;
import org.example.crm.settings.domain.User;
import org.example.crm.workbench.domain.Customer;
import org.example.crm.workbench.domain.Tran;
import org.example.crm.workbench.domain.TranHistory;
import org.example.crm.workbench.mapper.CustomerMapper;
import org.example.crm.workbench.mapper.TranHistoryMapper;
import org.example.crm.workbench.mapper.TranMapper;
import org.example.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Service("tranService")
public class TranServiceImpl implements TranService {

    private CustomerMapper customerMapper;

    private TranMapper tranMapper;

    private TranHistoryMapper tranHistoryMapper;

    @Autowired
    public void setCustomerMapper(CustomerMapper customerMapper) {
        this.customerMapper = customerMapper;
    }

    @Autowired
    public void setTranMapper(TranMapper tranMapper) {
        this.tranMapper = tranMapper;
    }

    @Autowired
    public void setTranHistoryMapper(TranHistoryMapper tranHistoryMapper) {
        this.tranHistoryMapper = tranHistoryMapper;
    }

    @Override
    @Transactional
    public void saveCreateTran(Map<String, Object> map) {

        String customerName = (String) map.get("customerName");
        User user = (User) map.get(Constants.SESSION_USER);
        Tran tran = (Tran) map.get("tran");

        // 根据 name 精确查询客户
        Customer customer = customerMapper.selectCustomerIdByName(customerName);

        if(customer == null) {
            customer = new Customer();
            customer.setId(UUIDUtils.getUUID());
            customer.setOwner(user.getId());
            customer.setName(customerName);
            customer.setCreateBy(user.getId());
            customer.setCreateTime(DateUtils.formatDateTime(new Date()));

            customerMapper.insertCustomer(customer);
        }

        // 保存创建的交易
        tran.setId(UUIDUtils.getUUID());
        tran.setCustomerId(customer.getId());
        tran.setCreateBy(user.getId());
        tran.setCreateTime(DateUtils.formatDateTime(new Date()));

        tranMapper.insertTran(tran);

        // 保存创建交易的历史
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtils.getUUID());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setStage(tran.getStage());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setCreateBy(user.getId());
        tranHistory.setCreateTime(DateUtils.formatDateTime(new Date()));
        tranHistory.setTranId(tran.getId());

        tranHistoryMapper.insertTranHistory(tranHistory);
    }

    @Override
    public List<Tran> queryTranByConditionForPage(Map<String, Object> map) {
        return tranMapper.selectTranByConditionForPage(map);
    }

    @Override
    public int queryCountOfTranByCondition(Map<String, Object> map) {
        return tranMapper.selectCountOfTranByCondition(map);
    }

    @Override
    public Tran queryTranForDetailById(String id) {
        return tranMapper.selectTranForDetailById(id);
    }

    @Override
    @Transactional
    public void saveEditTranStage(Map<String, Object> map) {
        Tran tran = (Tran) map.get("tran");
        TranHistory tranHistory = (TranHistory) map.get("tranHistory");

        tranMapper.updateTranStage(tran);

        tranHistoryMapper.insertTranHistory(tranHistory);
    }
}
