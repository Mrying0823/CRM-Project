package org.example.crm.workbench.service.impl;

import org.example.crm.workbench.domain.ClueActivityRelation;
import org.example.crm.workbench.mapper.ClueActivityRelationMapper;
import org.example.crm.workbench.service.ClueActivityRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("clueActivityRelationService")
public class ClueActivityRelationServiceImpl implements ClueActivityRelationService {

    private ClueActivityRelationMapper clueActivityRelationMapper;

    @Autowired
    public void setClueActivityRelationMapper(ClueActivityRelationMapper clueActivityRelationMapper) {
        this.clueActivityRelationMapper = clueActivityRelationMapper;
    }

    @Override
    public int saveCreateClueActivityRelationByList(List<ClueActivityRelation> list) {
        return clueActivityRelationMapper.insertClueActivityRelationByList(list);
    }

    @Override
    public int deleteClueActivityRelationByClueIdAndActivityId(ClueActivityRelation relation) {
        return clueActivityRelationMapper.deleteClueActivityRelationByClueIdAndActivityId(relation);
    }
}
