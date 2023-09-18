package org.example.crm.settings.web.controller;

import org.example.crm.commons.domain.ReturnObject;
import org.example.crm.commons.utils.MD5Utils;
import org.example.crm.commons.utils.DateUtils;
import org.example.crm.commons.utils.contants.Constants;
import org.example.crm.settings.domain.User;
import org.example.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
public class UserController {

    // url 要和 controller 方法处理完请求后，响应信息返回的页面的资源目录保持一致
    private UserService userService;

    @Autowired
    public void setUserService(UserService userService) {
        this.userService = userService;
    }

    @RequestMapping("/settings/qx/user/toLogin.do")
    public String toLogin() {
        return "settings/qx/user/login";
    }

    @RequestMapping("/settings/qx/user/login.do")
    public @ResponseBody Object login(String loginAct, String loginPwd, HttpServletRequest request, HttpSession session) {

        // 进行二次加密
        loginPwd = MD5Utils.encrypt(loginPwd);

        // 封装参数，isRemPwd 不在 sql 语句中，不需要进行封装
        Map<String,Object> map = new HashMap<>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);

        // 调用 service 层方法，查询用户
        User user = userService.queryUserByLoginActAndPwd(map);

        // 根据查询结果，生成响应信息
        ReturnObject returnObject = new ReturnObject();

        if(user == null) {
            // 登录失败，用户名或密码错误
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("用户名或密码错误");
        }else {
            // 判断账号是否合法
            // 最大过期时间
            // user.getExpireTime() 获取 user 对象的过期时间
            // new Date() 当前时间
            String nowStr = DateUtils. formatDateTime(new Date());

            /*
               "!=" 判断过期时间是否和当前时间相同，也就是判断用户的过期时间是否在当前时间之后
               ">" 判断条件是判断当前时间是否晚于用户的过期时间
               二者不等同
             */
            if(nowStr.compareTo(user.getExpireTime()) > 0) {
                // 登录失败，账号已过期
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("账号已过期");
            }else if("0".equals(user.getLockState())) {
                // 登录失败，状态被锁定
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("状态被锁定");
            }else if(!user.getAllowIps().contains(request.getRemoteAddr())) {

                /*
                   登录失败，IP 受限
                   判断当前请求的来源IP地址是否在 User 对象的允许IP列表中
                   这通常用于实现IP白名单功能，即只允许特定IP地址的用户访问某些敏感或特定的资源或接口
                   在实际应用中，为了增强安全性，可能会采取更复杂的授权和认证机制
                 */
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("IP 受限");
            }else {
                // 登录成功
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setMessage("登录成功");

                // 把 user 保存至 session
                session.setAttribute(Constants.SESSION_USER,user);
            }
        }

        // 前端 ajax 可获取到
        return returnObject;
    }

    @RequestMapping("/settings/qx/user/logout.do")
    public String logout(HttpSession session) {
        // 清空 cookie，新建相应名称 cookie 的值为 1，设置 cookie 过期时间为 0

        // 销毁 session
        session.invalidate();

        // 跳转到首页，重定向
        // 借助 SpringMVC 重定向，SpringMVC 会自动加上路径 response.sendRedirect("/crm/")
        return "redirect:/";
    }
}
