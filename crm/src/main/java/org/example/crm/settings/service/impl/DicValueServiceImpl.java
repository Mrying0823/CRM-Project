package org.example.crm.settings.service.impl;

import org.example.crm.settings.domain.DicValue;
import org.example.crm.settings.mapper.DicValueMapper;
import org.example.crm.settings.service.DicValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("dicValueService")
public class DicValueServiceImpl implements DicValueService {
    private DicValueMapper dicValueMapper;

    @Autowired
    public void setDicValueMapper(DicValueMapper dicValueMapper) {
        this.dicValueMapper = dicValueMapper;
    }


    @Override
    public List<DicValue> queryDicValueByTypeCode(String typeCode) {
        return dicValueMapper.selectDicValueByTypeCode(typeCode);
    }

    @Override
    public DicValue queryStageNameById(String id) {
        return dicValueMapper.selectStageNameById(id);
    }
}
