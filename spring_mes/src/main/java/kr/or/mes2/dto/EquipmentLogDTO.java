package kr.or.mes2.dto;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class EquipmentLogDTO {
	private int logId; 				//설비 가동에 대한 로그 아이디
	private String equipId;			//설비 아이디
	private Timestamp startTime;	//시작시간
	private Timestamp endTime;		//끝난시간
}
