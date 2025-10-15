package kr.or.mes2.service;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import kr.or.mes2.dao.UserDAO;
import kr.or.mes2.dto.UserDTO;
import kr.or.mes2.util.CryptoUtil;
import kr.or.mes2.util.MailUtil;

@Service
public class UserService {

    @Autowired
    private UserDAO dao;

    @Autowired
    private BCryptPasswordEncoder passwordEncoder;

    @Autowired
    private MailUtil mailUtil;

    @Autowired
    private CryptoUtil cryptoUtil;

    /* ============================================================
       조회 관련
       ============================================================ */

    public int count(String q) {
        return dao.count(q);
    }

    public List<UserDTO> list(String q, int p, int size) {
        List<UserDTO> list = dao.list(q, p, size);
        // 복호화 적용 (목록용은 최소한의 필드만)
        for (UserDTO u : list) {
            u.setEmail(cryptoUtil.decrypt(u.getEmail()));
            u.setPhone(cryptoUtil.decrypt(u.getPhone()));
        }
        return list;
    }

    public UserDTO find(int id) {
        UserDTO dto = dao.find(id);
        decryptFields(dto);
        return dto;
    }

    public UserDTO findByLoginId(String loginId) {
        UserDTO dto = dao.findByLoginId(loginId);
        decryptFields(dto);
        return dto;
    }

    /* ============================================================
       등록 및 기본정보 수정
       ============================================================ */

    // 신규 사용자 등록
    public void insert(UserDTO dto) {
        String hashed = passwordEncoder.encode(dto.getPassword());
        dto.setPassword(hashed);

        encryptFields(dto); // 개인정보 암호화

        dao.insert(dto);
    }

    // 기본 정보 수정 (마이페이지용)
    public boolean updateMyInfo(UserDTO dto) {
        encryptFields(dto);
        boolean ok = dao.updateMyInfo(dto);
        return ok;
    }

    /* ============================================================
       유효성 검사
       ============================================================ */

    public String validateNewUser(UserDTO dto) {
        if (dto.getLoginId() == null || dto.getLoginId().trim().isEmpty())
            return "로그인 ID는 필수입니다.";
        if (dto.getPassword() == null || dto.getPassword().length() < 8)
            return "비밀번호는 8자 이상이어야 합니다.";
        if (dao.existsByLoginId(dto.getLoginId()))
            return "이미 존재하는 로그인 ID입니다.";
        return null;
    }
    
    

    /* ============================================================
       비밀번호 리셋 관련
       ============================================================ */

    public String issueResetToken(int userId) {
        String token = UUID.randomUUID().toString().substring(0, 8);
        boolean ok = dao.updateResetToken(userId, token);
        if (ok) {
            UserDTO user = dao.find(userId);
            decryptFields(user); // 이메일 복호화
            if (user.getEmail() != null && !user.getEmail().isEmpty()) {
                String subject = "[MES 시스템] 비밀번호 재설정 코드 안내";
                String body = "안녕하세요, " + user.getName() + "님.\n\n"
                        + "비밀번호 재설정 코드: " + token + "\n"
                        + "본 코드는 1시간 동안만 유효합니다.\n\n"
                        + "감사합니다.";
                mailUtil.sendMail(user.getEmail(), subject, body);
            }
            return token;
        }
        return null;
    }

    public UserDTO findByLoginIdAndToken(String loginId, String token) {
        return dao.findByLoginIdAndToken(loginId, token);
    }

    public boolean resetWithToken(String loginId, String token, String newPlainPw) {
        UserDTO user = dao.findByLoginIdAndToken(loginId, token);
        if (user == null) return false;
        String hashed = passwordEncoder.encode(newPlainPw);
        return dao.updatePasswordWithToken(loginId, token, hashed) > 0;
    }

    /* ============================================================
       비밀번호 변경 (마이페이지)
       ============================================================ */

    public boolean changePassword(int userId, String newPlainPw) {
        String hashed = passwordEncoder.encode(newPlainPw);
        dao.updatePassword(userId, hashed);
        dao.clearResetByUserId(userId);
        return true;
    }

    /* ============================================================
       로그인 처리
       ============================================================ */

    public UserDTO login(String loginId, String rawPassword) {
        UserDTO user = dao.findByLoginId(loginId);
        if (user == null) return null;

        if (passwordEncoder.matches(rawPassword, user.getPassword())) {
            decryptFields(user);
            return user;
        }

        UserDTO tokenUser = dao.findByLoginIdAndToken(loginId, rawPassword);
        if (tokenUser != null) {
            decryptFields(tokenUser);
            return tokenUser;
        }

        return null;
    }

    /* ============================================================
       암호화/복호화 헬퍼 메서드
       ============================================================ */

    private void encryptFields(UserDTO dto) {
        if (dto == null) return;
        dto.setEmail(cryptoUtil.encrypt(dto.getEmail()));
        dto.setPhone(cryptoUtil.encrypt(dto.getPhone()));
        dto.setBirthdate(cryptoUtil.encrypt(dto.getBirthdate()));
        dto.setAddress(cryptoUtil.encrypt(dto.getAddress()));
        dto.setAddressDetail(cryptoUtil.encrypt(dto.getAddressDetail()));
    }

    private void decryptFields(UserDTO dto) {
        if (dto == null) return;
        dto.setEmail(cryptoUtil.decrypt(dto.getEmail()));
        dto.setPhone(cryptoUtil.decrypt(dto.getPhone()));
        dto.setBirthdate(cryptoUtil.decrypt(dto.getBirthdate()));
        dto.setAddress(cryptoUtil.decrypt(dto.getAddress()));
        dto.setAddressDetail(cryptoUtil.decrypt(dto.getAddressDetail()));
    }
}
