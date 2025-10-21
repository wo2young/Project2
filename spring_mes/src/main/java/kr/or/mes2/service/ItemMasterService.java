package kr.or.mes2.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.mes2.dao.ItemMasterDAO;
import kr.or.mes2.dto.ItemMasterDTO;
import kr.or.mes2.dto.CodeDTO;

@Service
public class ItemMasterService {

	@Autowired
	private ItemMasterDAO dao;

	public List<ItemMasterDTO> list(String keyword, String typeFilter) {
		return dao.list(keyword, typeFilter);
	}

	public ItemMasterDTO getItem(int itemId) {
		return dao.get(itemId);
	}

	public boolean insert(ItemMasterDTO dto) {
		return dao.insert(dto) > 0;
	}

	public boolean update(ItemMasterDTO dto) {
		return dao.update(dto) > 0;
	}

	public boolean delete(int itemId) {
		return dao.delete(itemId) > 0;
	}

	public List<CodeDTO> getActiveItemKindCodes() {
		return dao.getActiveItemKindCodes();
	}

	public List<CodeDTO> getItemKindMasterCodes() {
		return dao.getItemKindMasterCodes();
	}

	public List<CodeDTO> getAvailableDetailCodes(String codeId) {
		return dao.getAvailableDetailCodes(codeId);
	}
}
