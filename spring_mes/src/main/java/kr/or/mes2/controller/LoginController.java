package kr.or.mes2.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.mes2.dto.UserDTO;
import kr.or.mes2.service.UserService;

@Controller
public class LoginController {

    @Autowired
    private UserService userService;

    @Autowired
    private BCryptPasswordEncoder passwordEncoder;

    /* ============================================================
       로그인 화면
       ============================================================ */
    @GetMapping("/login")
    public String loginForm(@RequestParam(value = "error", required = false) String error, Model model) {
        if (error != null) {
            model.addAttribute("error", "아이디 또는 비밀번호(또는 리셋코드)가 올바르지 않습니다.");
        }
        return "login";
    }

    /* ============================================================
       로그인 처리
       ============================================================ */
    @PostMapping("/login")
    public String doLogin(@RequestParam("loginId") String loginId,
                          @RequestParam("password") String password,
                          HttpServletRequest req) {

        UserDTO user = userService.findByLoginId(loginId);

        if (user == null) {
            // 아이디 존재하지 않음
            return "redirect:/login?error=1";
        }

        HttpSession session = req.getSession(true);

        // 1️⃣ 일반 비밀번호 로그인
        if (passwordEncoder.matches(password, user.getPassword())) {
            session.setAttribute("loginUser", user);
            session.setAttribute("loggedIn", true);
            session.setAttribute("mustChangePw", false);
            session.setAttribute("role", user.getRole());
            return "redirect:/dashboard";
        }

        // 2️⃣ 리셋코드 로그인 (비밀번호 대신 토큰 입력)
        UserDTO tokenUser = userService.findByLoginIdAndToken(loginId, password);
        if (tokenUser != null) {
            session.setAttribute("loginUser", tokenUser);
            session.setAttribute("loggedIn", true);
            session.setAttribute("mustChangePw", true);  // 비밀번호 변경 유도
            session.setAttribute("role", tokenUser.getRole());
            return "redirect:/mypage/change-password";
        }

        // 3️⃣ 실패 처리
        return "redirect:/login?error=1";
    }

    /* ============================================================
       로그아웃 처리
       ============================================================ */
    @GetMapping("/logout")
    public String logout(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        return "redirect:/login";
    }
}
