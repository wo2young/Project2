package kr.or.mes2.dto;

import lombok.Data;

@Data
public class CodeDTO {
    // 마스터
    private String codeId;       // EQP, PCD 등
    private String codeName;     // 설비, 제품 등

    // 디테일
    private String detailCode;   // EQP-001 등
    private String detailName;   // 혼합1호기 등
    private String detailUseYn;  // Y/N
}
