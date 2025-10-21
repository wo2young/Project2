package kr.or.mes2.dao;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import kr.or.mes2.dto.CodeDTO;

@Repository
public class CodeDAO {

	@Autowired
	private SqlSession sqlSession;

	public List<CodeDTO> getMasterList() {
		return sqlSession.selectList("kr.or.mes2.mappers.CodeMapper.getMasterList");
	}

	public List<CodeDTO> getDetailList(String codeId, String keyword) {
		java.util.Map<String, Object> map = new java.util.HashMap<>();
		map.put("codeId", codeId);
		map.put("keyword", keyword);
		return sqlSession.selectList("kr.or.mes2.mappers.CodeMapper.getDetailList", map);
	}

	public int insertMaster(CodeDTO dto) {
		return sqlSession.insert("kr.or.mes2.mappers.CodeMapper.insertMaster", dto);
	}

	public int updateMaster(CodeDTO dto) {
		return sqlSession.update("kr.or.mes2.mappers.CodeMapper.updateMaster", dto);
	}

	public int deleteMaster(String codeId) {
		return sqlSession.delete("kr.or.mes2.mappers.CodeMapper.deleteMaster", codeId);
	}

	public int insertDetail(CodeDTO dto) {
		return sqlSession.insert("kr.or.mes2.mappers.CodeMapper.insertDetail", dto);
	}

	public int updateDetail(CodeDTO dto) {
		return sqlSession.update("kr.or.mes2.mappers.CodeMapper.updateDetail", dto);
	}

	public int deleteDetail(String detailCode) {
		return sqlSession.delete("kr.or.mes2.mappers.CodeMapper.deleteDetail", detailCode);
	}

	public int countAllRefByDetailCode(String detailCode) {
		return sqlSession.selectOne("kr.or.mes2.mappers.CodeMapper.countAllRefByDetailCode", detailCode);
	}
}
