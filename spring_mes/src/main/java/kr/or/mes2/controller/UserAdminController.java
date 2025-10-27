package kr.or.mes2.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.mes2.dto.UserDTO;
import kr.or.mes2.service.UserService;

@Controller
@RequestMapping("/admin/users")
public class UserAdminController {

	@Autowired
	private UserService userService;

	// 사용자 목록
	@GetMapping
	public String list(
	        @RequestParam(required = false) String q,
	        @RequestParam(defaultValue = "1") int page,
	        @RequestParam(defaultValue = "6") int size,
	        Model model) {

	    Map<String, Object> data = userService.getPagedUserList(q, page, size);

	    model.addAttribute("q", q);
	    model.addAttribute("list", data.get("list"));
	    model.addAttribute("page", data.get("page"));
	    model.addAttribute("size", data.get("size"));
	    model.addAttribute("total", data.get("totalCount"));
	    model.addAttribute("totalPage", data.get("totalPage"));
	    model.addAttribute("startPage", data.get("startPage"));
	    model.addAttribute("endPage", data.get("endPage"));

	    return "admin/admin_list";
	}

	// 신규 사용자 등록 폼
	@GetMapping("/new")
	public String newForm() {
		return "admin/admin_add";
	}

	// 신규 사용자 등록 처리
	@PostMapping("/new")
	public String create(@ModelAttribute UserDTO dto, Model model) {
		String error = userService.validateNewUser(dto);
		if (error != null) {
			model.addAttribute("error", error);
			model.addAttribute("u", dto);
			return "admin/user_add";
		}

		userService.insert(dto);
		return "redirect:/admin/users?created=1";
	}
	
	// 수정 폼
	@GetMapping("/edit")
	public String editForm(@RequestParam int id, Model model) {
	    model.addAttribute("targetUser", userService.find(id));  // ✅ 이름 바꿔서 넘김
	    return "admin/admin_edit";
	}

	// 수정 처리
	@PostMapping("/edit")
	public String edit(@ModelAttribute UserDTO dto, Model model) {
	    boolean ok = userService.updateByAdmin(dto); // ✅ 별도 관리자용 메서드로 변경
	    if (!ok) {
	        model.addAttribute("error", "입력값을 확인하세요.");
	        model.addAttribute("user", dto);
	        return "admin/admin_edit";
	    }
	    return "redirect:/admin/users?updated=1";
	}

	// 비밀번호 리셋 (이메일 발송 방식)
	@PostMapping("/reset-pw")
	@ResponseBody
	public Map<String, Object> resetPw(@RequestParam int id) {
		Map<String, Object> response = new HashMap<>();
		try {
			// (1) 리셋 코드 발급 및 이메일 발송
			String token = userService.issueResetToken(id); // 내부에서 메일 전송 포함

			if (token == null) {
				response.put("status", "fail");
				response.put("message", "토큰 발급 실패 또는 이메일 전송 오류");
				return response;
			}

			// (2) 사용자 정보 조회 (모달용)
			UserDTO target = userService.find(id);

			response.put("status", "ok");
			response.put("name", target.getName());
			response.put("loginId", target.getLoginId());

		} catch (Exception e) {
			e.printStackTrace();
			response.put("status", "fail");
			response.put("message", "예외 발생: " + e.getMessage());
		}

		return response;
	}
}
