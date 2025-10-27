package kr.or.mes2.dto;

import lombok.Data;

@Data
public class InventoryDTO {
    private int txnId;        // 트랜잭션 ID
    private int itemId;       // 품목 ID
    private String itemName;  // 품목명
    private String txnType;   // 입출고 구분 (IN/OUT)
    private String sourceType; // 발생 유형 (PRODUCTION/DEFECT 등)
    private int qty;          // 수량
    private String status;    // 상태 (ing, 검사완료, CONFIRMED 등)
    private String txnDate;   // 거래 일자 (String 또는 Date 가능)
}
