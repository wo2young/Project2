package kr.or.mes2.dto;

import java.util.Date;
import lombok.Data;

/**
 * UserDTO
 * 
 * USER_T 테이블 구조에 1:1로 대응
 * 이메일, 전화번호, 주소 등은 양방향 암호화 대상
 * 비밀번호는 단방향(BCrypt 해시)
 */

@Data
public class UserDTO {

    // 기본 정보
    private Integer userId;        // USER_ID (PK)
    private String  loginId;       // LOGIN_ID (Unique)
    private String  password;      // PASSWORD (BCrypt 해시)
    private String  name;          // NAME
    private String  email;         // EMAIL (암호화 대상)
    private String  phone;         // PHONE (암호화 대상)
    private String  birthdate;     // BIRTHDATE (암호화 대상)
    private String  zipcode;       // ZIPCODE
    private String  address;       // ADDRESS (암호화 대상)
    private String  addressDetail; // ADDRESS_DETAIL (암호화 대상)
    private String  role;          // ROLE (ADMIN / MANAGER / WORKER 등)

    // 메타 정보
    private Date    createdAt;     // CREATED_AT
    private Date    updatedAt;     // UPDATED_AT

    // 비밀번호 리셋 관련
    private String  resetToken;    // RESET_TOKEN
    private Date    tokenExpireAt; // TOKEN_EXPIRE_AT
}
