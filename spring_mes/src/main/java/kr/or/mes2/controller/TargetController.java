package kr.or.mes2.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import kr.or.mes2.dto.TargetDTO;
import kr.or.mes2.dto.UserDTO;
import kr.or.mes2.service.TargetService;

@RequestMapping("/target")
@Controller
public class TargetController {

    @Autowired
    private TargetService targetService;

    // ✅ 리스트 페이지 (target.jsp)
    @GetMapping("/list")
    public String targetList(String searchStart, String searchEnd, Model model, HttpSession session) {

        Map<String, Object> params = new HashMap<>();
        params.put("searchStart", searchStart);
        params.put("searchEnd", searchEnd);

        List<TargetDTO> targetList = targetService.getTargetList(params);
        model.addAttribute("targetList", targetList);

        List<TargetDTO> itemList = targetService.getPCDnames();
        model.addAttribute("itemList", itemList);

        String msg = (String) session.getAttribute("msg");
        String errorMsg = (String) session.getAttribute("errorMsg");
        if (msg != null) {
            model.addAttribute("msg", msg);
            session.removeAttribute("msg");
        }
        if (errorMsg != null) {
            model.addAttribute("errorMsg", errorMsg);
            session.removeAttribute("errorMsg");
        }

        return "target"; // ✅ JSP 파일 이름 그대로
    }

    // ✅ 등록
    @PostMapping("/insert")
    public String saveTarget(@ModelAttribute TargetDTO dto, HttpSession session, RedirectAttributes redirect) {
        try {
            UserDTO user = (UserDTO) session.getAttribute("loginUser");
            if (user != null) {
                dto.setCreatedBy(user.getUserId());
            }
            targetService.insertTarget(dto);
            session.setAttribute("msg", "등록이 완료되었습니다.");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "등록 중 오류가 발생했습니다.");
        }
        return "redirect:/target/list";
    }

    // ✅ 수정
    @PostMapping("/update")
    public String updateTarget(@ModelAttribute TargetDTO dto, HttpSession session) {
        try {
            // 👉 생산지시 총합 조회
            int orderSum = targetService.getOrderQtySumByTarget(dto.getTargetId());

            // ✅ 목표 수량 검증: 지시수량보다 적으면 불가
            if (dto.getTargetQty() < orderSum) {
                session.setAttribute("errorMsg",
                    "이미 생성된 생산지시(" + orderSum + "개)보다 작은 목표로 수정할 수 없습니다.");
                return "redirect:/target/list";
            }

            // ✅ 날짜 검증 (선택적으로 추가 가능)
            if (dto.getStartDate().after(dto.getEndDate())) {
                session.setAttribute("errorMsg", "시작일은 종료일 이후일 수 없습니다.");
                return "redirect:/target/list";
            }

            // ✅ 수정 실행
            targetService.updateTarget(dto);
            session.setAttribute("msg", "수정이 완료되었습니다.");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "수정 중 오류가 발생했습니다.");
        }
        return "redirect:/target/list";
    }

    // ✅ 삭제
    @PostMapping("/delete")
    public String deleteTarget(int targetId, HttpSession session) {
        try {
            targetService.deleteTarget(targetId);
            session.setAttribute("msg", "삭제가 완료되었습니다.");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "삭제 중 오류가 발생했습니다.");
        }
        return "redirect:/target/list";
    }
}
