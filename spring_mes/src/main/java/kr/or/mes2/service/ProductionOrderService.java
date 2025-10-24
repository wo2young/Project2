package kr.or.mes2.service;

import java.util.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import kr.or.mes2.dao.ProductionOrderDAO;
import kr.or.mes2.dto.ProductionOrderDTO;

@Service
public class ProductionOrderService {

    @Autowired
    private ProductionOrderDAO dao;

    public List<ProductionOrderDTO> getTargetList() {
        return dao.getTargetList();
    }

    public List<ProductionOrderDTO> getEquipList() {
        return dao.getEquipList();
    }

    public List<ProductionOrderDTO> getOrderList() {
        return dao.getOrderList();
    }

    @Transactional
    public void insertOrder(ProductionOrderDTO dto) {
        dao.insertOrder(dto);
    }

    @Transactional
    public void updateOrderStatus(ProductionOrderDTO dto) {
        dao.updateOrderStatus(dto);
        int equipId = dto.getEquipId();

        if ("IN_PROGRESS".equals(dto.getStatus())) {
            dao.updateEquipmentStatus(equipId, "RUNNING");
            dao.insertEquipmentLogStart(dto);
        } else if ("DONE".equals(dto.getStatus())) {
            dao.updateEquipmentStatus(equipId, "IDLE");
            dao.updateEquipmentLogEnd(dto.getOrderId());
        }
    }

    /** 라우팅 & BOM */
    public List<ProductionOrderDTO> getRoutingList(int itemId) {
        return dao.getRoutingList(itemId);
    }

    public List<ProductionOrderDTO> getBomChildren(int itemId) {
        return dao.getBomChildren(itemId);
    }
}
