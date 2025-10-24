package kr.or.mes2.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.mes2.dto.UserDTO;
import kr.or.mes2.service.UserService;

@Controller
@RequestMapping("/password")
public class PasswordController {

    @Autowired
    private UserService userService;

    /* ============================================
       1️⃣ 비밀번호 재설정 폼 (이메일 링크 클릭 시 진입)
       ============================================ */
    @GetMapping("/reset")
    public String resetForm(@RequestParam(required = false) String loginId,
                            @RequestParam(required = false) String token,
                            HttpSession session,
                            Model model) {

        // 로그인 ID와 토큰을 세션에 임시 저장 (POST 시 유지)
        if (loginId != null && !loginId.isEmpty()) {
            session.setAttribute("resetLoginId", loginId);
        }
        if (token != null && !token.isEmpty()) {
            session.setAttribute("resetToken", token);
        }

        model.addAttribute("loginId", loginId);
        model.addAttribute("token", token);
        return "mypage/change-password"; // JSP 경로
    }

    /* ============================================
       2️⃣ 비밀번호 재설정 처리
       ============================================ */
    @PostMapping("/reset")
    public String resetProcess(@RequestParam(required = false) String loginId,
                               @RequestParam(required = false) String token,
                               @RequestParam String password,
                               @RequestParam String password2,
                               HttpSession session,
                               Model model) {

        System.out.println("[DEBUG] PasswordController.resetProcess() called");
        System.out.println("[DEBUG] raw loginId=" + loginId + ", token=" + token);

        // 세션에서 보정
        if (loginId == null || loginId.isEmpty()) {
            loginId = (String) session.getAttribute("resetLoginId");
        }
        if (token == null || token.isEmpty()) {
            token = (String) session.getAttribute("resetToken");
        }

        System.out.println("[DEBUG] final loginId=" + loginId + ", final token=" + token);

        // 비밀번호 일치 검사
        if (!password.equals(password2)) {
            model.addAttribute("error", "비밀번호가 일치하지 않습니다.");
            return "mypage/change-password";
        }

        boolean ok = userService.resetWithToken(loginId, token, password);
        System.out.println("[DEBUG] userService.resetWithToken() result = " + ok);

        if (!ok) {
            model.addAttribute("error", "리셋 코드가 유효하지 않거나 만료되었습니다.");
            return "mypage/change-password";
        }

        // 성공 후 세션 정리
        session.removeAttribute("resetLoginId");
        session.removeAttribute("resetToken");

        System.out.println("[DEBUG] 비밀번호 재설정 성공, 로그인 페이지로 리다이렉트");
        model.addAttribute("msg", "비밀번호가 성공적으로 재설정되었습니다.");
        return "redirect:/login?reset=success";
    }

    /* ============================================
       3️⃣ 비밀번호 리셋 코드 발급 (이메일 전송)
       ============================================ */
    @PostMapping("/issue-token")
    public String issueResetToken(@RequestParam String loginId, Model model) {
        System.out.println("[DEBUG] PasswordController.issueResetToken() called");
        System.out.println("[DEBUG] loginId = " + loginId);

        UserDTO user = userService.findByLoginId(loginId);
        if (user == null) {
            model.addAttribute("error", "해당 ID의 사용자가 존재하지 않습니다.");
            return "login";
        }

        String token = userService.issueResetToken(user.getUserId());
        if (token == null) {
            model.addAttribute("error", "토큰 발급 중 오류가 발생했습니다.");
            return "login";
        }

        System.out.println("[DEBUG] 리셋코드 발급 성공, 이메일 전송 완료");
        model.addAttribute("msg", "비밀번호 재설정 링크를 이메일로 발송했습니다.");
        return "login";
    }
}
