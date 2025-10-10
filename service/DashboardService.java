package kr.or.human99.service;

import java.util.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import kr.or.human99.dao.DashboardDAO;

@Service
public class DashboardService {

    @Autowired
    private DashboardDAO dao;

    public Map<String, Object> getTodaySummary() { return dao.selectTodaySummary(); }
    public List<Map<String, Object>> getWeeklyProduction() { return dao.selectProdLast7(); }
    public List<Map<String, Object>> getItemPerformance() { return dao.selectTargetVsActualMonth(); }
    public List<Map<String, Object>> getDefectSummary() { return dao.selectDefectPieMonth(); }
    public List<Map<String, Object>> getInventorySummary() { return dao.selectInventoryStatus(); }
    public List<Map<String, Object>> getEquipmentOEE() { return dao.selectEquipmentOEE(); }
    public List<Map<String, Object>> getApprovalStatus() { return dao.selectApprovalStatus(); }
}
