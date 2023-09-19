package org.example.crm.workbench.web.controller;

import org.example.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class ChartsController {

    private TranService tranService;

    @Autowired
    public void setTranService(TranService tranService) {
        this.tranService = tranService;
    }

    @RequestMapping("/workbench/chart/tran/index.do")
    public String index() {
        return "workbench/chart/tran/index";
    }

    @RequestMapping("/workbench/chart/tran/queryCountOfTranGroupByStage.do")
    public @ResponseBody Object queryCountOfTranGroupByStage() {
        return tranService.queryCountOfTranGroupByStage();
    }
}
