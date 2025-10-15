package kr.or.mes2.util;

import org.jasypt.encryption.StringEncryptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class CryptoUtil {

	@Autowired
	private StringEncryptor encryptor;

	public String encrypt(String plain) {
		if (plain == null || plain.isEmpty())
			return null;
		return encryptor.encrypt(plain);
	}

	public String decrypt(String cipher) {
		if (cipher == null || cipher.isEmpty())
			return null;

		try {
			return encryptor.decrypt(cipher);
		} catch (Exception e) {
			// 암호화되지 않은 평문이면 그냥 그대로 반환
			return cipher;
		}
	}
}
