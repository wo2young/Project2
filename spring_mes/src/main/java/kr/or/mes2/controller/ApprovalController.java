package kr.or.mes2.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import kr.or.mes2.dto.ApprovalDTO;
import kr.or.mes2.service.ApprovalService;
import java.util.List;

@Controller
@RequestMapping("/admin/approval")
public class ApprovalController {

    @Autowired
    private ApprovalService service;

    @GetMapping("")
    public String approvalList(Model model) {
        List<ApprovalDTO> list = service.getPendingApprovals();
        model.addAttribute("approvalList", list);
        return "admin/approval";
    }

    @PostMapping("/approve")
    public String approve(@ModelAttribute ApprovalDTO dto) {
        service.approve(dto);
        return "redirect:/admin/approval";
    }

    @PostMapping("/reject")
    public String reject(@ModelAttribute ApprovalDTO dto) {
        service.reject(dto);
        return "redirect:/admin/approval";
    }
}
