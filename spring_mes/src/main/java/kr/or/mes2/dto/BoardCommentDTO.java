package kr.or.mes2.dto;

import java.util.Date;

import lombok.Data;

@Data
public class BoardCommentDTO {
    private int commentId;
    private int postId;
    private String content;
    private String deleteYn;
    private int writerId;
    private String writerName;
    private Date createdAt;
    private Date updatedAt;

    private Integer parentId;      // 부모 댓글 ID (null이면 일반 댓글)
    private int commentLevel;      // 1: 일반 댓글, 2: 대댓글
}
