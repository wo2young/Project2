package kr.or.mes2.dao;

import java.util.*;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import kr.or.mes2.dto.RoutingDTO;

@Repository
public class RoutingDAO {
    @Autowired
    private SqlSession sql;

    public List<Map<String, Object>> itemOptions() {
        return sql.selectList("kr.or.mes2.mappers.RoutingMapper.selectItemOptions");
    }

    public List<Map<String, Object>> equipOptions() {
        return sql.selectList("kr.or.mes2.mappers.RoutingMapper.selectEquipOptions");
    }

    public List<RoutingDTO> list(Integer itemId, String keyword) {
        Map<String, Object> map = new HashMap<>();
        map.put("itemId", itemId);
        map.put("keyword", keyword);
        return sql.selectList("kr.or.mes2.mappers.RoutingMapper.selectRoutingList", map);
    }

    public RoutingDTO findById(int routingId) {
        return sql.selectOne("kr.or.mes2.mappers.RoutingMapper.findById", routingId);
    }

    public int insert(RoutingDTO dto) {
        return sql.insert("kr.or.mes2.mappers.RoutingMapper.insertRouting", dto);
    }

    public int update(RoutingDTO dto) {
        return sql.update("kr.or.mes2.mappers.RoutingMapper.updateRouting", dto);
    }

    public int delete(int routingId) {
        return sql.delete("kr.or.mes2.mappers.RoutingMapper.deleteRouting", routingId);
    }
}
