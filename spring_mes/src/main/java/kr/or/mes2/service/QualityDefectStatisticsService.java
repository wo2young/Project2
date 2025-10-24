package kr.or.mes2.service;

import java.util.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import kr.or.mes2.dao.QualityDefectStatisticsDAO;
import kr.or.mes2.dto.QualityDefectStatisticsDTO;

@Service
public class QualityDefectStatisticsService {

    @Autowired
    private QualityDefectStatisticsDAO dao;

    /** ✅ 전체 요약 조회 */
    public QualityDefectStatisticsDTO getSummary() {
        return dao.getSummary();
    }

    /** ✅ 완제품/반제품별 불량률 조회 (type: 'PCD' or 'SGD') */
    public List<Map<String, Object>> getProductTypeDefectRate(String type) {
        return dao.getProductTypeDefectRate(type);
    }
}
