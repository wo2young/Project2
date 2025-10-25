package kr.or.mes2.dto;

import lombok.Data;

/**
 * 품질검사 DTO
 * QUALITY_INSPECTION + INVENTORY_TRANSACTION + ITEM_MASTER 조인 구조 반영
 */
@Data
public class QualityInspectionDTO {

    // ===============================
    // 📦 [품질검사 테이블: QUALITY_INSPECTION]
    // ===============================
    private Integer inspectionId;      // INSPECTION_ID (PK)
    private Integer inspectorId;       // INSPECTOR_ID (검사자)
    private String inspectType;        // INSPECT_TYPE (RECEIVING / IN_PROCESS / FINAL)
    private Integer totalQty;          // ✅ TOTAL_QTY (총 수량, INVENTORY에서 자동 참조)
    private Integer defectQty;         // DEFECT_QTY (불량 수량)
    private String inspectionResult;   // INSPECTION_RESULT (OK / NG)
    private String remarks;            // REMARKS (비고)
    private String createdAt;          // CREATED_AT (등록일시)
    private Integer txnId;             // TXN_ID (재고 트랜잭션)

    // ===============================
    // 📦 [인벤토리 테이블: INVENTORY_TRANSACTION]
    // ===============================
    private Integer itemId;            // ITEM_ID (품목 ID)
    private Integer quantity;          // QTY (수량)
    private String status;             // STATUS (CONFIRMED / VOIDED / ING)
    private String txnDate;            // TXN_DATE (트랜잭션 일시)

    // ===============================
    // 🔗 [조인용 확장 필드: ITEM_MASTER]
    // ===============================
    private String itemName;           // ITEM_NAME (품목명)
    private String itemTypeCode;       // ITEM_TYPE_CODE (RMD / SGD / PCD)
    private String specification;      // SPECIFICATION (규격)
    private String unit;               // UNIT (단위)
}
