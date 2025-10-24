package kr.or.mes2.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.mes2.dto.UserDTO;
import kr.or.mes2.service.UserService;

@Controller
@RequestMapping("/mypage")
public class MypageController {

	@Autowired
	private UserService userService;

	@Autowired
	private BCryptPasswordEncoder passwordEncoder; // 이미 Bean 등록되어 있으므로 사용 가능

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
	public String changePasswordProcess(@RequestParam(required = false) String currentPassword,
			@RequestParam String newPassword, @RequestParam String confirmPassword, HttpSession session,
			RedirectAttributes redirectAttributes) {

		UserDTO user = (UserDTO) session.getAttribute("loginUser");
		if (user == null)
			return "redirect:/login";

		// (1) 새 비밀번호 확인
		if (!newPassword.equals(confirmPassword)) {
			redirectAttributes.addFlashAttribute("msgErr", "새 비밀번호가 일치하지 않습니다.");
			return "redirect:/mypage";
		}

		// (2) 현재 비밀번호 확인
		if (currentPassword != null && !currentPassword.isEmpty()) {
			if (!passwordEncoder.matches(currentPassword, user.getPassword())) {
				redirectAttributes.addFlashAttribute("msgErr", "현재 비밀번호가 올바르지 않습니다.");
				return "redirect:/mypage";
			}
		}

		// (3) BCrypt 암호화 후 DB 업데이트
		userService.changePassword(user.getUserId(), newPassword);

		// (4) 세션 갱신
		UserDTO refreshed = userService.findByLoginId(user.getLoginId());
		session.setAttribute("loginUser", refreshed);

		redirectAttributes.addFlashAttribute("msgOk", "비밀번호가 성공적으로 변경되었습니다.");
		return "redirect:/mypage";
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
