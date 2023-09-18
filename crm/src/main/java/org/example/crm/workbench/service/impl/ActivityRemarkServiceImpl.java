package org.example.crm.workbench.service.impl;

import org.example.crm.workbench.domain.ActivityRemark;
import org.example.crm.workbench.mapper.ActivityRemarkMapper;
import org.example.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("activityRemarkService")
public class ActivityRemarkServiceImpl implements ActivityRemarkService {

    private ActivityRemarkMapper activityRemarkMapper;

    @Autowired
    public void setActivityRemarkMapper(ActivityRemarkMapper activityRemarkMapper) {
        this.activityRemarkMapper = activityRemarkMapper;
    }

    @Override
    public List<ActivityRemark> queryActivityRemarkForDetailByActivityId(String activityId) {
        return activityRemarkMapper.selectActivityRemarkForDetailByActivityId(activityId);
    }

    @Override
    public int saveCreateActivityRemark(ActivityRemark remark) {
        return activityRemarkMapper.insertActivityRemark(remark);
    }

    @Override
    public int deleteActivityRemarkById(String id) {
        return activityRemarkMapper.deleteActivityRemarkById(id);
    }

    @Override
    public int saveEditActivityRemark(ActivityRemark remark) {
        return activityRemarkMapper.updateActivityRemark(remark);
    }
}
