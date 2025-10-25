package kr.or.mes2.controller;

import java.util.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import kr.or.mes2.dto.QualityDefectStatisticsDTO;
import kr.or.mes2.service.QualityDefectStatisticsService;

@Controller
@RequestMapping("/quality/defect")
public class QualityDefectStatisticsController {

    @Autowired
    private QualityDefectStatisticsService service;

    /**
     * ✅ 불량 통계 메인 페이지
     * - JSP: /WEB-INF/views/quality/QualityDefectStatistics.jsp
     * - URL: /quality/defect/statistics
     */
    @GetMapping("/statistics")
    public String showStatisticsPage() {
        return "quality/QualityDefectStatistics";
    }

    /**
     * ✅ AJAX 요청 (완제품 / 반제품 선택 시)
     * - URL 예시:
     *   /quality/defect/statistics/data?type=PCD
     *   /quality/defect/statistics/data?type=SGD
     */
    @ResponseBody
    @GetMapping("/statistics/data")
    public Map<String, Object> getStatisticsData(
            @RequestParam(value = "type", required = false, defaultValue = "PCD") String type) {

        Map<String, Object> result = new HashMap<>();
        try {
            // ✅ TYPE 안전 처리
            type = (type == null || type.isBlank()) ? "PCD" : type.trim().toUpperCase();

            System.out.println("📊 [불량통계] 요청된 TYPE: " + type);

            // ✅ 1️⃣ 상단 요약 통계
            QualityDefectStatisticsDTO summary = service.getStatisticsByType(type);
            if (summary == null) {
                summary = new QualityDefectStatisticsDTO();
                summary.setProductTypeCode(type);
                summary.setTotalQty(0);
                summary.setDefectQty(0);
                summary.setDefectRate(0);
            }

            // ✅ 2️⃣ 불량유형별 승인건 수량
            List<Map<String, Object>> defectTypeStats = service.getDefectNameStatsByItemType(type);
            if (defectTypeStats == null) defectTypeStats = new ArrayList<>();

            // ✅ 3️⃣ 정상 응답 구조
            result.put("status", "success");
            result.put("summary", summary);
            result.put("defectTypeStats", defectTypeStats);

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("❌ [불량통계] 데이터 조회 오류: " + e.getMessage());

            result.put("status", "error");
            result.put("message", "데이터 조회 중 오류가 발생했습니다.");
            result.put("summary", new QualityDefectStatisticsDTO());
            result.put("defectTypeStats", Collections.emptyList());
        }

        return result;
    }
}
