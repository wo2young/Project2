package kr.or.mes2.dto;

import lombok.Data;

/**
 * 불량 통계 DTO
 * QUALITY_DEFECT_STATISTICS 관련 Mapper 결과와 1:1 매핑
 */
@Data
public class QualityDefectStatisticsDTO {

    // ✅ 상단 요약 통계 (완제품 / 반제품)
    private int totalQty;          // 총수량
    private int defectQty;         // 불량 수량
    private double defectRate;     // 불량률 (%)
    private String productType;    // 제품 유형 (완제품 / 반제품)
    private String productTypeCode;// 제품 유형 코드 (PCD / SGD)

    // ✅ 하단 세부 통계 (불량 유형별, 검사 유형별 등)
    private String defectType;     // 불량 유형 (ex: 파손, 용기불량)
    private int defectCount;       // 불량 유형별 건수
    private String inspectType;    // 검사 유형 (IN_PROCESS / FINAL)
    private double inspectRate;    // 검사 유형별 불량률

    // ✅ 선택적 필드 (필요시 사용)
    private int goodQty;           // 양품 수량 (옵션)
}
