package org.example.crm.commons.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 公共工具类
 * 对 Date 类型数据进行处理的工具类
 */
public class DateUtils {
    /**
     *  对指定 date 对象格式化：yyyy-MM-dd HH:mm:ss
     * @param date
     * @return
     */
    public static String formatDateTime(Date date) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sdf.format(date);
    }

    public static String formatDate(Date date) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        return sdf.format(date);
    }

    public static String formatTime(Date date) {
        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
        return sdf.format(date);
    }
}
