package kr.or.mes2.service;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import kr.or.mes2.dao.UserDAO;
import kr.or.mes2.dto.UserDTO;
import kr.or.mes2.util.CryptoUtil;   // ✅ AES 암복호화 유틸
import kr.or.mes2.service.GmailService; // ✅ Gmail API 메일 전송 유틸

@Service
public class UserService {

    @Autowired
    private UserDAO dao;

    @Autowired
    private BCryptPasswordEncoder passwordEncoder;

    @Autowired
    private CryptoUtil cryptoUtil;   // ✅ 암복호화

    @Autowired
    private GmailService gmailService;  // ✅ 이메일 발송 (Gmail API)

    /* ============================================================
       조회 관련
       ============================================================ */
    public int count(String q) {
        return dao.count(q);
    }

    public List<UserDTO> list(String q, int p, int size) {
        List<UserDTO> list = dao.list(q, p, size);
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
    public void insert(UserDTO dto) {
        String hashed = passwordEncoder.encode(dto.getPassword());
        dto.setPassword(hashed);
        encryptFields(dto);
        dao.insert(dto);
    }

    public boolean updateMyInfo(UserDTO dto) {
        encryptFields(dto);
        return dao.updateMyInfo(dto);
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
            decryptFields(user);  // 이메일 복호화

            if (user.getEmail() != null && !user.getEmail().isEmpty()) {
            	String subject = "[MES 시스템] 비밀번호 재설정 안내";

            	String resetLink = "http://localhost:8080/mes2/password/reset?loginId=" 
            	        + user.getLoginId() + "&token=" + token;

            	String body = ""
            	    + "안녕하세요, " + user.getName() + "님.\n\n"
            	    + "아래 리셋코드를 입력하거나, 링크를 클릭하여 비밀번호를 재설정하세요.\n\n"
            	    + "리셋코드: " + token + "\n\n"
            	    + "재설정 링크: " + resetLink + "\n\n"
            	    + "※ 본 코드는 1시간 동안만 유효합니다.\n"
            	    + "※ 이 요청을 직접 하지 않으셨다면 본 메일을 무시해주세요.\n\n"
            	    + "감사합니다.\nMES 시스템 드림.";

                try {
                    gmailService.sendEmail(user.getEmail(), subject, body);
                    System.out.println("[Gmail 발송 성공] → " + user.getEmail());
                } catch (Exception e) {
                    System.err.println("[메일 전송 실패] " + e.getMessage());
                }
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
        if (user == null)
            return null;

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
