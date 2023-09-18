package org.example.crm.workbench.service;

import org.example.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkService {
    List<ClueRemark> queryClueRemarkForDetailByClueId(String clueId);

    int saveCreateClueRemark(ClueRemark remark);

    int deleteClueRemarkById(String id);

    int saveEditClueRemark(ClueRemark remark);
}
