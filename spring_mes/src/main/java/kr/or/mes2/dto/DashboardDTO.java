package kr.or.mes2.dto;

import lombok.Data;

@Data
public class DashboardDTO {
    private int goodQty;       // 양품 수량 (GOOD_QTY)
    private int defectQty;     // 불량 수량 (DEFECT_QTY)
    private String label;      // 그래프용 라벨 (예: 날짜, 품목명 등)
    private int value;         // 그래프 값 (예: 수량, 퍼센트 등)
    private int targetQty;     // 목표 수량 (PRODUCTION_TARGET)
    private int resultQty;     // 실적 수량 (PRODUCTION_RESULT)
}
