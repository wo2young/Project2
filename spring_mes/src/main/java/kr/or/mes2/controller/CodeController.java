package kr.or.mes2.controller;

import java.util.List;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.mes2.dto.CodeDTO;
import kr.or.mes2.service.CodeService;

@Controller
@RequestMapping("/master/code")
public class CodeController {

	@Autowired
	private CodeService service;

	@GetMapping({ "", "/" })
	public String codeList(HttpServletRequest req, Model model) {

		String codeId = req.getParameter("codeId");
		String keyword = req.getParameter("keyword");

		List<CodeDTO> masters = service.getMasterList();
		model.addAttribute("masterList", masters);

		List<CodeDTO> details;
		if ((codeId == null || codeId.isEmpty()) && (keyword == null || keyword.isEmpty())) {
			details = service.getDetailList(null, null);
		} else {
			details = service.getDetailList(codeId, keyword);
		}

		model.addAttribute("detailList", details);
		model.addAttribute("codeId", codeId);
		model.addAttribute("keyword", keyword);

		return "master/code";
	}

	@PostMapping("/master/insert")
	public String insertMaster(CodeDTO dto, RedirectAttributes rttr) {
		int result = service.insertMaster(dto);
		rttr.addFlashAttribute("msg", result > 0 ? "마스터 등록 성공" : "마스터 등록 실패");
		return "redirect:/master/code";
	}

	@PostMapping("/master/update")
	public String updateMaster(CodeDTO dto, RedirectAttributes rttr) {
		int result = service.updateMaster(dto);
		rttr.addFlashAttribute("msg", result > 0 ? "마스터 수정 성공" : "마스터 수정 실패");
		return "redirect:/master/code";
	}

	@PostMapping("/master/delete")
	public String deleteMaster(@RequestParam String codeId, RedirectAttributes rttr) {
		int result = service.deleteMaster(codeId);
		rttr.addFlashAttribute("msg", result > 0 ? "마스터 삭제 성공" : "마스터 삭제 실패");
		return "redirect:/master/code";
	}

	@PostMapping("/detail/insert")
	public String insertDetail(CodeDTO dto, RedirectAttributes rttr) {
		int result = service.insertDetail(dto);
		rttr.addFlashAttribute("msg", result > 0 ? "디테일 등록 성공" : "디테일 등록 실패");
		return "redirect:/master/code?codeId=" + dto.getCodeId();
	}

	@PostMapping("/detail/update")
	public String updateDetail(CodeDTO dto, RedirectAttributes rttr) {
		int result = service.updateDetail(dto);
		rttr.addFlashAttribute("msg", result > 0 ? "디테일 수정 성공" : "디테일 수정 실패");
		return "redirect:/master/code?codeId=" + dto.getCodeId();
	}

	@PostMapping("/detail/delete")
	public String deleteDetail(@RequestParam String detailCode, @RequestParam String codeId, RedirectAttributes rttr) {
		int result = service.deleteDetail(detailCode);
		rttr.addFlashAttribute("msg", result > 0 ? "디테일 삭제 성공" : "디테일 삭제 실패");
		return "redirect:/master/code?codeId=" + codeId;
	}

	// ✅ 디테일 코드 참조 여부 AJAX 체크
	@GetMapping("/detail/checkRefAll")
	@ResponseBody
	public int checkDetailRefAll(@RequestParam String detailCode) {
		return service.countAllRefByDetailCode(detailCode);
	}
}
