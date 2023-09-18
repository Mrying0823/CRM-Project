package org.example.crm.workbench.mapper;

import org.example.crm.workbench.domain.ActivityRemark;
import org.example.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_remark
     *
     * @mbggenerated Tue Sep 05 20:22:56 CST 2023
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_remark
     *
     * @mbggenerated Tue Sep 05 20:22:56 CST 2023
     */
    int insert(ClueRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_remark
     *
     * @mbggenerated Tue Sep 05 20:22:56 CST 2023
     */
    int insertSelective(ClueRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_remark
     *
     * @mbggenerated Tue Sep 05 20:22:56 CST 2023
     */
    ClueRemark selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_remark
     *
     * @mbggenerated Tue Sep 05 20:22:56 CST 2023
     */
    int updateByPrimaryKeySelective(ClueRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_remark
     *
     * @mbggenerated Tue Sep 05 20:22:56 CST 2023
     */
    int updateByPrimaryKey(ClueRemark record);

    /**
     * 根据 clue_id 查询线索备注
     * @param clueId
     * @return
     */
    List<ClueRemark> selectClueRemarkForDetailByClueId(String clueId);

    /**
     * 保存线索备注
     * @param remark
     * @return
     */
    int insertClueRemark(ClueRemark remark);

    /**
     * 根据 id 删除线索备注
     * @param id
     * @return
     */
    int deleteClueRemarkById(String id);

    /**
     * 更新线索备注
     * @param remark
     * @return
     */
    int updateClueRemark(ClueRemark remark);

    /**
     * 根据 clue_id 查询线索备注，用于把该线索下所有的备注转换到客户备注表
     * @param clueId
     * @return
     */
    List<ClueRemark> selectClueRemarkByClueId(String clueId);

    /**
     * 所有线索明细转换结束后，根据 clueId 删除所有的线索备注
     * @param clueId
     * @return
     */
    int deleteClueRemarkByClueId(String clueId);
}