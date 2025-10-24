package kr.or.mes2.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import kr.or.mes2.dao.RoutingDAO;
import kr.or.mes2.dto.RoutingDTO;

@Service
public class RoutingService {

    @Autowired
    private RoutingDAO dao;

    public List<RoutingDTO> list(String keyword, Integer itemId) {
        return dao.list(keyword, itemId);
    }

    public List<RoutingDTO> getItemOptions() {
        return dao.selectItemOptions();
    }

    public List<RoutingDTO> getEquipOptions() {
        return dao.selectEquipOptions();
    }

    public int insert(RoutingDTO dto) {
        int nextId = dao.getNextId();
        dto.setRoutingId(nextId);

        dao.reorderOnInsert(dto.getItemId(), dto.getProcessStep());

        return dao.insert(dto);
    }

    public int update(RoutingDTO dto) {
        return dao.update(dto);
    }

    public int delete(int routingId) {
        RoutingDTO target = dao.selectById(routingId);
        if (target == null) return 0;

        int result = dao.delete(routingId);

        if (result > 0) {
            int itemId = target.getItemId();
            int deletedStep = target.getProcessStep();

            dao.reorderOnDelete(itemId, deletedStep);

            int remaining = dao.checkRemainingCount(itemId);
            if (remaining == 0) {
                dao.resetRoutingSequence(itemId);
            }
        }

        return result;
    }

    public RoutingDTO getRoutingDetail(int routingId) {
        return dao.getRoutingDetail(routingId);
    }
}
