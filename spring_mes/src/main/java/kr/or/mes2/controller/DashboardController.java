package kr.or.mes2.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import kr.or.mes2.dto.DashboardDTO;
import kr.or.mes2.service.DashboardService;

@Controller
public class DashboardController {

    @Autowired
    private DashboardService service;

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        try {
            DashboardDTO summary = service.getTodaySummary();

            // summary가 null일 경우 대비
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

            model.addAttribute("weeklyProd", service.getWeeklyProduction());
            model.addAttribute("monthPerf", service.getItemPerformance());
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
