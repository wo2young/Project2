package kr.or.mes2.dao;

import java.util.*;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import kr.or.mes2.dto.ProductionOrderDTO;

@Repository
public class ProductionOrderDAO {

    @Autowired
    private SqlSession sqlSession;

    private static final String NS = "kr.or.mes2.mappers.ProductionOrderMapper.";

    public List<ProductionOrderDTO> getTargetList() {
        return sqlSession.selectList(NS + "getTargetList");
    }

    public List<ProductionOrderDTO> getEquipList() {
        return sqlSession.selectList(NS + "getEquipList");
    }

    public List<ProductionOrderDTO> getOrderList() {
        return sqlSession.selectList(NS + "getOrderList");
    }

    public void insertOrder(ProductionOrderDTO dto) {
        sqlSession.insert(NS + "insertOrder", dto);
    }

    public void updateOrderStatus(ProductionOrderDTO dto) {
        sqlSession.update(NS + "updateOrderStatus", dto);
    }

    public void updateEquipmentStatus(int equipId, String equipStatus) {
        Map<String, Object> map = new HashMap<>();
        map.put("equipId", equipId);
        map.put("equipStatus", equipStatus);
        sqlSession.update(NS + "updateEquipmentStatus", map);
    }

    public void insertEquipmentLogStart(ProductionOrderDTO dto) {
        sqlSession.insert(NS + "insertEquipmentLogStart", dto);
    }

    public void updateEquipmentLogEnd(int orderId) {
        sqlSession.update(NS + "updateEquipmentLogEnd", orderId);
    }

    public List<ProductionOrderDTO> getRoutingList(int itemId) {
        return sqlSession.selectList(NS + "getRoutingList", itemId);
    }

    public List<ProductionOrderDTO> getBomChildren(int itemId) {
        return sqlSession.selectList(NS + "getBomChildren", itemId);
    }
}
