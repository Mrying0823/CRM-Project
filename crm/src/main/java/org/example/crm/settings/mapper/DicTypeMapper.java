package org.example.crm.settings.mapper;

import org.example.crm.settings.domain.DicType;

import java.util.Map;

public interface DicTypeMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_type
     *
     * @mbggenerated Fri Aug 04 14:15:01 CST 2023
     */
    int deleteByPrimaryKey(String code);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_type
     *
     * @mbggenerated Fri Aug 04 14:15:01 CST 2023
     */
    int insert(DicType record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_type
     *
     * @mbggenerated Fri Aug 04 14:15:01 CST 2023
     */
    int insertSelective(DicType record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_type
     *
     * @mbggenerated Fri Aug 04 14:15:01 CST 2023
     */
    DicType selectByPrimaryKey(String code);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_type
     *
     * @mbggenerated Fri Aug 04 14:15:01 CST 2023
     */
    int updateByPrimaryKeySelective(DicType record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_type
     *
     * @mbggenerated Fri Aug 04 14:15:01 CST 2023
     */
    int updateByPrimaryKey(DicType record);

    // 编写将 code、name 和 description 写入数据库的方法
    int insertIdNameDescriptionToDictionaryType(Map<String,Object> map);

    // 查询所有数据的方法
    DicType selectAllFromDictionaryType();
}