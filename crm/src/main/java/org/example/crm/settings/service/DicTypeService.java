package org.example.crm.settings.service;

import org.example.crm.settings.domain.DicType;

import java.util.Map;

public interface DicTypeService {
    int queryDictionaryTypeByIdNameDescription(Map<String, Object> map);

    DicType queryDictionaryTypeByNull();
}
