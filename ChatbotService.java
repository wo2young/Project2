package kr.or.mes2.service;

import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@PropertySource(value = "classpath:config/api.properties", encoding = "UTF-8")
@Service
public class ChatbotService {

    @Value("${GEMINI_API_KEY}")
    private String geminiApiKey;

    @Autowired
    private SqlSession sqlSession;  // ✅ Mapper 인터페이스 대신 직접 세션 사용

    private static final ObjectMapper mapper = new ObjectMapper();
    private static final String NAMESPACE = "kr.or.mes2.mapper.DashboardMapper";
    private static final String MODEL_NAME = "gemini-2.5-flash-preview-05-20";

    public String askBot(String message) {
        try {
            // ✅ 1️⃣ DB 기반 자동응답 분기
            String backend = checkBackendAnswer(message);
            if (backend != null) return backend;

            // ✅ 2️⃣ Gemini API 호출
            String prompt = "너는 MES 고객센터 봇이야. 항상 한국어로 정중하게 답변해줘. 질문: " + message;

            String apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/"
                    + MODEL_NAME + ":generateContent?key=" + geminiApiKey;

            String requestBody = "{"
                    + "\"contents\": [{\"parts\": [{\"text\": \"" + escapeJson(prompt) + "\"}]}]}"
                    ;

            HttpURLConnection conn = (HttpURLConnection) new URL(apiUrl).openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setDoOutput(true);

            try (OutputStream os = conn.getOutputStream()) {
                os.write(requestBody.getBytes(StandardCharsets.UTF_8));
            }

            BufferedReader br = new BufferedReader(new InputStreamReader(
                    conn.getInputStream(), StandardCharsets.UTF_8));
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null)
                response.append(line);
            br.close();
            conn.disconnect();

            JsonNode root = mapper.readTree(response.toString());
            JsonNode textNode = root.at("/candidates/0/content/parts/0/text");

            if (textNode.isMissingNode())
                return "AI 응답을 처리하지 못했습니다.";
            return textNode.asText().trim();

        } catch (Exception e) {
            e.printStackTrace();
            return "AI 응답 중 오류 발생: " + e.getMessage();
        }
    }

    // ✅ DB 직접 조회 (SqlSession 사용)
    private String checkBackendAnswer(String message) {
        String lower = message.toLowerCase();

        try {
            if (lower.contains("생산")) {
                int qty = sqlSession.selectOne(NAMESPACE + ".getTodayProduction");
                return "오늘의 총 생산량은 " + formatNumber(qty) + "개입니다.";
            }
            if (lower.contains("불량")) {
                int qty = sqlSession.selectOne(NAMESPACE + ".getTodayDefect");
                return "오늘의 불량 수량은 " + formatNumber(qty) + "개입니다.";
            }
            if (lower.contains("재고")) {
                int qty = sqlSession.selectOne(NAMESPACE + ".getInventorySummary");
                return "현재 총 재고 수량은 " + formatNumber(qty) + "개입니다.";
            }
            if (lower.contains("설비")) {
                String status = sqlSession.selectOne(NAMESPACE + ".getEquipmentStatus");
                return "현재 " + status + "입니다.";
            }
        } catch (Exception e) {
            return "DB 조회 중 오류 발생: " + e.getMessage();
        }

        return null;
    }

    private String escapeJson(String text) {
        if (text == null) return "";
        return text.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r");
    }

    private String formatNumber(int num) {
        return String.format("%,d", num);
    }
}
