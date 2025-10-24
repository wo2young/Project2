package kr.or.mes2.dao;

import java.util.*;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import kr.or.mes2.dto.EquipmentInfoDTO;

@Repository
public class EquipmentInfoDAO {

    @Autowired
    private SqlSession sqlSession;

    public List<EquipmentInfoDTO> getEquipList(String keyword, String detailCode) {
        Map<String, Object> map = new HashMap<>();
        map.put("keyword", keyword);
        map.put("detailCode", detailCode);
        return sqlSession.selectList("kr.or.mes2.mappers.EquipmentInfoMapper.getEquipList", map);
    }

    public int getNextEquipId() {
        return sqlSession.selectOne("kr.or.mes2.mappers.EquipmentInfoMapper.getNextEquipId");
    }

    public boolean isDuplicateCode(String equipCode) {
        int count = sqlSession.selectOne("kr.or.mes2.mappers.EquipmentInfoMapper.checkDuplicateCode", equipCode);
        return count > 0;
    }

    public int insertEquip(EquipmentInfoDTO dto) {
        return sqlSession.insert("kr.or.mes2.mappers.EquipmentInfoMapper.insertEquip", dto);
    }

    public int updateEquip(EquipmentInfoDTO dto) {
        return sqlSession.update("kr.or.mes2.mappers.EquipmentInfoMapper.updateEquip", dto);
    }

    public int deleteEquip(int equipId) {
        return sqlSession.delete("kr.or.mes2.mappers.EquipmentInfoMapper.deleteEquip", equipId);
    }

    // ✅ 제품군 목록 가져오기 (CODE_DETAIL)
    public List<EquipmentInfoDTO> getProductGroupList() {
        return sqlSession.selectList("kr.or.mes2.mappers.EquipmentInfoMapper.getProductGroupList");
    }
}
