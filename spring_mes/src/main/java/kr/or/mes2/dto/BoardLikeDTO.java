package kr.or.mes2.dto;

import java.util.Date;

import lombok.Data;

@Data
public class BoardLikeDTO {
    private int postId;
    private int userId;
    private Date createdAt;
}
