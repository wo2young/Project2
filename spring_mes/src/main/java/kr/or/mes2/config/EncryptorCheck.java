package kr.or.mes2.config;

import javax.annotation.PostConstruct;
import org.jasypt.encryption.StringEncryptor;     // ← 여기가 포인트
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class EncryptorCheck {

    @Autowired(required = false)
    private StringEncryptor encryptor;

    @PostConstruct
    public void test() {
        System.out.println("=== EncryptorCheck 테스트 시작 ===");
        if (encryptor == null) {
            System.out.println("❌ Encryptor Bean 주입 실패 (빈 등록 안됨)");
        } else {
            System.out.println("✅ Encryptor Bean 주입 성공");
            System.out.println("테스트 암호화 결과: " + encryptor.encrypt("1234"));
        }
        System.out.println("===============================");
    }
}
