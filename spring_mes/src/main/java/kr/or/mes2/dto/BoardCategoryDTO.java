package kr.or.mes2.dto;

import lombok.Data;

@Data
public class BoardCategoryDTO {
    private int categoryId;     // 카테고리 고유번호
    private String categoryName;// 카테고리명
    private String isActive;       // 사용 여부 (Y/N)
    private int sortOrder;      // 정렬 순서

}
