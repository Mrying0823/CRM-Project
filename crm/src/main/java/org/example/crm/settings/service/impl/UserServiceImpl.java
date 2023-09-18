package org.example.crm.settings.service.impl;

import org.example.crm.settings.domain.User;
import org.example.crm.settings.mapper.UserMapper;
import org.example.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("userService")
//实现接口类
public class UserServiceImpl implements UserService {

    private UserMapper userMapper;

    // Setter方法，用于注入UserMapper
    @Autowired
    public void setUserMapper(UserMapper userMapper) {
        this.userMapper = userMapper;
    }

    @Override
    public User queryUserByLoginActAndPwd(Map<String, Object> map) {
        return userMapper.selectUserByLoginActAndPwd(map);
    }

    // Alt+Insert 快速引入方法
    @Override
    public List<User> queryAllUsers() {
        return userMapper.selectAllUsers();
    }
}
