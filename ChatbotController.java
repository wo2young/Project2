package kr.or.mes2.controller;

import java.util.*;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import kr.or.mes2.service.ChatbotService;

@Controller
public class ChatbotController {

    @Autowired
    private ChatbotService chatbotService;

    @PostMapping("/chatbot")
    @ResponseBody
    public Map<String, Object> chatbot(@RequestParam("message") String message, HttpSession session) {
        @SuppressWarnings("unchecked")
        List<Map<String, String>> chatHistory =
                (List<Map<String, String>>) session.getAttribute("chatHistory");
        if (chatHistory == null) {
            chatHistory = new ArrayList<>();
            session.setAttribute("chatHistory", chatHistory);
        }

        // ✅ 과거 대화 저장 (Service엔 최근 메시지만 전달)
        String reply = chatbotService.askBot(message);
        if (reply == null || reply.isBlank()) {
            reply = "죄송합니다. 현재 서버 응답이 지연되고 있습니다.";
        }

        Map<String, String> entry = new HashMap<>();
        entry.put("user", message);
        entry.put("bot", reply);
        chatHistory.add(entry);

        Map<String, Object> response = new HashMap<>();
        response.put("reply", reply);
        response.put("timestamp", System.currentTimeMillis());
        return response;
    }

    @PostMapping("/chatbot/reset")
    @ResponseBody
    public void resetChat(HttpSession session) {
        session.removeAttribute("chatHistory");
    }
}
