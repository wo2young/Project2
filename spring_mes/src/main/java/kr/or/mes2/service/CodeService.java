package kr.or.mes2.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import kr.or.mes2.dao.CodeDAO;
import kr.or.mes2.dto.CodeDTO;

@Service
public class CodeService {

	@Autowired
	private CodeDAO dao;

	public List<CodeDTO> getMasterList() {
		return dao.getMasterList();
	}

	public List<CodeDTO> getDetailList(String codeId, String keyword) {
		return dao.getDetailList(codeId, keyword);
	}

	public int insertMaster(CodeDTO dto) {
		return dao.insertMaster(dto);
	}

	public int updateMaster(CodeDTO dto) {
		return dao.updateMaster(dto);
	}

	public int deleteMaster(String codeId) {
		return dao.deleteMaster(codeId);
	}

	public int insertDetail(CodeDTO dto) {
		return dao.insertDetail(dto);
	}

	public int updateDetail(CodeDTO dto) {
		return dao.updateDetail(dto);
	}

	public int deleteDetail(String detailCode) {
		return dao.deleteDetail(detailCode);
	}

	public int countAllRefByDetailCode(String detailCode) {
		return dao.countAllRefByDetailCode(detailCode);
	}
}
