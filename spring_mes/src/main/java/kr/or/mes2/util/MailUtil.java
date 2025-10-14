package kr.or.mes2.util;

public class MailUtil {
    public static void sendMail(String to, String subject, String text) {
        // 현재는 실제 메일 서버 없음. 추후 JavaMailSender로 교체 예정
        System.out.println("[메일 전송] to=" + to + ", subject=" + subject);
        System.out.println("내용: " + text);
    }
}
