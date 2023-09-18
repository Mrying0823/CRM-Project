package org.example.crm.workbench.service;

import org.example.crm.workbench.domain.TranHistory;

import java.util.List;

public interface TranHistoryService {
    List<TranHistory> queryTranHistoryForDetailByTranId(String tranId);
}
