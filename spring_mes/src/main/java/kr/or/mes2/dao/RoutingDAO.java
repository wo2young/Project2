package kr.or.mes2.dao;

import java.util.*;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import kr.or.mes2.dto.RoutingDTO;

@Repository
public class RoutingDAO {

    @Autowired
    private SqlSession sqlSession;

    private static final String NS = "kr.or.mes2.mappers.RoutingMapper.";

    public List<RoutingDTO> list(String keyword, Integer itemId) {
        Map<String, Object> map = new HashMap<>();
        map.put("keyword", keyword);
        map.put("itemId", itemId);
        return sqlSession.selectList(NS + "selectRoutingList", map);
    }

    public List<RoutingDTO> selectItemOptions() {
        return sqlSession.selectList(NS + "selectItemOptions");
    }

    public List<RoutingDTO> selectEquipOptions() {
        return sqlSession.selectList(NS + "selectEquipOptions");
    }

    public int getNextId() {
        return sqlSession.selectOne(NS + "getNextRoutingId");
    }

    public int insert(RoutingDTO dto) {
        return sqlSession.insert(NS + "insertRouting", dto);
    }

    public int update(RoutingDTO dto) {
        return sqlSession.update(NS + "updateRouting", dto);
    }

    public RoutingDTO selectById(int routingId) {
        return sqlSession.selectOne("kr.or.mes2.mappers.RoutingMapper.getRoutingDetail", routingId);
    }

    public int delete(int routingId) {
        return sqlSession.delete(NS + "deleteRouting", routingId);
    }

    public void reorderOnInsert(int itemId, int insertStep) {
        Map<String, Object> map = new HashMap<>();
        map.put("itemId", itemId);
        map.put("insertStep", insertStep);
        sqlSession.update(NS + "shiftRoutingStepsOnInsert", map);
    }

    public void reorderOnDelete(int itemId, int deletedStep) {
        Map<String, Object> map = new HashMap<>();
        map.put("itemId", itemId);
        map.put("deletedStep", deletedStep);
        sqlSession.update(NS + "shiftRoutingStepsOnDelete", map);
    }

    public RoutingDTO getRoutingDetail(int routingId) {
        return sqlSession.selectOne(NS + "getRoutingDetail", routingId);
    }

    public int checkRemainingCount(int itemId) {
        return sqlSession.selectOne(NS + "checkRemainingRoutingCount", itemId);
    }

    public void resetRoutingSequence(int itemId) {
        sqlSession.update(NS + "resetRoutingSequence", itemId);
    }
}
