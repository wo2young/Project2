package kr.or.human99.dto;

import java.sql.Timestamp;
import lombok.Data;

/*
 [Lombok 주요 어노테이션 정리]
 @Data        : Getter + Setter + toString + equals + hashCode + RequiredArgsConstructor
 @NoArgsConstructor / @AllArgsConstructor : 생성자 자동 생성
 @Builder     : 빌더 패턴 지원
*/

// DTO는 대부분 단순 데이터 전달용이라 @Data 하나면 충분
@Data
public class UserDTO {

    private int user_id;          // 사용자 고유번호 (PK)
    private String login_id;      // 로그인 ID
    private String password;      // 암호화된 비밀번호
    private String name;          // 이름
    private String user_role;     // 역할 (Admin / Manager / Worker)
    private Timestamp created_at; // 생성일
    private Timestamp updated_at; // 수정일
    
    private String email; // 추후 메일 발송용
    // phone, birth_date, postal_code, address, address_detail

    // 비밀번호 초기화용
    private String reset_token;
    private Timestamp reset_expires;
}
