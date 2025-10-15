package kr.or.mes2.dto;

import lombok.Data;

@Data
public class RoutingDTO {
	private int routingId;		//공정고유아이디
	private int itemId;			//제품기준정보의 제품아이디
	private int routingStep;		//공정 순서
	private String imgPath;			//이미지 경로
	private String remark;			//설명
	private String eqipId;			//장비기준정보의 장비 아이디
}
