package kr.or.mes2.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.mes2.dao.QualityDefectDAO;
import kr.or.mes2.dto.QualityDefectDTO;
import kr.or.mes2.dto.CodeDTO;

@Service
public class QualityDefectService {

    @Autowired
    private QualityDefectDAO dao;

    /** ✅ 불량 목록 조회 */
    public List<QualityDefectDTO> getDefectList() {
        return dao.getDefectList();
    }

    /** ✅ 검사 완료된 인벤토리 목록 조회 (불량등록용) */
    public List<QualityDefectDTO> getInventoryList() {
        return dao.getInventoryList();
    }

    /** ✅ 불량 코드 목록 조회 */
    public List<CodeDTO> getDefectCodes() {
        return dao.getDefectCodes();
    }

    /** ✅ 불량 등록 */
    public void insertDefect(QualityDefectDTO dto) {
        // 🔹 DB 시퀀스 대신 자바에서 직접 ID 생성 (MAX + 1)
        int nextId = dao.getNextDefectId();
        dto.setDefectId(nextId);

        // 🔹 등록 시 상태값은 ING (진행 중)
        dto.setStatus("PENDING");

        dao.insertDefect(dto);
    }

    /** ✅ 총 불량 수량 + 남은 불량 수량 조회 (JSP에서 AJAX로 호출됨) */
    public Map<String, Object> getDefectQtyInfo(int inspectionId) {
        // 🔹 QUALITY_INSPECTION.DEFECT_QTY = 총 불량 수량
        int total = dao.getTotalDefectQty(inspectionId);

        // 🔹 등록된 불량합계 제외한 남은 불량 수량
        int remaining = dao.getRemainingDefectQty(inspectionId);

        // 🔹 Map 구성
        Map<String, Object> result = new HashMap<>();
        result.put("totalQty", total);
        result.put("remainingQty", remaining);
        return result;
    }
}
