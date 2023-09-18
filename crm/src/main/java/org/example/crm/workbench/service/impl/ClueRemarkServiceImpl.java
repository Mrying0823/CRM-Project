package org.example.crm.workbench.service.impl;

import org.example.crm.workbench.domain.ClueRemark;
import org.example.crm.workbench.mapper.ClueRemarkMapper;
import org.example.crm.workbench.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 通过将业务逻辑与数据访问层分开，可以使代码更加模块化和有组织性。
 * Service接口定义了一组业务方法，这使得在不了解底层数据访问细节的情况下可以理解和使用这些方法
 */
@Service("clueRemarkService")
public class ClueRemarkServiceImpl implements ClueRemarkService {
    /**
     * 是Spring框架中的依赖注入（Dependency Injection）的一部分。
     * 它的目的是将一个名为 clueRemarkMapper的bean（或组件）注入（或赋值）到一个类的成员变量中，
     * 以便在该类中可以使用 clueRemarkMapper 这个bean 的功能。
     */
    private ClueRemarkMapper clueRemarkMapper;

    @Autowired
    public void setClueRemarkMapper(ClueRemarkMapper clueRemarkMapper) {
        this.clueRemarkMapper = clueRemarkMapper;
    }

    @Override
    public List<ClueRemark> queryClueRemarkForDetailByClueId(String clueId) {
        return clueRemarkMapper.selectClueRemarkForDetailByClueId(clueId);
    }

    @Override
    public int saveCreateClueRemark(ClueRemark remark) {
        return clueRemarkMapper.insertClueRemark(remark);
    }

    @Override
    public int deleteClueRemarkById(String id) {
        return clueRemarkMapper.deleteClueRemarkById(id);
    }

    @Override
    public int saveEditClueRemark(ClueRemark remark) {
        return clueRemarkMapper.updateClueRemark(remark);
    }
}
