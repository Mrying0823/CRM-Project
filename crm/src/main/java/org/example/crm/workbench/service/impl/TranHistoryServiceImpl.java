package org.example.crm.workbench.service.impl;

import org.example.crm.workbench.domain.TranHistory;
import org.example.crm.workbench.mapper.TranHistoryMapper;
import org.example.crm.workbench.service.TranHistoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("tranHistoryService")
public class TranHistoryServiceImpl implements TranHistoryService {

    private TranHistoryMapper tranHistoryMapper;

    @Autowired
    public void setTranHistoryMapper(TranHistoryMapper tranHistoryMapper) {
        this.tranHistoryMapper = tranHistoryMapper;
    }

    @Override
    public List<TranHistory> queryTranHistoryForDetailByTranId(String tranId) {
        return tranHistoryMapper.selectTranHistoryForDetailByTranId(tranId);
    }
}
