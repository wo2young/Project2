package kr.or.mes2.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.or.mes2.dto.QualityDefectDTO;
import kr.or.mes2.dto.CodeDTO;

@Repository
public class QualityDefectDAO {

    @Autowired
    private SqlSession sqlSession;

    private static final String NS = "kr.or.mes2.mappers.QualityDefectMapper.";

    /** ✅ 불량 목록 조회 */
    public List<QualityDefectDTO> getDefectList() {
        return sqlSession.selectList(NS + "getDefectList");
    }

    /** ✅ 검사 완료된 인벤토리 목록 조회 */
    public List<QualityDefectDTO> getInventoryList() {
        return sqlSession.selectList(NS + "getInventoryList");
    }

    /** ✅ 불량 코드 목록 조회 */
    public List<CodeDTO> getDefectCodes() {
        return sqlSession.selectList(NS + "getDefectCodes");
    }

    /** ✅ 불량 등록 */
    public void insertDefect(QualityDefectDTO dto) {
        sqlSession.insert(NS + "insertDefect", dto);
    }

    /** ✅ 자바단 PK 생성용 (MAX + 1) */
    public int getNextDefectId() {
        return sqlSession.selectOne(NS + "getNextDefectId");
    }

    /** ✅ 총 불량 수량 조회 */
    public int getTotalDefectQty(int inspectionId) {
        return sqlSession.selectOne(NS + "getTotalDefectQty", inspectionId);
    }

    /** ✅ 남은 불량 수량 조회 */
    public int getRemainingDefectQty(int inspectionId) {
        return sqlSession.selectOne(NS + "getRemainingDefectQty", inspectionId);
    }
}
