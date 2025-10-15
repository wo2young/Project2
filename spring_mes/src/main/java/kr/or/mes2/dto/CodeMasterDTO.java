package kr.or.mes2.dto;

import lombok.Data;

@Data
public class CodeMasterDTO {
	private String codeId;		//코드 고유 아이디
	private String codeName;	//코드 이름 ex) PCD>완제품 FCD>원재료 EQUIP> 설비
}
