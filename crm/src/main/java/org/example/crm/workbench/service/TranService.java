package org.example.crm.workbench.service;

import org.example.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranService {
    void saveCreateTran(Map<String,Object> map);

    List<Tran> queryTranByConditionForPage(Map<String,Object> map);

    int queryCountOfTranByCondition(Map<String,Object> map);

    Tran queryTranForDetailById(String id);

    void saveEditTranStage(Map<String,Object> map);
}
