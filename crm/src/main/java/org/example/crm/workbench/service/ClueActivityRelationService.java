package org.example.crm.workbench.service;

import org.example.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationService {
    int saveCreateClueActivityRelationByList(List<ClueActivityRelation> list);
    int deleteClueActivityRelationByClueIdAndActivityId(ClueActivityRelation relation);
}
