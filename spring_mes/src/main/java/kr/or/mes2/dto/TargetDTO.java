package kr.or.mes2.dto;

import java.sql.Date;
import java.sql.Timestamp;
import lombok.Data;

@Data
public class TargetDTO {

    private int targetId;
    private int itemId;
    private Date startDate;
    private Date endDate;
    private int targetQty;
    private Timestamp createdAt;
    private int createdBy;

    // ✅ JOIN용 / 표시용 필드
    private String itemName; 
    private String createdByName;
    private String createdByRole;

    // ✅ 품목 이름만 리턴하고 싶을 때 자동 변환 지원
    @Override
    public String toString() {
        return this.itemName != null ? this.itemName : "";
    }
}
