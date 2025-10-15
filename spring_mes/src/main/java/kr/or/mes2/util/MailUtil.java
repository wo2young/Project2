package kr.or.mes2.util;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Component;

@Component // ✅ 스프링이 자동으로 Bean 등록
public class MailUtil {

    @Autowired
    private JavaMailSender mailSender;

    public void sendMail(String to, String subject, String text) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setTo(to);
            message.setSubject(subject);
            message.setText(text);
            mailSender.send(message);
            System.out.println("[메일 전송 완료] to=" + to);
        } catch (Exception e) {
            System.err.println("[메일 전송 실패] " + e.getMessage());
        }
    }
}
