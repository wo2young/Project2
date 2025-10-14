package kr.or.mes2.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.or.mes2.dto.UserDTO;

@Repository
public class UserDAO {

    @Autowired
    private SqlSession sqlSession;

    private static final String NS = "kr.or.mes2.mappers.UserMapper.";

    // 조회 관련
    public UserDTO findByLoginId(String loginId) {
        return sqlSession.selectOne(NS + "findByLoginId", loginId);
    }

    public UserDTO findById(int userId) {
        return sqlSession.selectOne(NS + "findById", userId);
    }

    public int count(String q) {
        return sqlSession.selectOne(NS + "count", q);
    }

    public List<UserDTO> list(String q, int p, int size) {
        Map<String, Object> map = new HashMap<>();
        map.put("q", q);
        map.put("p", p);
        map.put("size", size);
        return sqlSession.selectList(NS + "list", map);
    }

    public UserDTO find(int id) {
        return sqlSession.selectOne(NS + "find", id);
    }

    public boolean existsByLoginId(String loginId) {
        Boolean result = sqlSession.selectOne(NS + "existsByLoginId", loginId);
        return result != null && result;
    }

    // 등록/수정 관련
    public void insert(UserDTO dto) {
        sqlSession.insert(NS + "insert", dto);
    }

    public boolean updateBasic(UserDTO dto) {
        return sqlSession.update(NS + "updateBasic", dto) > 0;
    }

    public void updatePassword(int userId, String newHashedPw) {
        Map<String, Object> param = new HashMap<>();
        param.put("userId", userId);
        param.put("password", newHashedPw);
        sqlSession.update(NS + "updatePassword", param);
    }

    // 비밀번호 리셋 관련
    public boolean updateResetToken(int id, String token) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", id);
        map.put("token", token);
        return sqlSession.update(NS + "updateResetToken", map) > 0;
    }

    public UserDTO findByLoginIdAndToken(String loginId, String token) {
        Map<String, Object> map = new HashMap<>();
        map.put("loginId", loginId);
        map.put("token", token);
        return sqlSession.selectOne(NS + "findByLoginIdAndToken", map);
    }

    public int updatePasswordWithToken(String loginId, String token, String hashedPw) {
        Map<String, Object> map = new HashMap<>();
        map.put("loginId", loginId);
        map.put("token", token);
        map.put("password", hashedPw);
        return sqlSession.update(NS + "updatePasswordWithToken", map);
    }
    
    public void clearResetByUserId(int userId) {
        sqlSession.update(NS + "clearResetByUserId", userId);
    }
}
