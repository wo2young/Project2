package kr.or.mes2.controller;

import java.util.*;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.mes2.service.QualityDefectStatisticsService;
import kr.or.mes2.dto.QualityDefectStatisticsDTO;

@Controller
@RequestMapping("/quality/defect")
public class QualityDefectStatisticsController {

    @Autowired
    private QualityDefectStatisticsService service;

    /** ✅ 불량 통계 메인 페이지 (기본: 완제품 기준) */
    @GetMapping("/statistics")
    public String showDefectStatistics(Model model) {
        try {
            // ✅ 전체 요약 (양품/불량/불량률)
            QualityDefectStatisticsDTO summary = service.getSummary();
            model.addAttribute("summary", summary);

            // ✅ 기본 그래프 데이터 (완제품 PCD)
            List<Map<String, Object>> typeRatio = service.getProductTypeDefectRate("PCD");
            model.addAttribute("typeLabels",
                    typeRatio.stream().map(m -> m.get("ITEM_NAME")).collect(Collectors.toList()));
            model.addAttribute("typeData",
                    typeRatio.stream().map(m -> m.get("DEFECT_RATE")).collect(Collectors.toList()));

        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("errorMsg", "통계 데이터 로딩 중 오류: " + e.getMessage());
        }

        // ✅ JSP 경로
        return "quality/QualityDefectStatistics";
    }

    /** ✅ AJAX 요청 (완제품 ↔ 반제품 전환 시) */
    @GetMapping("/statistics/data")
    @ResponseBody
    public Map<String, Object> getDefectStatisticsData(@RequestParam("type") String type) {
        Map<String, Object> result = new HashMap<>();
        try {
            List<Map<String, Object>> typeRatio = service.getProductTypeDefectRate(type);

            result.put("labels",
                    typeRatio.stream().map(m -> m.get("ITEM_NAME")).collect(Collectors.toList()));
            result.put("values",
                    typeRatio.stream().map(m -> m.get("DEFECT_RATE")).collect(Collectors.toList()));

        } catch (Exception e) {
            e.printStackTrace();
            result.put("error", "데이터 로딩 중 오류: " + e.getMessage());
        }
        return result;
    }
}
