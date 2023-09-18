package org.example.crm.settings.service;

import org.example.crm.settings.domain.DicValue;

import java.util.List;

public interface DicValueService {
    List<DicValue> queryDicValueByTypeCode(String typeCode);

    DicValue queryStageNameById(String id);
}
