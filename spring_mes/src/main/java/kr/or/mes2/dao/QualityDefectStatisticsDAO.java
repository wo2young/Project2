package kr.or.mes2.dao;

import java.util.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;
import kr.or.mes2.dto.QualityDefectStatisticsDTO;

@Repository
public class QualityDefectStatisticsDAO {

    @Autowired
    private SqlSessionTemplate sqlSession;

    private static final String NS = "kr.or.mes2.mappers.QualityDefectStatisticsMapper.";

    /** ✅ 전체 요약 */
    public QualityDefectStatisticsDTO getSummary() {
        return sqlSession.selectOne(NS + "getSummary");
    }

    /** ✅ 완제품/반제품별 불량률 (type: 'PCD' / 'SGD') */
    public List<Map<String, Object>> getProductTypeDefectRate(String type) {
        return sqlSession.selectList(NS + "getProductTypeDefectRate", type);
    }
}
