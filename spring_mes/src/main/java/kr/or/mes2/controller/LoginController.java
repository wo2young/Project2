package kr.or.mes2.controller;

import kr.or.mes2.dto.UserDTO;
import kr.or.mes2.service.UserService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.*;

@Controller
public class LoginController {

    @Autowired
    private UserService userService;

    @Autowired
    private BCryptPasswordEncoder passwordEncoder;

    @GetMapping("/login")
    public String loginForm(@RequestParam(value = "error", required = false) String error, Model model) {
        if (error != null)
            model.addAttribute("error", "아이디 또는 비밀번호(또는 리셋코드)가 올바르지 않습니다.");
        return "login";
    }

    @PostMapping("/login")
    public String doLogin(@RequestParam String loginId,
                          @RequestParam String password,
                          HttpServletRequest req) {

        UserDTO user = userService.findByLoginId(loginId);
        if (user == null) {
            return "redirect:/login?error=1";
        }

        HttpSession session = req.getSession(true);

        // 1️⃣ 일반 비밀번호 로그인
        if (passwordEncoder.matches(password, user.getPassword())) {
            session.setAttribute("loginUser", user);
            session.setAttribute("loggedIn", true);
            session.setAttribute("mustChangePw", false);
            session.setAttribute("role", user.getUser_role());
            return "redirect:/dashboard";
        }

        // 2️⃣ 리셋코드 로그인 시도
        UserDTO tokenUser = userService.findByLoginIdAndToken(loginId, password);
        if (tokenUser != null) {
            session.setAttribute("loginUser", tokenUser);
            session.setAttribute("loggedIn", true);
            session.setAttribute("mustChangePw", true); // 강제 변경 모드
            session.setAttribute("role", tokenUser.getUser_role());
            return "redirect:/mypage/change-password";
        }

        // 3️⃣ 실패
        return "redirect:/login?error=1";
    }

    @GetMapping("/logout")
    public String logout(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session != null) session.invalidate();
        return "redirect:/login";
    }
}
