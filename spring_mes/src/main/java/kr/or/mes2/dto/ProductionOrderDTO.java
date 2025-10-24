package kr.or.mes2.dto;

import java.util.Date;
import lombok.Data;

@Data
public class ProductionOrderDTO {

    // 생산지시 기본
    private int orderId;
    private int targetId;
    private int itemId;
    private int equipId;
    private int orderQty;
    private Date dueDate;
    private String status;
    private Date createdAt;
    private int createdBy;

    // ITEM_MASTER 관련
    private String itemName;
    private String itemTypeCode;
    private String itemDetailCode;
    private String unit;
    private String specification;

    // PRODUCTION_TARGET 관련
    private int targetQty;
    private Date targetStartDate;
    private Date targetEndDate;

    // EQUIPMENT_INFO 관련
    private String equipCode;
    private String equipName;
    private Double stdCapacity;
    private Double dailyCapacity;
    private Double maintenanceHr;
    private String detailCode;

    // EQUIPMENT (상태) 관련
    private String equipStatus;
    private Double totalRuntime;

    // BOM 관련
    private int bomId;
    private int parentItem;
    private int childItem;
    private Double requiredQty;
    private String childItemName;
    private String childUnit;

    // ROUTING 관련 
    private int processStep;
    private String routingRemark;
    private String routingImgPath;

    // INVENTORY_TRANSACTION 관련
    private Double txnQty;
    private String warehouseCode;
    private String txnType;
    private String sourceType;

    // 계산/표시용
    private Double expectedDurationMin;
    private String expectedDurationText;
    private Date expectedEndTime;
    private Date nextAvailableTime;
}
