package kr.or.mes2.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import kr.or.mes2.dao.EquipmentInfoDAO;
import kr.or.mes2.dto.EquipmentInfoDTO;

@Service
public class EquipmentInfoService {

    @Autowired
    private EquipmentInfoDAO dao;

    public List<EquipmentInfoDTO> list(String keyword, String detailCode) {
        return dao.getEquipList(keyword, detailCode);
    }

    public boolean add(EquipmentInfoDTO dto) {
        if (dao.isDuplicateCode(dto.getEquipCode())) return false;
        int nextId = dao.getNextEquipId();
        dto.setEquipId(nextId);
        dao.insertEquip(dto);
        return true;
    }

    public int edit(EquipmentInfoDTO dto) {
        return dao.updateEquip(dto);
    }

    public int remove(int equipId) {
        return dao.deleteEquip(equipId);
    }

    // ✅ 제품군 목록 (CODE_DETAIL)
    public List<EquipmentInfoDTO> getProductGroupList() {
        return dao.getProductGroupList();
    }
}
