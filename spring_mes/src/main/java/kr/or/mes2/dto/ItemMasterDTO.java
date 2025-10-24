package kr.or.mes2.dto;

import lombok.Data;

@Data
public class ItemMasterDTO {

    // 기본 정보
    private int itemId;             // ITEM_ID: 제품의 고유 아이디
    private String itemName;        // ITEM_NAME: 제품 이름
    private String lotPrefix;       // LOT_PREFIX: 로트번호 앞 코드 (예: PCD)
    private String itemTypeCode;    // ITEM_TYPE_CODE: 마스터 코드 (PCD / SGD / RMD)
    private String detailCode;      // ITEM_DETAIL_CODE: 세부 코드 (CODE_DETAIL.DETAIL_CODE)
    private String unit;            // UNIT: 단위 (EA, L, KG 등)
    private String specification;        // SPECIFICATION: 제품의 기준정보
    private int expDate;            // EXPIRY_DAYS: 유통기한(일 기준)

    // 조회용 (조인 결과용)
    private String typeName;        // CODE_MASTER.CODE_NAME
    private String detailName;      // CODE_DETAIL.DETAIL_NAME
    private String detailUseYn;     // CODE_DETAIL.DETAIL_USE_YN (활성 여부)
}
