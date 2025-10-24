package kr.or.mes2.util;

import org.jasypt.encryption.StringEncryptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class CryptoUtil {

    @Autowired
    private StringEncryptor encryptor;

    public String encrypt(String plainText) {
        if (plainText == null || plainText.isEmpty()) return plainText;
        return encryptor.encrypt(plainText);
    }

    public String decrypt(String encryptedText) {
        if (encryptedText == null || encryptedText.isEmpty()) return encryptedText;
        try {
            return encryptor.decrypt(encryptedText);
        } catch (Exception e) {
            return encryptedText; // 복호화 실패 시 원본 반환 (예외 방지용)
        }
    }
}
