package kr.or.mes2.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.or.mes2.dto.DashboardDTO;

@Repository
public class DashboardDAO {

    @Autowired
    private SqlSession sqlSession;
    private static final String NS = "kr.or.mes2.mapper.DashboardMapper.";

    public DashboardDTO selectTodaySummary() { return sqlSession.selectOne(NS + "selectTodaySummary"); }
    public List<DashboardDTO> selectProdLast7() { return sqlSession.selectList(NS + "selectProdLast7"); }
    public List<DashboardDTO> selectTargetVsActualMonth() { return sqlSession.selectList(NS + "selectTargetVsActualMonth"); }
    public List<DashboardDTO> selectDefectPieMonth() { return sqlSession.selectList(NS + "selectDefectPieMonth"); }
    public List<DashboardDTO> selectInventoryStatus() { return sqlSession.selectList(NS + "selectInventoryStatus"); }
    public List<DashboardDTO> selectEquipmentOEE() { return sqlSession.selectList(NS + "selectEquipmentOEE"); }
    public List<DashboardDTO> selectApprovalStatus() { return sqlSession.selectList(NS + "selectApprovalStatus"); }
 
}
