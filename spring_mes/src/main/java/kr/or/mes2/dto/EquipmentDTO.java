package kr.or.mes2.dto;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class EquipmentDTO {

	private int equipId;		//설비 고유아이디
	private String detailCode;	//설비 코드디테일
	private String status;		//상태(가동중, 정비중, 멈춤)
	private int orderId;		//지시아이디
	private int totalRunTime;	//총가동시간
	private Timestamp createAt;	//생성일시
	private Timestamp updateAt; //갱신일시
}
