package kr.or.human99.service;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import kr.or.human99.dao.UserDAO;
import kr.or.human99.dto.UserDTO;
import kr.or.human99.util.MailUtil;

@Service
public class UserService {

    @Autowired private UserDAO dao;
    @Autowired private BCryptPasswordEncoder passwordEncoder;

    public int count(String q) { return dao.count(q); }
    public List<UserDTO> list(String q, int p, int size) { return dao.list(q, p, size); }
    public UserDTO find(int id) { return dao.find(id); }

    public void insert(UserDTO dto) {
        String hashed = passwordEncoder.encode(dto.getPassword());
        dto.setPassword(hashed);
        dao.insert(dto);
    }

    public boolean updateBasic(UserDTO dto) {
        return dao.updateBasic(dto);
    }

    public String validateNewUser(UserDTO dto) {
        if (dto.getLogin_id() == null || dto.getLogin_id().trim().isEmpty())
            return "로그인 ID는 필수입니다.";
        if (dto.getPassword() == null || dto.getPassword().length() < 8)
            return "비밀번호는 8자 이상이어야 합니다.";
        if (dao.existsByLoginId(dto.getLogin_id()))
            return "이미 존재하는 로그인 ID입니다.";
        return null;
    }

    // 리셋 토큰 발급
    public String issueResetToken(int id) {
        String token = UUID.randomUUID().toString().substring(0, 8);
        boolean ok = dao.updateResetToken(id, token);
        if (ok) {
            UserDTO u = dao.find(id);
            if (u.getEmail() != null && !u.getEmail().isEmpty()) {
                MailUtil.sendMail(u.getEmail(), "비밀번호 재설정 코드", "당신의 리셋코드: " + token);
            }
            return token;
        }
        return null;
    }

    // 리셋코드로 비밀번호 재설정
    public boolean resetWithToken(String loginId, String token, String newPlainPw) {
        UserDTO user = dao.findByLoginIdAndToken(loginId, token);
        if (user == null) return false;
        String hashed = passwordEncoder.encode(newPlainPw);
        return dao.updatePasswordWithToken(loginId, token, hashed) > 0;
    }

    // 리셋코드 검증용
    public UserDTO findByLoginIdAndToken(String loginId, String token) {
        return dao.findByLoginIdAndToken(loginId, token);
    }

    // 비밀번호 변경 (마이페이지에서 변경 시)
    public boolean changePassword(int userId, String newPlainPw) {
        String hashed = passwordEncoder.encode(newPlainPw);
        dao.updatePassword(userId, hashed);
        dao.clearResetByUserId(userId); // 리셋코드 무효화
        return true;
    }

    public UserDTO findByLoginId(String loginId) {
        return dao.findByLoginId(loginId);
    }
}
