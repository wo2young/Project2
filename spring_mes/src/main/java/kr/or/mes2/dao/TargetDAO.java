package kr.or.mes2.dao;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import kr.or.mes2.dto.TargetDTO;

@Repository
public class TargetDAO {

    private static final String NS = "kr.or.mes2.mapper.TargetMapper.";

    @Autowired
    private SqlSession sqlSession;

    public List<TargetDTO> getTargetList(Map<String, Object> params) {
        return sqlSession.selectList(NS + "getTargetList", params);
    }

    public List<TargetDTO> getPCDitems() {
        return sqlSession.selectList(NS + "getPCDitems");
    }

    public int insertTarget(TargetDTO dto) {
        return sqlSession.insert(NS + "insertTarget", dto);
    }

    public int updateTarget(TargetDTO dto) {
        return sqlSession.update(NS + "updateTarget", dto);
    }

    public int deleteTarget(int targetId) {
        return sqlSession.delete(NS + "deleteTarget", targetId);
    }
    public int getOrderQtySumByTarget(int targetId) {
        return sqlSession.selectOne(NS + "getOrderQtySumByTarget", targetId);
    }

}
