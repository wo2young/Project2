package kr.or.mes2.dto;

import lombok.Data;

@Data
public class ItemMasterDTO {
	private int itemId;		//제품의 고유 아이디
	private String itemName;	//제품 이름
	private String lotCode;		//로트번호 앞에 들어갈 로트 코드
	private String itemCode;	//제품 종류
	private String unit;		//단위 ex) EA, L, KG
	private String itemSpec;	//제품의 기준정보
	private int ExpDate;		//유통기한 1일 기준 ex) 1년 = 365로 저장
}
