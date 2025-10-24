package kr.or.mes2.dto;

import lombok.Data;

@Data
public class EquipmentInfoDTO {
    private int equipId;           // 설비 ID (PK)
    private String equipCode;      // 설비 코드 (UNIQUE)
    private String equipName;      // 설비명
    private Double stdCapacity;    // 표준 생산량
    private String activeYn;       // 사용 여부
    private Double maintenanceHr;  // 정비시간
    private Double dailyCapacity;  // 일일 생산량
    private String detailCode;     // 제품군 코드 (FK)
    private String detailName;     // 제품군 이름 (조인 결과)
}
