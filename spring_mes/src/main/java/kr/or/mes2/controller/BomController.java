package kr.or.mes2.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import kr.or.mes2.dto.BomDTO;
import kr.or.mes2.service.BomService;

@Controller
@RequestMapping("/master/bom")
public class BomController {

    @Autowired
    private BomService service;

    @GetMapping
    public String list(@RequestParam(value = "keyword", required = false) String keyword,
                       @RequestParam(value = "type", required = false) String type,
                       Model model) {
        model.addAttribute("list", service.list(keyword, type));
        model.addAttribute("keyword", keyword);
        model.addAttribute("type", type);
        model.addAttribute("parentList", service.getParentItems());
        model.addAttribute("childList", service.getChildItems());
        return "master/bom";
    }

    @PostMapping("/insert")
    @ResponseBody
    public String insert(@ModelAttribute BomDTO dto) {
        return service.insert(dto);
    }

    @PostMapping("/update")
    @ResponseBody
    public String update(@ModelAttribute BomDTO dto) {
        return service.update(dto);
    }

    @PostMapping("/delete")
    @ResponseBody
    public String delete(@RequestParam int bomId, @RequestParam int childItem) {
        return service.delete(bomId, childItem);
    }
}
