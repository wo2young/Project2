package kr.or.mes2.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.mes2.dao.ApprovalDAO;
import kr.or.mes2.dto.ApprovalDTO;

@Service
public class ApprovalService {

    @Autowired
    private ApprovalDAO dao;

    // ============================================================
    // 페이징 포함 조회
    // ============================================================
    public Map<String, Object> getPagedDefects(String status, int page, int pageSize) {
        int startRow = (page - 1) * pageSize + 1;
        int endRow = page * pageSize;

        Map<String, Object> params = new HashMap<>();
        params.put("status", status);
        params.put("startRow", startRow);
        params.put("endRow", endRow);

        List<ApprovalDTO> list = dao.getDefectsByStatusPaged(params);
        int totalCount = dao.getTotalDefectCount(status);

        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("totalCount", totalCount);

        return result;
    }

    // ============================================================
    // 승인 처리
    // ============================================================
    @Transactional
    public void approve(ApprovalDTO dto, int userId) {
        dto.setRequestUser(userId);
        dto.setApprovalStatus("APPROVED");

        // 1. 요청 ID 생성 및 삽입
        int nextId = dao.getNextRequestId();
        dto.setRequestId(nextId);
        dao.insertApprovalRequestNow(dto);

        // 2. 불량 상태 갱신
        dto.setDefectStatus("APPROVED");
        dao.updateQualityDefectStatusById(dto);

        // 3. 재고 OUT 등록
        dao.insertDefectOutTxnV2(dto);

        // 4. 검사ID 조회 후 전체 처리 완료 여부 확인
        Integer inspectionId = dao.selectInspectionIdByDefectId(dto.getDefectId());
        if (inspectionId != null) {
            int handled = dao.isInspectionFullyHandled(inspectionId);
            if (handled == 1) {
                dao.updateInventoryStatusToVoided(inspectionId);
            }
        }
    }

    // ============================================================
    // 반려 처리
    // ============================================================
    @Transactional
    public void reject(ApprovalDTO dto, int userId) {
        dto.setRequestUser(userId);
        dto.setApprovalStatus("REJECTED");

        // 1. 요청 ID 생성 및 삽입
        int nextId = dao.getNextRequestId();
        dto.setRequestId(nextId);
        dao.insertApprovalRequestNow(dto);

        // 2. 불량 상태 갱신
        dto.setDefectStatus("REJECTED");
        dao.updateQualityDefectStatusById(dto);

        // 3. 검사ID 조회 후 전체 처리 완료 여부 확인
        Integer inspectionId = dao.selectInspectionIdByDefectId(dto.getDefectId());
        if (inspectionId != null) {
            int handled = dao.isInspectionFullyHandled(inspectionId);
            if (handled == 1) {
                dao.updateInventoryStatusToVoided(inspectionId);
            }
        }
    }
}
