package kr.or.mes2.dto;

import lombok.Data;

@Data
public class RoutingDTO {

    private int routingId;          
    private int itemId;             
    private int processStep;       
    private String equipDetailCode; 
    private String imgPath;       
    private String remark;          

    private String itemName;       
    private String itemTypeCode;    
    private String equipName;
}
