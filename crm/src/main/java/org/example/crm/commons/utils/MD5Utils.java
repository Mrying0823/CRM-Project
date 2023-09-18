package org.example.crm.commons.utils;

import org.example.crm.commons.utils.contants.Constants;

import javax.xml.bind.DatatypeConverter;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class MD5Utils {
    public static String encrypt(String data) {
        try {
            // 使用MD5算法进行加密
            MessageDigest md = MessageDigest.getInstance("MD5");
            md.update(data.getBytes());
            byte[] digest = md.digest();

            // 将加密后的byte数组转换成十六进制字符串
            return DatatypeConverter.printHexBinary(digest).toLowerCase();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return null;
        }
    }
    public static void main(String[] args) {
        String loginPwd = Constants.ORIGIN_PWD;

        // 一次加密测试
        String EncryptedLoginPwd = encrypt(loginPwd);

        // 二次加密测试
        String EncryptedLoginPwdnd = null;
        if (EncryptedLoginPwd != null) {
            EncryptedLoginPwdnd = encrypt(EncryptedLoginPwd);
        }

        System.out.println(Constants.ORIGIN_PWD);
        System.out.println(EncryptedLoginPwd);

        // 获取二次加密密码，手动存入数据库中表 tbl_user 的 loginPwd 字段
        System.out.println(EncryptedLoginPwdnd);
    }
}
