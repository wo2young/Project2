package kr.or.mes2.service;

import kr.or.mes2.dao.UserDAO;
import kr.or.mes2.dto.UserDTO;
import kr.or.mes2.util.PasswordUtil;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MyPageService {

    @Autowired
    private UserDAO userDAO;

    public UserDTO getUserById(int userId) {
        return userDAO.findById(userId);
    }

    public boolean changePassword(int userId, String currentPw, String newPw) {
        UserDTO user = userDAO.findById(userId);
        if (user == null || !PasswordUtil.matches(currentPw, user.getPassword())) {
            return false;
        }
        String hashed = PasswordUtil.hash(newPw);
        userDAO.updatePassword(userId, hashed);
        return true;
    }
}
