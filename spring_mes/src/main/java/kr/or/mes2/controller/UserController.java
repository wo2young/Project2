package kr.or.mes2.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import kr.or.mes2.dto.UserDTO;
import kr.or.mes2.service.UserService;

@Controller
@RequestMapping("/users")
public class UserController {

    @Autowired
    private UserService userService;

    // 사용자 목록 (검색 + 페이징)
    @GetMapping
    public String list(@RequestParam(required = false) String q,
                       @RequestParam(defaultValue = "1") int p,
                       @RequestParam(defaultValue = "10") int size,
                       Model model) {

        int total = userService.count(q);
        List<UserDTO> list = userService.list(q, p, size);

        int totalPages = (int) Math.ceil(total / (double) size);
        if (p < 1) p = 1;
        if (totalPages > 0 && p > totalPages) p = totalPages;

        model.addAttribute("q", q);
        model.addAttribute("list", list);
        model.addAttribute("page", p);
        model.addAttribute("size", size);
        model.addAttribute("total", total);
        model.addAttribute("totalPages", totalPages);

        return "users/list";
    }

    // 신규 사용자 등록 폼
    @GetMapping("/new")
    public String newForm() {
        return "users/new";
    }

    // 신규 사용자 등록 처리
    @PostMapping("/new")
    public String create(@ModelAttribute UserDTO dto, Model model) {
        String error = userService.validateNewUser(dto);
        if (error != null) {
            model.addAttribute("error", error);
            model.addAttribute("u", dto);
            return "users/new";
        }

        userService.insert(dto);
        return "redirect:/users?created=1";
    }

    // 수정 폼
    @GetMapping("/edit")
    public String editForm(@RequestParam int id, Model model) {
        UserDTO user = userService.find(id);
        if (user == null) return "error/404";
        model.addAttribute("u", user);
        return "users/edit";
    }

    // 수정 처리
    @PostMapping("/edit")
    public String edit(@ModelAttribute UserDTO dto, Model model) {
    	boolean ok = userService.updateMyInfo(dto);
        if (!ok) {
            model.addAttribute("error", "입력값을 확인하세요.");
            model.addAttribute("u", dto);
            return "users/edit";
        }
        return "redirect:/users?updated=1";
    }

    // 관리자: 비밀번호 리셋 코드 발급
    @PostMapping("/reset-pw")
    public String resetPw(@RequestParam int id, Model model) {
        String token = userService.issueResetToken(id);
        if (token == null)
            return "redirect:/users?reset=fail";

        UserDTO target = userService.find(id);
        model.addAttribute("target", target);
        model.addAttribute("token", token);
        return "users/reset_result";
    }

    // 리셋코드 로그인 → 비밀번호 변경 강제 이동
    @GetMapping("/reset-login")
    public String resetLogin(@RequestParam String loginId,
                             @RequestParam String token,
                             HttpSession session,
                             Model model) {

        UserDTO user = userService.findByLoginIdAndToken(loginId, token);
        if (user == null) {
            model.addAttribute("error", "유효하지 않거나 만료된 코드입니다.");
            return "users/reset_invalid";
        }

        session.setAttribute("loginUser", user);
        session.setAttribute("mustChangePw", true);

        return "redirect:/mypage"; // 비밀번호 변경 페이지로 이동
    }
}
