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

    /* ============================================================
       조회 관련
       ============================================================ */

    // 로그인 시 아이디로 사용자 조회
    public UserDTO findByLoginId(String loginId) {
        return sqlSession.selectOne(NS + "findByLoginId", loginId);
    }

    // 단일 사용자 (PK 기준)
    public UserDTO findById(int userId) {
        return sqlSession.selectOne(NS + "findById", userId);
    }

    // 관리자 목록 조회
    public List<UserDTO> list(String q, int p, int size) {
        Map<String, Object> map = new HashMap<>();
        map.put("q", q);
        map.put("p", p);
        map.put("size", size);
        return sqlSession.selectList(NS + "list", map);
    }
    
    /* ============================================================
    관리자용 페이징 목록 조회 (ROWNUM 기반)
    ============================================================ */
	 public List<UserDTO> listPaged(Map<String, Object> params) {
	     return sqlSession.selectList(NS + "list", params);
	 }

    // 총 개수
    public int count(String q) {
        return sqlSession.selectOne(NS + "count", q);
    }

    // 로그인 아이디 중복 여부
    public boolean existsByLoginId(String loginId) {
        Boolean result = sqlSession.selectOne(NS + "existsByLoginId", loginId);
        return result != null && result;
    }

    /* ============================================================
       등록 / 수정 관련
       ============================================================ */

    // 신규 사용자 등록
    public void insert(UserDTO dto) {
        sqlSession.insert(NS + "insert", dto);
    }

    public boolean updateMyInfo(UserDTO dto) {
        return sqlSession.update(NS + "updateMyInfo", dto) > 0;
    }

    // 비밀번호 변경 (마이페이지)
    public void updatePassword(int userId, String newHashedPw) {
        Map<String, Object> param = new HashMap<>();
        param.put("userId", userId);
        param.put("password", newHashedPw);
        sqlSession.update(NS + "updatePassword", param);
    }
    
    public boolean updateByAdmin(UserDTO dto) {
        return sqlSession.update(NS + "updateByAdmin", dto) > 0;
    }

    /* ============================================================
       비밀번호 리셋 관련
       ============================================================ */

    // 리셋 토큰 발급
    public boolean updateResetToken(int userId, String token) {
        Map<String, Object> map = new HashMap<>();
        map.put("userId", userId);
        map.put("token", token);
        return sqlSession.update(NS + "updateResetToken", map) > 0;
    }

    // 토큰 기반 사용자 조회
    public UserDTO findByLoginIdAndToken(String loginId, String token) {
        Map<String, Object> map = new HashMap<>();
        map.put("loginId", loginId);
        map.put("token", token);
        return sqlSession.selectOne(NS + "findByLoginIdAndToken", map);
    }

    // 토큰 기반 비밀번호 업데이트
    public int updatePasswordWithToken(String loginId, String token, String hashedPw) {
        Map<String, Object> map = new HashMap<>();
        map.put("loginId", loginId);
        map.put("token", token);
        map.put("password", hashedPw);
        return sqlSession.update(NS + "updatePasswordWithToken", map);
    }

    // 리셋 정보 초기화
    public void clearResetByUserId(int userId) {
        sqlSession.update(NS + "clearResetByUserId", userId);
    }
}
