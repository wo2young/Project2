package kr.or.mes2.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import kr.or.mes2.dto.DashboardDTO;
import kr.or.mes2.service.DashboardService;
import java.util.List;

@Controller
public class DashboardController {

    @Autowired
    private DashboardService service;

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        try {
            // ✅  이번달 목표 vs 실적 추가
            List<DashboardDTO> targetVsActual = service.selectTargetVsActualMonth();
            model.addAttribute("targetVsActual", targetVsActual);

            // (로그 확인용)
            System.out.println("=== targetVsActual ===");
            if (targetVsActual != null) {
                for (DashboardDTO d : targetVsActual) {
                    System.out.println(d.getLabel() + " / " + d.getPercent());
                }
            } else {
                System.out.println("targetVsActual is NULL");
            }

            // ✅  상단 요약
            DashboardDTO summary = service.getTodaySummary();
            if (summary == null) {
                summary = new DashboardDTO();
                summary.setGoodQty(0);
                summary.setDefectQty(0);
            }

            int todayProd = summary.getGoodQty();
            int todayDef = summary.getDefectQty();
            double defectRate = (todayProd + todayDef) == 0 ? 0
                    : Math.round((double) todayDef / (todayProd + todayDef) * 10000) / 100.0;

            model.addAttribute("summary", summary);
            model.addAttribute("defectRate", defectRate);

            // ✅  다른 그래프 데이터
            model.addAttribute("weeklyProd", service.getWeeklyProduction());
            model.addAttribute("defSummary", service.getDefectSummary());
            model.addAttribute("inventoryList", service.getInventorySummary());
            model.addAttribute("equipOEE", service.getEquipmentOEE());
            model.addAttribute("approvalStat", service.getApprovalStatus());

        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("dashError", e.getMessage());
        }

        return "dashboard";
    }
}
