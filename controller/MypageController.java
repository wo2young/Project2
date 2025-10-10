package kr.or.human99.controller;

import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import kr.or.human99.dto.UserDTO;
import kr.or.human99.service.UserService;

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
		if (!password.equals(password2)) {
			model.addAttribute("error", "비밀번호가 일치하지 않습니다.");
			return "mypage/change-password";
		}

		UserDTO user = (UserDTO) session.getAttribute("loginUser");
		if (user == null)
			return "redirect:/login";

		userService.changePassword(user.getUser_id(), password);
		session.setAttribute("mustChangePw", false);
		redirectAttributes.addFlashAttribute("msg", "비밀번호가 성공적으로 변경되었습니다.");
		return "redirect:/dashboard";
	}
}
