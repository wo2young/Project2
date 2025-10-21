package kr.or.mes2.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.or.mes2.dto.ItemMasterDTO;
import kr.or.mes2.dto.CodeDTO;

@Repository
public class ItemMasterDAO {

	private static final String NS = "kr.or.mes2.mapper.ItemMasterMapper.";

	@Autowired
	private SqlSession sql;

	public List<ItemMasterDTO> list(String keyword, String typeFilter) {
		Map<String, Object> map = new HashMap<>();
		map.put("keyword", keyword);
		map.put("typeFilter", typeFilter);
		return sql.selectList(NS + "listItem", map);
	}

	public ItemMasterDTO get(int itemId) {
		return sql.selectOne(NS + "getItemById", itemId);
	}

	public int insert(ItemMasterDTO dto) {
		int nextId = sql.selectOne(NS + "getNextItemId");
		dto.setItemId(nextId);
		return sql.insert(NS + "insertItem", dto);
	}

	public int update(ItemMasterDTO dto) {
		return sql.update(NS + "updateItem", dto);
	}

	public int delete(int itemId) {
		return sql.delete(NS + "deleteItem", itemId);
	}

	public List<CodeDTO> getActiveItemKindCodes() {
		return sql.selectList(NS + "listActiveItemKindCodes");
	}

	public List<CodeDTO> getItemKindMasterCodes() {
		return sql.selectList(NS + "listItemKindMasterCodes");
	}

	public List<CodeDTO> getAvailableDetailCodes(String codeId) {
		return sql.selectList(NS + "listAvailableDetailCodes", codeId);
	}
}
