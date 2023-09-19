package org.example.crm.workbench.mapper;

import org.example.crm.workbench.domain.FunnelVO;
import org.example.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran
     *
     * @mbggenerated Sun Sep 10 21:07:57 CST 2023
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran
     *
     * @mbggenerated Sun Sep 10 21:07:57 CST 2023
     */
    int insert(Tran record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran
     *
     * @mbggenerated Sun Sep 10 21:07:57 CST 2023
     */
    int insertSelective(Tran record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran
     *
     * @mbggenerated Sun Sep 10 21:07:57 CST 2023
     */
    Tran selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran
     *
     * @mbggenerated Sun Sep 10 21:07:57 CST 2023
     */
    int updateByPrimaryKeySelective(Tran record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran
     *
     * @mbggenerated Sun Sep 10 21:07:57 CST 2023
     */
    int updateByPrimaryKey(Tran record);

    /**
     * 创建交易，往交易表中添加一条记录
     * @param tran
     * @return
     */
    int insertTran(Tran tran);

    List<Tran> selectTranByConditionForPage(Map<String,Object> map);

    int selectCountOfTranByCondition(Map<String,Object> map);

    /**
     * 根据 id 查询交易明细
     * @param id
     * @return
     */
    Tran selectTranForDetailById(String id);

    int updateTranStage(Tran tran);

    /**
     * 查询交易表中各个阶段的数据量
     * @return
     */
    List<FunnelVO> selectCountOfTranGroupByStage();
}