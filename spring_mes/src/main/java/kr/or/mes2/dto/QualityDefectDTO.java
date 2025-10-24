package kr.or.mes2.dto;

import lombok.Data;

//✅ QualityDefectDTO.java
@Data
public class QualityDefectDTO {
 private Integer defectId;
 private Integer inspectId;      // 기존 필드
 private Integer inspectionId;   // ✅ JSP/Mapper 호환용 alias
 private String defectType;
 private Integer defectQty;
 private String defectReason;
 private String status;
 private Integer approvedBy;
 private String approvedAt;
 private String createdAt;

 // 조인용
 private String itemName;
 private String inspectorName;
 private String detailCode;  // DETAIL_CODE
 private String codeName;    // DETAIL_NAME
}
