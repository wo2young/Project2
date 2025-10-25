package kr.or.mes2.dao;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import kr.or.mes2.dto.QualityDefectStatisticsDTO;

@Repository
public class QualityDefectStatisticsDAO {

    @Autowired
    private SqlSessionTemplate sqlSession;

    private static final String NS = "kr.or.mes2.mappers.QualityDefectStatisticsMapper.";

    /** ✅ 1️⃣ 제품유형별 총수량 / 승인된 불량수량 / 불량률 조회 (type: 'PCD' or 'SGD') */
    public QualityDefectStatisticsDTO getStatisticsByType(String type) {
        return sqlSession.selectOne(NS + "getStatisticsByType", type);
    }

    /** ✅ 2️⃣ 불량유형 코드(DEFECT_TYPE)별 승인된 불량수량 조회 */
    public List<Map<String, Object>> getDefectTypeStatsByItemType(String type) {
        return sqlSession.selectList(NS + "getDefectTypeStatsByItemType", type);
    }

    /** ✅ 3️⃣ CODE_DETAIL 기준 불량유형(DETAIL_NAME)별 승인된 불량수량 조회 */
    public List<Map<String, Object>> getDefectNameStatsByItemType(String type) {
        return sqlSession.selectList(NS + "getDefectNameStatsByItemType", type);
    }
}
