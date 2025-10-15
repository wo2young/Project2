package kr.or.mes2.dto;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class BomDTO {
	private int bomId;		//bom고유아이디
	private int parenItemId;	//완제품 아이디 >> 디테일 코드로 구분 가능
	private int childItemId;	//반제품 및 원료 아이디 >> 디테일 코드로 구분 가능
	private int quantity;		//수량
	private String status;		//상태
	private Timestamp createAt; //처음 생성일
	private Timestamp updateAt; //갱신일(비활성화 시각 상태값 변경시 적용)
}
