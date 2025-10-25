package kr.or.mes2.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.mes2.dao.QualityInspectionDAO;
import kr.or.mes2.dto.QualityInspectionDTO;

/**
 * ✅ 품질검사 Service
 * - QUALITY_INSPECTION 테이블 관리
 * - INVENTORY_TRANSACTION 및 ITEM_MASTER 연동 구조
 */
@Service
public class QualityInspectionService {

    @Autowired
    private QualityInspectionDAO dao;

    /**
     * ✅ [검사 대상 목록 조회]
     * - STATUS = 'CONFIRMED' 인 항목만
     * - 셀렉트박스에서 검사 대상 표시용
     */
    public List<QualityInspectionDTO> getInventoryList() {
        return dao.getInventoryList();
    }

    /**
     * ✅ [품질검사 목록 조회]
     * - 등록된 검사 내역 표시용 (하단 테이블)
     */
    public List<QualityInspectionDTO> getInspectionList() {
        return dao.getInspectionList();
    }

    /**
     * ✅ [품질검사 등록]
     * - 자바단에서 시퀀스 대체 (MAX + 1)
     * - TXN_ID 기준으로 INVENTORY_TRANSACTION의 QTY 불러와 TOTAL_QTY에 세팅
     * - CREATED_AT은 SYSDATE 자동 입력
     */
    public void insertInspection(QualityInspectionDTO dto) {
        // ✅ 시퀀스 대체 (MAX + 1)
        int nextId = dao.getNextInspectionId();
        dto.setInspectionId(nextId);

        // ✅ TXN_ID 기준으로 인벤토리 수량 조회 → TOTAL_QTY에 저장
        Integer qty = dao.getQtyByTxnId(dto.getTxnId());
        dto.setTotalQty(qty);

        // ✅ 품질검사 등록
        dao.insertInspection(dto);

        // ✅ 검사 진행 중 상태로 변경
        dao.updateStatusToING(dto.getTxnId());
    }

    /**
     * ✅ [TXN_ID 기준 ITEM_TYPE_CODE 조회]
     * → 품목유형 기반으로 검사유형 자동 결정
     * (PCD → FINAL / SGD → IN_PROCESS / RMD → RECEIVING)
     */
    public String getItemTypeCodeByTxn(int txnId) {
        return dao.getItemTypeCodeByTxn(txnId);
    }

    /**
     * ⚙️ [검사 완료 시 상태 변경]
     * - INVENTORY_TRANSACTION.STATUS → 'VOIDED'
     * - 검사 완료된 트랜잭션 비활성화용 (선택적 사용)
     */
    public void updateStatusToVoided(int txnId) {
        dao.updateStatusToVoided(txnId);
    }
    
    /** ✅ [검사 등록 후 트랜잭션 상태 'ING'로 변경] */
    public void updateStatusToING(int txnId) {
        dao.updateStatusToING(txnId);
    }
}
