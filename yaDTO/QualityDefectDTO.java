package yaDTO;

import java.time.LocalDateTime;

public class QualityDefectDTO {
    // --- 기본 컬럼 (QUALITY_DEFECT 테이블) ---
    private int defect_id;        // 불량 ID (PK)
    private int result_id;        // 실적 번호 (FK: PRODUCTION_RESULT.RESULT_ID)
    private String defect_code;   // 불량 코드 (FK: CODE_DETAIL.DETAIL_CODE)
    private int quantity;         // 불량 수량
    private int registered_by;    // 등록자 (FK: USER_T.USER_ID)
    private LocalDateTime created_at; // 등록 일시

    // --- 화면/로직 보조 컬럼 ---
    private int worker_id;        // 실적에 연결된 작업자 ID (PRODUCTION_RESULT.WORKER_ID)
    private String worker_name;   // 작업자 이름 (USER_T.NAME)
    private int order_id;         // 지시번호 (PRODUCTION_ORDER.ORDER_ID)
    private String item_name;     // 품목명 (ITEM_MASTER.ITEM_NAME)
    private String defect_name;   // 불량 코드명 (CODE_DETAIL.CODE_DNAME)
    private int defect_quantity;  // ✅ PRODUCTION_RESULT.FAIL_QTY (실적 불량수량)
    private int remain_fail_qty;  // ✅ FAIL_QTY - QUALITY_DEFECT 합계 (남은 불량수량)

    // --- 집계용 컬럼 (현황판) ---
    private int occurrence_count; // 발생 건수
    private int total_quantity;   // 총 불량 수량

    // --- Getter / Setter ---
    public int getDefect_id() { return defect_id; }
    public void setDefect_id(int defect_id) { this.defect_id = defect_id; }

    public int getResult_id() { return result_id; }
    public void setResult_id(int result_id) { this.result_id = result_id; }

    public String getDefect_code() { return defect_code; }
    public void setDefect_code(String defect_code) { this.defect_code = defect_code; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public int getRegistered_by() { return registered_by; }
    public void setRegistered_by(int registered_by) { this.registered_by = registered_by; }

    public LocalDateTime getCreated_at() { return created_at; }
    public void setCreated_at(LocalDateTime created_at) { this.created_at = created_at; }

    public int getWorker_id() { return worker_id; }
    public void setWorker_id(int worker_id) { this.worker_id = worker_id; }

    public String getWorker_name() { return worker_name; }
    public void setWorker_name(String worker_name) { this.worker_name = worker_name; }

    public int getOrder_id() { return order_id; }
    public void setOrder_id(int order_id) { this.order_id = order_id; }

    public String getItem_name() { return item_name; }
    public void setItem_name(String item_name) { this.item_name = item_name; }

    public String getDefect_name() { return defect_name; }
    public void setDefect_name(String defect_name) { this.defect_name = defect_name; }

    public int getDefect_quantity() { return defect_quantity; }
    public void setDefect_quantity(int defect_quantity) { this.defect_quantity = defect_quantity; }

    public int getRemain_fail_qty() { return remain_fail_qty; }
    public void setRemain_fail_qty(int remain_fail_qty) { this.remain_fail_qty = remain_fail_qty; }

    public int getOccurrence_count() { return occurrence_count; }
    public void setOccurrence_count(int occurrence_count) { this.occurrence_count = occurrence_count; }

    public int getTotal_quantity() { return total_quantity; }
    public void setTotal_quantity(int total_quantity) { this.total_quantity = total_quantity; }

    @Override
    public String toString() {
        return "QualityDefectDTO{" +
                "defect_id=" + defect_id +
                ", result_id=" + result_id +
                ", defect_code='" + defect_code + '\'' +
                ", quantity=" + quantity +
                ", registered_by=" + registered_by +
                ", created_at=" + created_at +
                ", worker_id=" + worker_id +
                ", worker_name='" + worker_name + '\'' +
                ", order_id=" + order_id +
                ", item_name='" + item_name + '\'' +
                ", defect_name='" + defect_name + '\'' +
                ", defect_quantity=" + defect_quantity +      // 원본 FAIL_QTY
                ", remain_fail_qty=" + remain_fail_qty +      // 남은 FAIL_QTY
                ", occurrence_count=" + occurrence_count +
                ", total_quantity=" + total_quantity +
                '}';
    }
}
