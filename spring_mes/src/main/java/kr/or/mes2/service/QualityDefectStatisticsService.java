package kr.or.mes2.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.mes2.dao.QualityDefectStatisticsDAO;
import kr.or.mes2.dto.QualityDefectStatisticsDTO;

@Service
public class QualityDefectStatisticsService {

    @Autowired
    private QualityDefectStatisticsDAO dao;

    /** ✅ 제품유형별 총수량 / 승인된 불량수량 / 불량률 조회 (type: 'PCD' or 'SGD') */
    public QualityDefectStatisticsDTO getStatisticsByType(String type) {
        return dao.getStatisticsByType(type);
    }

    /** ✅ 불량유형(DEFECT_NAME)별 승인된 불량수량 조회 */
    public List<Map<String, Object>> getDefectNameStatsByItemType(String type) {
        return dao.getDefectNameStatsByItemType(type);
    }
}
