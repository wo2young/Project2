package kr.or.mes2.controller;

import java.util.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import kr.or.mes2.service.DashboardService;

@Controller
public class DashboardController {

    @Autowired
    private DashboardService service;

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        try {
            Map<String,Object> summary = service.getTodaySummary();
            int todayProd = ((Number)summary.get("GOOD")).intValue();
            int todayDef = ((Number)summary.get("DEFECT")).intValue();
            double defectRate = (todayProd + todayDef) == 0 ? 0
                : Math.round((double)todayDef / (todayProd + todayDef) * 10000) / 100.0;

            model.addAttribute("todayProd", todayProd);
            model.addAttribute("todayDef", todayDef);
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
