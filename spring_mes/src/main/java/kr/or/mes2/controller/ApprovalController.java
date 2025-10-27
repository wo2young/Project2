package kr.or.mes2.controller;

import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import kr.or.mes2.dto.ApprovalDTO;
import kr.or.mes2.dto.UserDTO;
import kr.or.mes2.service.ApprovalService;

@Controller
@RequestMapping("/admin/approval")
public class ApprovalController {

    @Autowired
    private ApprovalService service;

    // 목록 조회
    @GetMapping
    public String approvalList(
            @RequestParam(defaultValue = "ALL") String status,
            @RequestParam(defaultValue = "1") int page,
            Model model) {

        int pageSize = 5;
        Map<String, Object> data = service.getPagedDefects(status, page, pageSize);

        List<ApprovalDTO> requests = (List<ApprovalDTO>) data.get("list");
        int totalCount = (int) data.get("totalCount");
        int totalPage = (int) Math.ceil((double) totalCount / pageSize);
        int startPage = ((page - 1) / 5) * 5 + 1;
        int endPage = Math.min(startPage + 4, totalPage);

        model.addAttribute("requests", requests);
        model.addAttribute("status", status);
        model.addAttribute("page", page);
        model.addAttribute("totalPage", totalPage);
        model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);

        return "admin/approval";
    }

    // 승인
    @PostMapping("/approve")
    public String approve(ApprovalDTO dto, HttpSession session,
                          @RequestParam(defaultValue = "PENDING") String status,
                          @RequestParam(defaultValue = "1") int page) {
        UserDTO user = (UserDTO) session.getAttribute("loginUser");
        if (user != null) {
            service.approve(dto, user.getUserId());
        }
        return "redirect:/admin/approval?status=" + status + "&page=" + page;
    }

    // 반려
    @PostMapping("/reject")
    public String reject(ApprovalDTO dto, HttpSession session,
                         @RequestParam(defaultValue = "PENDING") String status,
                         @RequestParam(defaultValue = "1") int page) {
        UserDTO user = (UserDTO) session.getAttribute("loginUser");
        if (user != null) {
            service.reject(dto, user.getUserId());
        }
        return "redirect:/admin/approval?status=" + status + "&page=" + page;
    }

}
