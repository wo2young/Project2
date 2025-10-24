package kr.or.mes2.controller;

import java.util.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import kr.or.mes2.dto.ProductionOrderDTO;
import kr.or.mes2.service.ProductionOrderService;

@Controller
@RequestMapping("/order")
public class ProductionOrderController {

    @Autowired
    private ProductionOrderService service;

    /** ✅ 기본 경로(/order)로 접근 시 자동 /list 이동 */
    @GetMapping
    public String redirectToList() {
        return "redirect:/order/list";
    }

    /** ✅ 생산지시 메인 페이지 (목표, 설비, 지시 리스트) */
    @GetMapping("/list")
    public String orderList(Model model) {
        model.addAttribute("targetList", service.getTargetList());
        model.addAttribute("equipList", service.getEquipList());
        model.addAttribute("orderList", service.getOrderList());
        return "productionOrder";
    }

    /** ✅ 생산지시 등록 */
    @PostMapping("/insert")
    @ResponseBody
    public String insertOrder(@RequestBody ProductionOrderDTO dto) {
        try {
            service.insertOrder(dto);
            return "OK";
        } catch (Exception e) {
            e.printStackTrace();
            return "ERROR";
        }
    }

    /** ✅ 상태 변경 */
    @PostMapping("/updateStatus")
    @ResponseBody
    public String updateOrderStatus(@RequestBody ProductionOrderDTO dto) {
        try {
            service.updateOrderStatus(dto);
            return "OK";
        } catch (Exception e) {
            e.printStackTrace();
            return "ERROR";
        }
    }

    /** ✅ Ajax - 라우팅 조회 (item_id 기준) */
    @GetMapping(value="/routing", produces="application/json; charset=UTF-8")
    @ResponseBody
    public List<ProductionOrderDTO> getRouting(@RequestParam int itemId) {
        return service.getRoutingList(itemId);
    }

    /** ✅ Ajax - BOM 조회 (item_id 기준) */
    @GetMapping(value="/bom", produces="application/json; charset=UTF-8")
    @ResponseBody
    public List<ProductionOrderDTO> getBom(@RequestParam int itemId) {
        return service.getBomChildren(itemId);
    }
}
