package org.example.crm.commons.utils;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.example.crm.workbench.domain.Activity;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.util.List;

public class ExportActivityUtils {

    public static void generateExcel(HttpServletResponse response,String sheetName, String[] headers, List<Activity> activityList) throws IOException {
        // 创建 excel 文件，并且把 activityList 写入到 excel 文件中
        // 创建 excel 工作簿，可以在工作簿中添加一个或多个工作表
        HSSFWorkbook workbook = new HSSFWorkbook();
        // 创建一个 HSSFSheet 对象，即一个工作表
        HSSFSheet sheet = workbook.createSheet(sheetName);
        // 创建一个 HSSFRow 对象，即工作表中的一行。
        HSSFRow row = sheet.createRow(0);
        HSSFCell cell = null;
        for (int i = 0; i < headers.length; i++) {
            // 创建一个 HSSFCell 对象，即单元格。createCell(0) 表示在当前行中创建一个位于第一列的单元格。
            cell = row.createCell(i);
            cell.setCellValue(headers[i]);
        }

        if(!activityList.isEmpty()){
            // 遍历 activityList，创建 HSSFRow 对象，生成所有的数据列
            Activity activity = null;
            for (int i = 0;i < activityList.size();i++) {
                activity = activityList.get(i);
                String[] temp = activity.getAllValue();

                // 每遍历出一条市场活动，生成一行
                row = sheet.createRow(i + 1);

                for (int j = 0; j < temp.length; j++) {
                    cell = row.createCell(j);
                    cell.setCellValue(temp[j]);
                }
            }
        }

        response.setContentType("application/octet-stream;charset=UTF-8");

        OutputStream outputStream = response.getOutputStream();

        response.addHeader("Content-Disposition","attachment;filename=activityList.xls");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");

        workbook.write(outputStream);

        workbook.close();
        outputStream.flush();
    }
}
