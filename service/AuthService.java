package kr.or.human99.service;

import kr.or.human99.dao.UserDAO;
import kr.or.human99.dto.UserDTO;
import kr.or.human99.util.PasswordUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service  // ✅ 스프링이 자동으로 Bean 등록
public class AuthService {

    @Autowired  // ✅ 스프링이 UserDAO를 주입 (new 사용 X)
    private UserDAO userDAO;

    public UserDTO authenticate(String loginId, String rawPassword) {
        UserDTO found = userDAO.findByLoginId(loginId);
        if (found == null) return null;

        if (!PasswordUtil.matches(rawPassword, found.getPassword())) return null;

        UserDTO safe = new UserDTO();
        safe.setUser_id(found.getUser_id());
        safe.setLogin_id(found.getLogin_id());
        safe.setName(found.getName());
        safe.setUser_role(found.getUser_role());
        return safe;
    }
}
