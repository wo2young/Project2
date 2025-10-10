package kr.or.human99.dao;

import java.util.*;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class DashboardDAO {

    @Autowired
    private SqlSession sqlSession;
    private static final String NS = "kr.or.human99.mapper.DashboardMapper.";

    public Map<String, Object> selectTodaySummary() {
        return sqlSession.selectOne(NS + "selectTodaySummary");
    }
    public List<Map<String, Object>> selectProdLast7() {
        return sqlSession.selectList(NS + "selectProdLast7");
    }
    public List<Map<String, Object>> selectTargetVsActualMonth() {
        return sqlSession.selectList(NS + "selectTargetVsActualMonth");
    }
    public List<Map<String, Object>> selectDefectPieMonth() {
        return sqlSession.selectList(NS + "selectDefectPieMonth");
    }
    public List<Map<String, Object>> selectInventoryStatus() {
        return sqlSession.selectList(NS + "selectInventoryStatus");
    }

    // 더미 데이터 유지
    public List<Map<String, Object>> selectEquipmentOEE() {
        return List.of(
            Map.of("label", "충전기1", "value", 92),
            Map.of("label", "충전기2", "value", 88),
            Map.of("label", "포장기1", "value", 95),
            Map.of("label", "포장기2", "value", 91)
        );
    }

    public List<Map<String, Object>> selectApprovalStatus() {
        return List.of(
            Map.of("label", "승인", "value", 5),
            Map.of("label", "대기", "value", 2),
            Map.of("label", "반려", "value", 1)
        );
    }
}
