package kr.or.mes2.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.mes2.dto.CodeDTO;
import kr.or.mes2.dto.ItemMasterDTO;
import kr.or.mes2.service.ItemMasterService;

@Controller
public class ItemMasterController {

    @Autowired
    private ItemMasterService service;

    //TODO 첫화면
    @GetMapping("/master/item")
    public String list(Model model,
                       @RequestParam(required = false) String keyword,
                       @RequestParam(required = false) String typeFilter,
                       @RequestParam(required = false) String errorMsg) {

        List<ItemMasterDTO> list = service.list(keyword, typeFilter);
        List<CodeDTO> masterCodes = service.getItemKindMasterCodes();
        List<CodeDTO> detailCodes = service.getActiveItemKindCodes();

        model.addAttribute("list", list);
        model.addAttribute("masterCodes", masterCodes);
        model.addAttribute("detailCodes", detailCodes);
        model.addAttribute("errorMsg", errorMsg);

        return "master/item";
    }

    //TODO 제품 CRUD
    @PostMapping("/master/item/add")
    public String add(ItemMasterDTO dto, RedirectAttributes redirectAttrs) {
        List<CodeDTO> availableCodes = service.getAvailableDetailCodes(dto.getItemTypeCode());
        boolean isAvailable = availableCodes.stream()
            .anyMatch(c -> c.getDetailCode().equals(dto.getDetailCode()));

        if (!isAvailable) {
            redirectAttrs.addAttribute("errorMsg", "이미 등록된 코드입니다.");
            return "redirect:/master/item";
        }

        service.insert(dto);
        return "redirect:/master/item";
    }

    @PostMapping("/master/item/update")
    public String update(ItemMasterDTO dto) {
        service.update(dto);
        return "redirect:/master/item";
    }

    @PostMapping("/master/item/delete")
    public String delete(@RequestParam("itemId") int itemId) {
        service.delete(itemId);
        return "redirect:/master/item";
    }

    //TODO AJAX 코드확인
    @GetMapping("/master/item/detail-codes")
    @ResponseBody
    public List<CodeDTO> getAvailableDetailCodes(@RequestParam("codeId") String codeId) {
        return service.getAvailableDetailCodes(codeId);
    }
}
