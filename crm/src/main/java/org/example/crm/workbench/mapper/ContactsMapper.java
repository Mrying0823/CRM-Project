package org.example.crm.workbench.mapper;

import org.example.crm.workbench.domain.Contacts;

import java.util.List;
import java.util.Map;

public interface ContactsMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts
     *
     * @mbggenerated Sun Sep 10 08:39:16 CST 2023
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts
     *
     * @mbggenerated Sun Sep 10 08:39:16 CST 2023
     */
    int insert(Contacts record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts
     *
     * @mbggenerated Sun Sep 10 08:39:16 CST 2023
     */
    int insertSelective(Contacts record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts
     *
     * @mbggenerated Sun Sep 10 08:39:16 CST 2023
     */
    Contacts selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts
     *
     * @mbggenerated Sun Sep 10 08:39:16 CST 2023
     */
    int updateByPrimaryKeySelective(Contacts record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts
     *
     * @mbggenerated Sun Sep 10 08:39:16 CST 2023
     */
    int updateByPrimaryKey(Contacts record);

    /**
     * 保存创建的联系人表
     * @param contacts
     * @return
     */
    int insertContacts(Contacts contacts);

    /**
     * 分页查询联系人
     * @param map
     * @return
     */
    List<Contacts> selectContactsByConditionForPage(Map<String,Object> map);

    int selectCountOfContactsByCondition(Map<String,Object> map);

    /**
     * 跳转至联系人明细界面
     * @param id
     * @return
     */
    Contacts selectContactsForDetailById(String id);

    List<Contacts> selectContactsForSaveByName(String name);
}