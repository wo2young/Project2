package kr.or.mes2.controller;

import java.util.*;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import kr.or.mes2.dto.QualityInspectionDTO;
import kr.or.mes2.dto.UserDTO;
import kr.or.mes2.service.QualityInspectionService;

@Controller
@RequestMapping("/quality")
public class QualityInspectionController {

    @Autowired
    private QualityInspectionService inspectionService;

    /** ✅ 품질검사 등록 페이지 */
    @GetMapping("/inspection")
    public String showInspectionPage(Model model, HttpSession session) {
        try {
            // ✅ 검사 대상 목록 (STATUS='CONFIRMED')
            List<QualityInspectionDTO> inventoryList = inspectionService.getInventoryList();
            model.addAttribute("inventoryList", inventoryList);

            // ✅ 기존 등록된 품질검사 목록
            List<QualityInspectionDTO> inspectionList = inspectionService.getInspectionList();
            model.addAttribute("inspectionList", inspectionList);

            // ✅ 로그인 사용자 정보
            UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
            if (loginUser != null) {
                model.addAttribute("loginUserId", loginUser.getUserId());
                model.addAttribute("loginUserName", loginUser.getName());
            }

            // ✅ 메시지 처리
            if (session.getAttribute("msg") != null) {
                model.addAttribute("msg", session.getAttribute("msg"));
                session.removeAttribute("msg");
            }
            if (session.getAttribute("errorMsg") != null) {
                model.addAttribute("errorMsg", session.getAttribute("errorMsg"));
                session.removeAttribute("errorMsg");
            }

        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("errorMsg", "페이지 로딩 중 오류: " + e.getMessage());
        }

        // ✅ JSP 경로
        return "quality/QualityInspection";
    }

    /** ✅ 품질검사 등록 처리 */
    @PostMapping("/inspection/add")
    public String addInspection(@ModelAttribute QualityInspectionDTO dto, HttpSession session) {
        try {
            // ✅ 로그인 검사
            UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
            if (loginUser == null) {
                session.setAttribute("errorMsg", "로그인 후 이용 가능합니다.");
                return "redirect:/login";
            }

            // ✅ 검사자 ID 자동 세팅
            dto.setInspectorId(loginUser.getUserId());

            // ✅ ITEM_TYPE_CODE → INSPECT_TYPE 매핑 (TXN 기준)
            String itemTypeCode = inspectionService.getItemTypeCodeByTxn(dto.getTxnId());
            if (itemTypeCode != null) {
                switch (itemTypeCode) {
                    case "RMD": dto.setInspectType("RECEIVING"); break;
                    case "SGD": dto.setInspectType("IN_PROCESS"); break;
                    case "PCD": dto.setInspectType("FINAL"); break;
                    default: dto.setInspectType("UNKNOWN");
                }
            } else {
                dto.setInspectType("UNKNOWN");
            }

            // ✅ 기본값 보정
            if (dto.getDefectQty() == null) dto.setDefectQty(0);

            // ✅ 등록 실행 (Service에서 TOTAL_QTY 자동 세팅 + 상태 'ING' 변경)
            inspectionService.insertInspection(dto);

            // ✅ 메시지 처리
            session.setAttribute("msg", "✅ 품질검사 등록이 완료되었습니다.");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "등록 중 오류 발생: " + e.getMessage());
        }

        return "redirect:/quality/inspection";
    }

    /** ✅ AJAX: TXN_ID 선택 시 ITEM_TYPE_CODE → INSPECT_TYPE 자동 조회 */
    @GetMapping("/getItemTypeCode")
    @ResponseBody
    public Map<String, Object> getItemTypeCode(@RequestParam("txnId") int txnId) {
        Map<String, Object> response = new HashMap<>();
        try {
            String itemTypeCode = inspectionService.getItemTypeCodeByTxn(txnId);
            String inspectType = null;

            if (itemTypeCode != null) {
                switch (itemTypeCode) {
                    case "RMD": inspectType = "RECEIVING"; break;
                    case "SGD": inspectType = "IN_PROCESS"; break;
                    case "PCD": inspectType = "FINAL"; break;
                }
            }

            response.put("itemTypeCode", itemTypeCode);
            response.put("inspectType", inspectType);
        } catch (Exception e) {
            e.printStackTrace();
            response.put("error", "조회 중 오류 발생: " + e.getMessage());
        }
        return response;
    }
}
