package kr.or.mes2.service;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import kr.or.mes2.dao.TargetDAO;
import kr.or.mes2.dto.TargetDTO;

@Service
public class TargetService {

    @Autowired
    private TargetDAO targetDAO;

    public List<TargetDTO> getTargetList(Map<String, Object> params) {
        return targetDAO.getTargetList(params);
    }

    public List<TargetDTO> getPCDnames() {
        return targetDAO.getPCDitems();
    }

    public void insertTarget(TargetDTO dto) {
        targetDAO.insertTarget(dto);
    }

    public void updateTarget(TargetDTO dto) {
        targetDAO.updateTarget(dto);
    }

    public void deleteTarget(int targetId) {
        targetDAO.deleteTarget(targetId);
    }
    public int getOrderQtySumByTarget(int targetId) {
        return targetDAO.getOrderQtySumByTarget(targetId);
    }

}
