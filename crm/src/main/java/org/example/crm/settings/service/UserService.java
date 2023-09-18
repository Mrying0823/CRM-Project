package org.example.crm.settings.service;

import org.example.crm.settings.domain.User;

import java.util.List;
import java.util.Map;

// 选中接口，按alt+回车，选择实现接口
public interface UserService {
    User queryUserByLoginActAndPwd(Map<String,Object> map);

    List<User> queryAllUsers();
}
