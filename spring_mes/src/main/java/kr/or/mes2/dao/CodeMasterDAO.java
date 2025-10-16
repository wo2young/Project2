package kr.or.mes2.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.or.mes2.dto.CodeMasterDTO;

@Repository
public class CodeMasterDAO {

	@Autowired
	SqlSession sqlSession;

	//TODO 디테일 코드 리스트
	public List<CodeMasterDTO> selectCode(){
		List<CodeMasterDTO> resultList= null;
		resultList = sqlSession.selectList("mapper.mes.masterCode");
		return resultList;
	}
	
}
