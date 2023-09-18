package org.example.crm.workbench.web.controller;

import org.example.crm.commons.domain.ReturnObject;
import org.example.crm.commons.utils.DateUtils;
import org.example.crm.commons.utils.UUIDUtils;
import org.example.crm.commons.utils.contants.Constants;
import org.example.crm.settings.domain.User;
import org.example.crm.workbench.domain.ClueRemark;
import org.example.crm.workbench.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
public class ClueRemarkController {
    private ClueRemarkService clueRemarkService;

    @Autowired
    public void setClueRemarkService(ClueRemarkService clueRemarkService) {
        this.clueRemarkService = clueRemarkService;
    }

    /**
     * 保存创建的线索备注
     * @param remark
     * @param session
     * @return
     */
    @RequestMapping("workbench/clue/saveCreateClueRemark.do")
    public @ResponseBody Object saveCreateClueRemark(ClueRemark remark, HttpSession session) {

        User user = (User) session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();

        // 封装参数
        remark.setId(UUIDUtils.getUUID());
        remark.setCreateBy(user.getId());
        remark.setCreateTime(DateUtils.formatDateTime(new Date()));
        remark.setEditFlag(Constants.REMARK_EDIT_FLAG_NO_EDITED);

        try {
            // 调用 service 层方法，保存线索备注
            int ret = clueRemarkService.saveCreateClueRemark(remark);

            if(ret > 0) {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(remark);
            } else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙，请稍后重试......");
            }
        }catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙，请稍后重试......");
        }

        return returnObject;
    }

    /**
     * 删除线索备注
     * @param id
     * @return
     */
    @RequestMapping("/workbench/clue/deleteClueRemarkById.do")
    public @ResponseBody Object deleteClueRemarkById(String id) {

        ReturnObject returnObject = new ReturnObject();

        try {
            // 调用 service 层方法，删除线索备注
            int ret = clueRemarkService.deleteClueRemarkById(id);

            if(ret > 0) {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            } else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙，请稍后重试......");
            }
        }catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙，请稍后重试......");
        }
        return returnObject;
    }

    /**
     * 更新线索备注
     * @param remark
     * @param session
     * @return
     */
    @RequestMapping("/workbench/clue/saveEditClueRemark.do")
    public @ResponseBody Object saveEditClueRemark(ClueRemark remark, HttpSession session) {
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();

        // 封装参数
        remark.setEditTime(DateUtils.formatDateTime(new Date()));
        remark.setEditBy(user.getId());
        remark.setEditFlag(Constants.REMARK_EDIT_FLAG_YES_EDITED);

        try {
            // 调用 service 层方法，保存修改的市场活动备注
            int ret = clueRemarkService.saveEditClueRemark(remark);

            if(ret > 0) {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(remark);
            } else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙，请稍后重试......");
            }
        }catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙，请稍后重试......");
        }

        return returnObject;
    }
}
