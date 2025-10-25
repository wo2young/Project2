package kr.or.mes2.dao;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import kr.or.mes2.dto.ApprovalDTO;

@Repository
public class ApprovalDAO {

    @Autowired
    private SqlSession sqlSession;

    private static final String NS = "kr.or.mes2.mapper.ApprovalMapper.";

    public List<ApprovalDTO> selectPendingApprovals() {
        return sqlSession.selectList(NS + "selectPendingApprovals");
    }

    public int approveRequest(ApprovalDTO dto) {
        return sqlSession.update(NS + "approveRequest", dto);
    }

    public int rejectRequest(ApprovalDTO dto) {
        return sqlSession.update(NS + "rejectRequest", dto);
    }
}
