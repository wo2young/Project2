package kr.or.mes2.controller;

import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.mes2.dto.UserDTO;
import kr.or.mes2.service.UserService;

@Controller
@RequestMapping("/mypage")
public class MypageController {

	@Autowired
	private UserService userService;

	@GetMapping("")
	public String mypageMain(HttpSession session, Model model) {
		UserDTO user = (UserDTO) session.getAttribute("loginUser");
		if (user == null)
			return "redirect:/login";
		model.addAttribute("user", user);
		return "mypage/mypage"; // JSP 경로: /WEB-INF/views/mypage/mypage.jsp
	}

	@GetMapping("/change-password")
	public String changePasswordForm(HttpSession session, Model model) {
		UserDTO user = (UserDTO) session.getAttribute("loginUser");
		if (user == null)
			return "redirect:/login";
		model.addAttribute("user", user);
		return "mypage/change-password";
	}

	@PostMapping("/change-password")
	public String changePasswordProcess(@RequestParam String password, @RequestParam String password2,
			HttpSession session, RedirectAttributes redirectAttributes, Model model) {

		// (1) 새 비밀번호 일치 확인
		if (!password.equals(password2)) {
			model.addAttribute("error", "비밀번호가 일치하지 않습니다.");
			return "mypage/change-password";
		}

		// (2) 로그인 세션 확인
		UserDTO user = (UserDTO) session.getAttribute("loginUser");
		if (user == null)
			return "redirect:/login";

		// (3) DB 업데이트 (user_id → userId 로 변경)
		userService.changePassword(user.getUserId(), password);

		// (4) 상태 갱신 및 메시지 전달
		session.setAttribute("mustChangePw", false);
		redirectAttributes.addFlashAttribute("msg", "비밀번호가 성공적으로 변경되었습니다.");
		return "redirect:/dashboard";
	}

	@PostMapping("/update-info")
	public String updateMyInfo(@RequestParam String email, @RequestParam String phone,
			@RequestParam(required = false) String birthdate, @RequestParam(required = false) String zipcode,
			@RequestParam(required = false) String address,
			@RequestParam(required = false, name = "addressDetail") String addressDetail, HttpSession session,
			RedirectAttributes ra) {

		UserDTO user = (UserDTO) session.getAttribute("loginUser");
		if (user == null)
			return "redirect:/login";

		user.setEmail(email);
		user.setPhone(phone);
		user.setBirthdate(birthdate);
		user.setZipcode(zipcode);
		user.setAddress(address);
		user.setAddressDetail(addressDetail);

		boolean updated = userService.updateMyInfo(user);
		if (updated) {
			session.setAttribute("loginUser", userService.findByLoginId(user.getLoginId()));
			ra.addFlashAttribute("msgOk", "정보가 성공적으로 수정되었습니다.");
		} else {
			ra.addFlashAttribute("msgErr", "수정 중 오류가 발생했습니다.");
		}

		return "redirect:/mypage";
	}
}
