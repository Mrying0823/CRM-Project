package org.example.crm.workbench.service;

import org.example.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    int saveCreateActivity(Activity activity);

    List<Activity> queryActivityByConditionForPage(Map<String,Object> map);

    Integer queryCountOfActivityByCondition(Map<String,Object> map);

    int deleteActivityByIds(String[] ids);

    Activity queryActivityById(String id);

    int saveEditActivity(Activity activity);

    List<Activity> queryAllActivity();

    List<Activity> queryActivityByIds(String[] ids);

    int saveImportActivityByList(List<Activity> activityList);

    Activity queryDetailActivityById(String id);

    List<Activity> queryActivityForDetailByClueId(String clueId);

    List<Activity> queryActivityForDetailByNameAndClueId(Map<String,Object> map);

    List<Activity> queryActivityForDetailByIds(String[] ids);

    List<Activity> queryActivityForConvertByNameAndClueId(Map<String,Object> map);

    List<Activity> queryActivityForSaveByName(String name);
}
