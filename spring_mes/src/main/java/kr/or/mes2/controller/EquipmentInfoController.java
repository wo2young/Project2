package kr.or.mes2.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import kr.or.mes2.dto.EquipmentInfoDTO;
import kr.or.mes2.service.EquipmentInfoService;

@Controller
@RequestMapping("/master/equip")
public class EquipmentInfoController {

    @Autowired
    private EquipmentInfoService service;

    @GetMapping
    public String list(@RequestParam(value="keyword", required=false) String keyword,
                       @RequestParam(value="detailCode", required=false) String detailCode,
                       Model model) {

        List<EquipmentInfoDTO> equipList = service.list(keyword, detailCode);
        model.addAttribute("equipList", equipList);

        // ✅ CODE_DETAIL에서 완제품/반제품만
        List<EquipmentInfoDTO> productGroupList = service.getProductGroupList();
        model.addAttribute("productGroupList", productGroupList);

        model.addAttribute("keyword", keyword);
        model.addAttribute("detailCode", detailCode);
        model.addAttribute("activeNav", "equip");
        return "master/equip";
    }

    @PostMapping("/add")
    @ResponseBody
    public String add(EquipmentInfoDTO dto) {
        return service.add(dto) ? "success" : "duplicate";
    }

    @PostMapping("/edit")
    @ResponseBody
    public String edit(EquipmentInfoDTO dto) {
        service.edit(dto);
        return "success";
    }

    @PostMapping("/delete")
    @ResponseBody
    public String delete(@RequestParam("equipId") int equipId) {
        return service.remove(equipId) > 0 ? "success" : "fail";
    }
}
