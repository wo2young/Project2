package kr.or.mes2.controller;

import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.mes2.dto.QualityDefectDTO;
import kr.or.mes2.dto.CodeDTO;
import kr.or.mes2.dto.UserDTO;
import kr.or.mes2.service.QualityDefectService;

@Controller
@RequestMapping("/quality")
public class QualityDefectController {

    @Autowired
    private QualityDefectService defectService;

    /**
     * ✅ 불량관리 메인 페이지
     */
    @GetMapping("/defect")
    public String showDefectPage(Model model) {
        try {
            // ✅ 등록된 불량 목록
            List<QualityDefectDTO> defectList = defectService.getDefectList();
            model.addAttribute("defectList", defectList);

            // ✅ 검사 완료된 인벤토리 목록
            List<QualityDefectDTO> inventoryList = defectService.getInventoryList();
            model.addAttribute("inventoryList", inventoryList);

            // ✅ 불량 코드 목록
            List<CodeDTO> defectCodes = defectService.getDefectCodes();
            model.addAttribute("defectCodes", defectCodes);

            // ✅ JSP 경로 수정
            return "quality/QualityDefect";

        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("errorMsg", "데이터 조회 중 오류가 발생했습니다.");
            return "quality/QualityDefect";
        }
    }

    /**
     * ✅ 불량 등록 처리
     */
    @PostMapping("/defect/add")
    public String addDefect(
            @ModelAttribute QualityDefectDTO dto,
            HttpSession session,
            RedirectAttributes redirectAttrs) {
        try {
            UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
            if (loginUser == null) {
                redirectAttrs.addFlashAttribute("errorMsg", "로그인이 필요합니다.");
                return "redirect:/quality/defect";
            }

            dto.setApprovedBy(loginUser.getUserId());
            defectService.insertDefect(dto);

            // ✅ URL에 안 붙고, 1회만 표시되는 메시지
            redirectAttrs.addFlashAttribute("msg", "불량이 성공적으로 등록되었습니다.");

            return "redirect:/quality/defect";

        } catch (Exception e) {
            e.printStackTrace();
            redirectAttrs.addFlashAttribute("errorMsg", "불량 등록 중 오류가 발생했습니다.");
            return "redirect:/quality/defect";
        }
    }

    /**
     * ✅ 총 불량 수량 + 남은 불량 수량 조회 (AJAX)
     */
    @ResponseBody
    @GetMapping("/defect/qtyinfo/{inspectionId}")
    public Map<String, Object> getDefectQtyInfo(@PathVariable("inspectionId") int inspectionId) {
        try {
            return defectService.getDefectQtyInfo(inspectionId);
        } catch (Exception e) {
            e.printStackTrace();
            return Map.of("totalQty", 0, "remainingQty", 0);
        }
    }
}
