package kr.or.mes2.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.or.mes2.dto.ApprovalDTO;

@Repository
public class ApprovalDAO {

    @Autowired
    private SqlSession sql;

    private static final String NS = "kr.or.mes2.mapper.ApprovalMapper.";

    /* ============================================================
       기본 조회 및 승인 요청
       ============================================================ */

    public int getNextRequestId() {
        return sql.selectOne(NS + "getNextRequestId");
    }

    public List<ApprovalDTO> getDefectsByStatusPaged(Map<String, Object> params) {
        return sql.selectList(NS + "getDefectsByStatusPaged", params);
    }

    public int getTotalDefectCount(String status) {
        return sql.selectOne(NS + "getTotalDefectCount", status);
    }

    public Integer selectInspectionIdByDefectId(int defectId) {
        return sql.selectOne(NS + "selectInspectionIdByDefectId", defectId);
    }

    public Map<String, Object> selectInventoryByInspectionId(int inspectionId) {
        return sql.selectOne(NS + "selectInventoryByInspectionId", inspectionId);
    }

    public int sumDefectQtyByInspectionId(int inspectionId) {
        return sql.selectOne(NS + "sumDefectQtyByInspectionId", inspectionId);
    }

    public int sumOutQtyByInspectionId(int inspectionId) {
        return sql.selectOne(NS + "sumOutQtyByInspectionId", inspectionId);
    }

    public void insertApprovalRequestNow(ApprovalDTO dto) {
        sql.insert(NS + "insertApprovalRequest", dto);
    }

    public void updateQualityDefectStatusById(ApprovalDTO dto) {
        sql.update(NS + "updateQualityDefectStatus", dto);
    }

    public void insertDefectOutTxnV2(ApprovalDTO dto) {
        sql.insert(NS + "insertDefectOutTxn", dto);
    }

    /* ============================================================
       검사 상태 처리 관련 (신규)
       ============================================================ */

    // ① 검사 단위가 전부 승인·반려 처리되었는지 확인
    public int isInspectionFullyHandled(int inspectionId) {
        return sql.selectOne(NS + "isInspectionFullyHandled", inspectionId);
    }

    // ② 검사 단위 재고를 VOIDED로 변경
    public void updateInventoryStatusToVoided(int inspectionId) {
        sql.update(NS + "updateInventoryStatusToVoided", inspectionId);
    }
}
