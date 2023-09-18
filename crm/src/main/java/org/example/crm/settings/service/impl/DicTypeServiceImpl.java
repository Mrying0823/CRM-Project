package org.example.crm.settings.service.impl;

import org.example.crm.settings.domain.DicType;
import org.example.crm.settings.mapper.DicTypeMapper;
import org.example.crm.settings.service.DicTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service("dicTypeService")
public class DicTypeServiceImpl implements DicTypeService {
    private DicTypeMapper dicTypeMapper;

    // Setter 方法，用于注入 DictionaryTypeMapper
    @Autowired
    public void setDictionaryTypeMapper(DicTypeMapper dicTypeMapper) {
        this.dicTypeMapper = dicTypeMapper;
    }

    /**
     * 执行 INSERT 操作时，通常会返回一个表示受影响行数的整数值
     * 这个返回值可以用于确认插入操作是否成功
     */
    @Override
    public int queryDictionaryTypeByIdNameDescription(Map<String, Object> map) {
        return dicTypeMapper.insertIdNameDescriptionToDictionaryType(map);
    }

    // 返回 DictionaryType 对象
    @Override
    public DicType queryDictionaryTypeByNull() {
        return dicTypeMapper.selectAllFromDictionaryType();
    }
}
