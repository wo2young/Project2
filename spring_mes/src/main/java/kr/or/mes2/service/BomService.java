package kr.or.mes2.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.mes2.dao.BomDAO;
import kr.or.mes2.dto.BomDTO;
import kr.or.mes2.dto.ItemMasterDTO;

@Service
public class BomService {

    @Autowired
    private BomDAO dao;

    public List<BomDTO> list(String keyword, String type) {
        return dao.getBomList(keyword, type);
    }

    public String insert(BomDTO dto) {
        if (dao.countDuplicate(dto) > 0) return "duplicate";
        int nextId = dao.getNextBomId();
        dto.setBomId(nextId);
        dao.insertBom(dto);
        return "success";
    }

    public String update(BomDTO dto) {
        if (dao.countDuplicate(dto) > 0) return "duplicate";
        dao.updateBom(dto);
        return "success";
    }

    public String delete(int bomId, int childItem) {
        if (dao.countParentReference(childItem) > 0) return "used";
        dao.deleteBom(bomId);
        return "success";
    }

    public List<ItemMasterDTO> getParentItems() {
        return dao.getParentItems();
    }

    public List<ItemMasterDTO> getChildItems() {
        return dao.getChildItems();
    }
}
