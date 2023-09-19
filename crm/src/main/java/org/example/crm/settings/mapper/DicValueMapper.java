package org.example.crm.settings.mapper;

import org.example.crm.settings.domain.DicValue;

import java.util.List;

public interface DicValueMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_value
     *
     * @mbggenerated Sun Sep 03 20:26:48 CST 2023
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_value
     *
     * @mbggenerated Sun Sep 03 20:26:48 CST 2023
     */
    int insert(DicValue record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_value
     *
     * @mbggenerated Sun Sep 03 20:26:48 CST 2023
     */
    int insertSelective(DicValue record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_value
     *
     * @mbggenerated Sun Sep 03 20:26:48 CST 2023
     */
    DicValue selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_value
     *
     * @mbggenerated Sun Sep 03 20:26:48 CST 2023
     */
    int updateByPrimaryKeySelective(DicValue record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_value
     *
     * @mbggenerated Sun Sep 03 20:26:48 CST 2023
     */
    int updateByPrimaryKey(DicValue record);

    /**
     * 根据 typeCode 查询数据字典值
     * @param typeCode
     * @return
     */
    List<DicValue> selectDicValueByTypeCode(String typeCode);

    DicValue selectStageNameById(String id);
}