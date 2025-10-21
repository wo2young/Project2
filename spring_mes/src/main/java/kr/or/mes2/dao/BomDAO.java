package kr.or.mes2.dao;

import java.util.*;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.or.mes2.dto.BomDTO;
import kr.or.mes2.dto.ItemMasterDTO;

@Repository
public class BomDAO {

    @Autowired
    private SqlSession sqlSession;

    // ✅ 시퀀스 없이: MAX(BOM_ID)+1 채번
    public int getNextBomId() {
        Integer next = sqlSession.selectOne("kr.or.mes2.mappers.BomMapper.getNextBomId");
        return (next == null) ? 1 : next;
    }

    public List<BomDTO> getBomList(String keyword, String type) {
        Map<String, Object> map = new HashMap<>();
        map.put("keyword", keyword);
        map.put("type", type);
        return sqlSession.selectList("kr.or.mes2.mappers.BomMapper.getBomList", map);
    }

    public int countDuplicate(BomDTO dto) {
        return sqlSession.selectOne("kr.or.mes2.mappers.BomMapper.countDuplicate", dto);
    }

    public int countParentReference(int childItem) {
        return sqlSession.selectOne("kr.or.mes2.mappers.BomMapper.countParentReference", childItem);
    }

    public int insertBom(BomDTO dto) {
        return sqlSession.insert("kr.or.mes2.mappers.BomMapper.insertBom", dto);
    }

    public int updateBom(BomDTO dto) {
        return sqlSession.update("kr.or.mes2.mappers.BomMapper.updateBom", dto);
    }

    public int deleteBom(int bomId) {
        return sqlSession.delete("kr.or.mes2.mappers.BomMapper.deleteBom", bomId);
    }

    public List<ItemMasterDTO> getParentItems() {
        return sqlSession.selectList("kr.or.mes2.mappers.BomMapper.getParentItems");
    }

    public List<ItemMasterDTO> getChildItems() {
        return sqlSession.selectList("kr.or.mes2.mappers.BomMapper.getChildItems");
    }
}
