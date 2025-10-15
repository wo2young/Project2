package kr.or.mes2.config;

import java.io.InputStream;
import java.io.IOException;
import java.util.Properties;

import org.jasypt.encryption.StringEncryptor;
import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class CryptoConfig {

    public CryptoConfig() {
        System.out.println(">>> CryptoConfig 로드됨 ✅");
    }

    @Bean
    public StringEncryptor jasyptStringEncryptor() {
        String secretKey = loadSecretKey();
        if (secretKey == null) {
            System.out.println("❌ secret-key.properties 로드 실패");
            throw new RuntimeException("암호화 키 없음");
        }
        System.out.println("✅ SecretKey 정상 로드됨");

        StandardPBEStringEncryptor encryptor = new StandardPBEStringEncryptor();
        encryptor.setAlgorithm("PBEWithMD5AndDES");
        encryptor.setPassword(secretKey);
        return encryptor;
    }

    private String loadSecretKey() {
        try (InputStream is = Thread.currentThread()
                                    .getContextClassLoader()
                                    .getResourceAsStream("config/secret-key.properties")) {
            if (is == null) {
                System.out.println("❌ 경로 없음: /config/secret-key.properties");
                return null;
            }
            Properties props = new Properties();
            props.load(is);
            return props.getProperty("encrypt.key");
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }
}
