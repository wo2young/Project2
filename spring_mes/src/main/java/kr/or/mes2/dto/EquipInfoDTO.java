package kr.or.mes2.dto;

import lombok.Data;

@Data
public class EquipInfoDTO {

	private String equipCode;		//설비코드
	private String equipName;		//설비이름
	private int UPEH;				//설비 이론 생산량
	private String isActive;		//활성여부
	private int maintenanceTime;	//정비 기준시간
	private int dayRunTime;			//하루 가동 기준시간
}
