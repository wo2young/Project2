package kr.or.mes2.dto;

import lombok.Data;
import java.sql.Timestamp;

@Data
public class BomDTO {
    private int bomId;             // BOM_ID
    private int parentItem;        // PARENT_ITEM
    private int childItem;         // CHILD_ITEM
    private double requiredQty;    // REQUIRED_QTY
    private String status;         // STATUS (Y/N)
    private Timestamp createdAt;   // CREATED_AT
    private Timestamp updatedAt;   // UPDATED_AT

    // 조회용
    private String parentItemName; // 상위 품목명
    private String childItemName;  // 하위 자재명
    private String childUnit;      // 하위 자재 단위
}
