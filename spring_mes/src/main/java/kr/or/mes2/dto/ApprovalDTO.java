package kr.or.mes2.dto;

import lombok.Data;
import java.util.Date;

@Data
public class ApprovalDTO {
    private int requestId;
    private int defectId;
    private int requestUser;
    private int approverId;
    private String status;
    private String remark;
    private Date createdAt;
    private Date updatedAt;

    // 조인용
    private String defectType;
    private int defectQty;
    private String defectReason;
}
