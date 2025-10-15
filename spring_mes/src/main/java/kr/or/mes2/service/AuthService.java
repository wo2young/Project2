package kr.or.mes2.service;

import kr.or.mes2.dao.UserDAO;
import kr.or.mes2.dto.UserDTO;
import kr.or.mes2.util.PasswordUtil;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service  // 스프링이 자동으로 Bean 등록
public class AuthService {

    @Autowired  // 스프링이 UserDAO를 주입
    private UserDAO userDAO;

    public UserDTO authenticate(String loginId, String rawPassword) {
        // (1) ID로 사용자 조회
        UserDTO found = userDAO.findByLoginId(loginId);
        if (found == null) return null;

        // (2) 비밀번호 검증 (암호화된 패스워드 비교)
        if (!PasswordUtil.matches(rawPassword, found.getPassword())) return null;

        // (3) 인증 성공 시, 민감 정보 제외한 DTO 리턴
        UserDTO safe = new UserDTO();
        safe.setUserId(found.getUserId());
        safe.setLoginId(found.getLoginId());
        safe.setName(found.getName());
        safe.setRole(found.getRole());
        return safe;
    }
}
