package org.example.crm.settings.web.interceptor;

import org.example.crm.commons.utils.contants.Constants;
import org.example.crm.settings.domain.User;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class LoginInterceptor implements HandlerInterceptor {

    //
    @Override
    public boolean preHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o) throws Exception {
        // 如果用户登录失败，跳转至登录界面
        HttpSession session = httpServletRequest.getSession(false);
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        if(user == null) {
            // 登录失败
            // 不能借助框架重定向
            // 重定向时，url 必须加项目名称
            // httpServletResponse.sendRedirect("/crm");
            // 动态重定向，httpServletRequest.getContextPath() 实际就是"/"+项目名称
            httpServletResponse.sendRedirect(httpServletRequest.getContextPath());
            return false;
        }
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, ModelAndView modelAndView) throws IOException {
    }

    @Override
    public void afterCompletion(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, Exception e) {

    }
}
