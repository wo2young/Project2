package kr.or.mes2.service;

import java.util.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import kr.or.mes2.dao.RoutingDAO;
import kr.or.mes2.dto.RoutingDTO;

@Service
public class RoutingService {
    @Autowired
    private RoutingDAO dao;

    public List<Map<String,Object>> itemOptions(){
        return dao.itemOptions();
    }

    public List<Map<String,Object>> equipOptions(){
        return dao.equipOptions();
    }

    public List<RoutingDTO> list(Integer itemId, String keyword){
        return dao.list(itemId, keyword);
    }

    public RoutingDTO findById(int routingId){
        return dao.findById(routingId);
    }

    public int insert(RoutingDTO dto){
        return dao.insert(dto);
    }

    public int update(RoutingDTO dto){
        return dao.update(dto);
    }

    public int delete(int id){
        return dao.delete(id);
    }
}
