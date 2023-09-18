package org.example.crm.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MainController {

    @RequestMapping("/workbench/main/index.do")
    public String index() {

        // 返回页面
        return "workbench/main/index";
    }
}
