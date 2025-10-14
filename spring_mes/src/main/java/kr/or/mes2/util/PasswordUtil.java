package kr.or.mes2.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {
    public static String hash(String raw) {
        return BCrypt.hashpw(raw, BCrypt.gensalt(10));
    }
    public static boolean matches(String raw, String hashed) {
        if (raw == null || hashed == null) return false;
        return BCrypt.checkpw(raw, hashed);
    }

    public static void main(String[] args) {
        System.out.println(hash("1234")); // 테스트용
    }
}
