package org.example.crm.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class WorkbenchIndexController {
    // 跳转业务主界面
    @RequestMapping("/workbench/index.do")
    public String index() {
        return "workbench/index";
    }
}
