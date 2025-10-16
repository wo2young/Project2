package kr.or.mes2.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.mes2.dao.CodeMasterDAO;
import kr.or.mes2.dto.CodeMasterDTO;

@Service
public class CodeMasterService {

	@Autowired
	CodeMasterDAO dao;
	//TODO 코드마스터 전체 조회
	public List<CodeMasterDTO> selectCode(){
		return dao.selectCode();
	}
}
