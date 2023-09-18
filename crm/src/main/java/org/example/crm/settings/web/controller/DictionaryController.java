package org.example.crm.settings.web.controller;

import org.example.crm.commons.domain.ReturnObject;
import org.example.crm.commons.utils.contants.Constants;
import org.example.crm.settings.service.DicTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

@Controller
public class DictionaryController {

    // url 要和 controller 方法处理完请求后，响应信息返回的页面的资源目录保持一致
    private DicTypeService dicTypeService;

    @Autowired
    public void setDictionaryTypeService(DicTypeService dicTypeService) {
        this.dicTypeService = dicTypeService;
    }

    // 数据字典主界面
    @RequestMapping("/settings/dictionary/index.do")
    public String toDictionaryIndex() {
        return "settings/dictionary/index";
    }

    // 数据字典类型主界面
    @RequestMapping("/settings/dictionary/type/index.do")
    public String toDictionaryTypeIndex() {
        return "settings/dictionary/type/index";
    }

    // 数据字典值主界面
    @RequestMapping("/settings/dictionary/value/index.do")
    public String toDictionaryValueIndex() {
        return "settings/dictionary/value/index";
    }

    // 数据字典类型创建
    @RequestMapping("/settings/dictionary/type/toSave.do")
    public String toDictionaryTypeSave() {
        return "settings/dictionary/type/save";
    }

    // 数据字典类型编辑
    @RequestMapping("/settings/dictionary/type/toEdit.do")
    public String toDictionaryTypeEdit() {
        return "settings/dictionary/type/edit";
    }

    // 数据字典值创建
    @RequestMapping("/settings/dictionary/value/toSave.do")
    public String toDictionaryValueSave() {
        return "settings/dictionary/value/save";
    }

    // 数据字典值编辑
    @RequestMapping("/settings/dictionary/value/toEdit.do")
    public String toDictionaryValueEdit() {
        return "settings/dictionary/value/edit";
    }

    // 模仿 UserController，将 code、name、description 插入数据库表
    @RequestMapping("/settings/dictionary/type/save.do")
    public @ResponseBody Object saveDictionaryType(String code, String name, String description) {

        // 封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("code",code);
        map.put("name",name);
        map.put("description",description);

        // 调用 service 层方法，插入数据
        int dictionaryType = dicTypeService.queryDictionaryTypeByIdNameDescription(map);

        // 根据插入结果，生成响应信息
        ReturnObject returnObject = new ReturnObject();

        if(dictionaryType > 0) {
            // 插入成功
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            returnObject.setMessage("插入成功");
        }else {
            // 插入失败
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("插入失败");
        }

        // 前端 ajax 可获取到
        return returnObject;
    }

    // 查询数据字典类型数据
/*    @RequestMapping("/settings/dictionary/type/get.do")
    public String getDictionaryType(HttpSession session) {
        // 无需参数

        // 调用 service 层方法，查询数据
        DictionaryType dictionaryType = dictionaryTypeService.queryDictionaryTypeByNull();

        if(dictionaryType != null) {
            // 把 user 保存至 session
            session.setAttribute(Constants.SESSION_DICTIONARY_TYPE,dictionaryType);
        }

        // 前端 ajax 可获取到
        return "/settings/dictionary/type/index.do";
    }*/
}
