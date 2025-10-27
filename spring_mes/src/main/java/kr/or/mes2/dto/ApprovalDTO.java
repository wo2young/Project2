package kr.or.mes2.dto;

import lombok.Data;
import java.util.Date;

@Data
public class ApprovalDTO {

    // APPROVAL_REQUEST 관련
    private Integer requestId;
    private Integer requestUser;   // 요청자 ID
    private Integer approverId;    // 승인자 ID
    private String approvalStatus; // APPROVED / REJECTED / PENDING
    private String remark;         // 비고(사유)
    private Date createdAt;        // 요청일
    private Date updatedAt;        // 수정일

    // QUALITY_DEFECT 관련
    private Integer defectId;
    private String defectType;
    private Integer defectQty;
    private String defectReason;
    private String defectStatus;
    private Integer inspectId;

    // QUALITY_INSPECTION 관련
    private Integer inspectionId;
    private Integer itemId;

    // USER_T 관련
    private String requesterName;
}