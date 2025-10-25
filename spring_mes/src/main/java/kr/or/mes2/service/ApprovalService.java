package kr.or.mes2.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import kr.or.mes2.dao.ApprovalDAO;
import kr.or.mes2.dto.ApprovalDTO;

@Service
public class ApprovalService {

    @Autowired
    private ApprovalDAO dao;

    public List<ApprovalDTO> getPendingApprovals() {
        return dao.selectPendingApprovals();
    }

    public void approve(ApprovalDTO dto) {
        dao.approveRequest(dto);
    }

    public void reject(ApprovalDTO dto) {
        dao.rejectRequest(dto);
    }
}
