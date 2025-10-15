package kr.or.mes2.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.mes2.dao.DashboardDAO;
import kr.or.mes2.dto.DashboardDTO;

@Service
public class DashboardService {

    @Autowired
    private DashboardDAO dao;

    // 1️⃣ 오늘 요약
    public DashboardDTO getTodaySummary() {
        return dao.selectTodaySummary();
    }

    // 2️⃣ 최근 7일 생산량
    public List<DashboardDTO> getWeeklyProduction() {
        return dao.selectProdLast7();
    }

    // 3️⃣ 이번달 목표 vs 실적
    public List<DashboardDTO> getItemPerformance() {
        return dao.selectTargetVsActualMonth();
    }

    // 4️⃣ 불량 현황
    public List<DashboardDTO> getDefectSummary() {
        return dao.selectDefectPieMonth();
    }

    // 5️⃣ 재고 현황
    public List<DashboardDTO> getInventorySummary() {
        return dao.selectInventoryStatus();
    }

    // 6️⃣ 설비별 가동률
    public List<DashboardDTO> getEquipmentOEE() {
        return dao.selectEquipmentOEE();
    }

    // 7️⃣ 승인 요청 상태
    public List<DashboardDTO> getApprovalStatus() {
        return dao.selectApprovalStatus();
    }
}
