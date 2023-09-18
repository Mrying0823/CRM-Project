package org.example.crm.workbench.service.impl;

import org.example.crm.workbench.domain.TranRemark;
import org.example.crm.workbench.mapper.TranRemarkMapper;
import org.example.crm.workbench.service.TranRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("tranRemarkService")
public class TranRemarkServiceImpl implements TranRemarkService {

    private TranRemarkMapper tranRemarkMapper;

    @Autowired
    public void setTranRemarkMapper(TranRemarkMapper tranRemarkMapper) {
        this.tranRemarkMapper = tranRemarkMapper;
    }

    @Override
    public List<TranRemark> queryTranRemarkForDetailByTranId(String tranId) {
        return tranRemarkMapper.selectTranRemarkForDetailByTranId(tranId);
    }
}
