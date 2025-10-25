package kr.or.mes2.dto;

import lombok.Data;

@Data
public class QualityDefectStatisticsDTO {
    private int goodQty;         // 양품 수량
    private int defectQty;       // 불량 수량
    private double defectRate;   // 불량률 (%)
    private String defectType;   // 불량 유형
    private int defectTypeQty;   // 불량 유형별 수량
    private String inspectType;  // 검사 유형
    private double inspectRate;  // 검사 유형별 불량률
}
