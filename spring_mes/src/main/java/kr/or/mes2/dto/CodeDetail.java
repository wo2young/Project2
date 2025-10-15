package kr.or.mes2.dto;

import lombok.Data;

@Data
public class CodeDetail {
	private String detailCode; 	//디테일코드
	private String codeId;	   	//마스터코드의 코드 아이디
	private String detailCodeName;
	private String isActive;	//활성 여부
}
