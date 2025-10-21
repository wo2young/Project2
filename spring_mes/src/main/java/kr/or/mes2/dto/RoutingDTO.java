package kr.or.mes2.dto;

import lombok.Data;

@Data
public class RoutingDTO {
    private int routingId;     // ROUTING_ID
    private int itemId;        // ITEM_ID
    private int processStep;   // PROCESS_STEP
    private String equipCode;  // EQUIP_CODE
    private String imgPath;    // IMG_PATH
    private String remark;     // REMARK

    private String itemName;
    private String equipName;
}
