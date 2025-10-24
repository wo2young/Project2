package kr.or.mes2.service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class GeminiService {
    @Value("${GEMINI_API_KEY}")
    private String geminiApiKey;

    private static final ObjectMapper mapper = new ObjectMapper();
    private static final String MODEL_NAME = "gemini-2.5-flash-preview-05-20";

    public String ask(String prompt) throws IOException {
        String apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/"
                + MODEL_NAME + ":generateContent?key=" + geminiApiKey;

        String requestBody = "{"
                + "\"contents\": [{\"parts\": [{\"text\": \"" + escapeJson(prompt) + "\"}]}]}";

        HttpURLConnection conn = (HttpURLConnection) new URL(apiUrl).openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
        conn.setDoOutput(true);

        try (OutputStream os = conn.getOutputStream()) {
            os.write(requestBody.getBytes(StandardCharsets.UTF_8));
        }

        StringBuilder sb = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
            String line;
            while ((line = br.readLine()) != null) sb.append(line);
        }

        conn.disconnect();
        JsonNode textNode = mapper.readTree(sb.toString()).at("/candidates/0/content/parts/0/text");
        return textNode.isMissingNode() ? "응답을 가져오지 못했습니다." : textNode.asText();
    }

    private String escapeJson(String text) {
        if (text == null) return "";
        return text.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n");
    }
}

