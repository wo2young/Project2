package kr.or.mes2.dto;

import java.util.Date;

import lombok.Data;

@Data
public class BoardPostDTO {
    private int postId;          // 게시글 번호
    private int categoryId;      // 카테고리 번호 (FK)
    private String title;        // 제목
    private String content;      // 내용
    private String noticeYn;     // 공지 여부
    private int viewCount;       // 조회수
    private int likeCount;       // 좋아요 수
    private String deleteYn;     // 삭제 여부
    private int writerId;        // 작성자 ID (USER_T FK)
    private Date createdAt;      // 작성일
    private Date updatedAt;      // 수정일
    private String fileUrl;  // ✅ 추가됨 (외부 첨부파일 링크)
    
    private String writerLoginId;
}