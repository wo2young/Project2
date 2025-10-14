package kr.or.mes2.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.mes2.service.UserService;

@Controller
@RequestMapping("/password")
public class PasswordController {

    @Autowired
    private UserService userService;

    @GetMapping("/reset")
    public String resetForm(@RequestParam(required = false) String loginId,
                            @RequestParam(required = false) String token,
                            Model model) {
        model.addAttribute("loginId", loginId);
        model.addAttribute("token", token);
        return "users/reset";
    }

    @PostMapping("/reset") // ✅ 수정됨
    public String resetProcess(@RequestParam String loginId,
                               @RequestParam String token,
                               @RequestParam String password,
                               @RequestParam String password2,
                               Model model) {

        System.out.println("[DEBUG] PasswordController.resetProcess() called");
        System.out.println("[DEBUG] loginId = " + loginId);
        System.out.println("[DEBUG] token = " + token);
        System.out.println("[DEBUG] password = " + password);
        System.out.println("[DEBUG] password2 = " + password2);

        if (!password.equals(password2)) {
            System.out.println("[DEBUG] 비밀번호 불일치");
            model.addAttribute("error", "비밀번호가 일치하지 않습니다.");
            return "users/reset";
        }

        boolean ok = userService.resetWithToken(loginId, token, password);
        System.out.println("[DEBUG] userService.resetWithToken() result = " + ok);

        if (!ok) {
            model.addAttribute("error", "리셋 코드가 유효하지 않습니다.");
            return "users/reset";
        }

        System.out.println("[DEBUG] 비밀번호 재설정 성공, 로그인 페이지로 리다이렉트");
        return "redirect:/login?reset=success";
    }
}
