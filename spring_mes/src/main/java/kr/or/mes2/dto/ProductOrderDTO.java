package kr.or.mes2.dto;

import java.sql.Timestamp;

import lombok.Data;
@Data
public class ProductOrderDTO {

	private int PrId;			//생산지시 고유 아이디
	private int targetId;		//생산목표 고유 아이디
	private int itemId;			//만들 제품 아이디
	private int equipId;		//제품을 만들 설비 아이디
	private int quantity;		//만들 수량
	private Timestamp dueDate;	//마감일자
	private String status;		//대기중, 진행중, 마감
	private Timestamp createAt;	//발행일자
	private int userId;			//만든 사람 아이디
	
}
