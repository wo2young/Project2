package kr.or.mes2.dao;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.or.mes2.dto.QualityInspectionDTO;

/**
 * ✅ 품질검사 DAO
 * QUALITY_INSPECTION + INVENTORY_TRANSACTION + ITEM_MASTER 조인 기반 DAO
 */
@Repository
public class QualityInspectionDAO {

    @Autowired
    private SqlSession sqlSession;

    // 매퍼 네임스페이스
    private static final String NS = "kr.or.mes2.mappers.QualityInspectionMapper.";

    /** ✅ [검사 대상 목록 조회]
     * INVENTORY_TRANSACTION 테이블에서 STATUS = 'CONFIRMED' 인 항목만 불러오기
     */
    public List<QualityInspectionDTO> getInventoryList() {
        return sqlSession.selectList(NS + "getInventoryList");
    }

    /** ✅ [등록된 품질검사 목록 조회]
     * QUALITY_INSPECTION + INVENTORY_TRANSACTION + ITEM_MASTER 조인
     */
    public List<QualityInspectionDTO> getInspectionList() {
        return sqlSession.selectList(NS + "getInspectionList");
    }

    /** ✅ [품질검사 등록]
     * TXN_ID 기준으로 신규 검사 내역 저장
     */
    public void insertInspection(QualityInspectionDTO dto) {
        sqlSession.insert(NS + "insertInspection", dto);
    }

    /** ✅ [ITEM_TYPE_CODE 조회]
     * TXN_ID 기준으로 ITEM_MASTER의 ITEM_TYPE_CODE 조회
     * → 검사유형 자동기입 (RMD → RECEIVING, SGD → IN_PROCESS, PCD → FINAL)
     */
    public String getItemTypeCodeByTxn(int txnId) {
        return sqlSession.selectOne(NS + "getItemTypeCodeByTxn", txnId);
    }

    /** ✅ [검사 ID 생성용 시퀀스 대체]
     * QUALITY_INSPECTION 테이블의 MAX + 1
     */
    public int getNextInspectionId() {
        return sqlSession.selectOne(NS + "getNextInspectionId");
    }

    /** ⚙️ [검사 완료 시 상태 변경]
     * INVENTORY_TRANSACTION.STATUS → 'VOIDED'
     * (검사 후 재고 트랜잭션 비활성화용 — 필요 시 사용)
     */
    public void updateStatusToVoided(int txnId) {
        sqlSession.update(NS + "updateStatusToVoided", txnId);
    }
    
    /** ✅ [검사 등록 시 STATUS → 'ING'] */
    public void updateStatusToING(int txnId) {
        sqlSession.update(NS + "updateStatusToING", txnId);
    }

    /** ✅ [TXN_ID 기준으로 INVENTORY 수량(QTY) 조회] */
    public Integer getQtyByTxnId(Integer txnId) {
        return sqlSession.selectOne(NS + "getQtyByTxnId", txnId);
    }
}
