package yaDTO;

import java.sql.Date;
import java.time.LocalDateTime;

public class ProductionTargetDTO {
	private int target_id;
	private int item_id;
	private String item_name; // ✅ 제품명 필드 추가
	private Date period_start;
	private Date period_end;
	private int target_quantity;
	private LocalDateTime created_at;
	private int created_by;

	private String created_by_name;
	private String created_by_role;

	private int orders_sum;
	private int results_sum;
	private String status;

	// --- getter/setter ---
	public int getTarget_id() {
		return target_id;
	}

	public void setTarget_id(int target_id) {
		this.target_id = target_id;
	}

	public int getItem_id() {
		return item_id;
	}

	public void setItem_id(int item_id) {
		this.item_id = item_id;
	}

	public String getItem_name() {
		return item_name;
	} // ✅ 추가

	public void setItem_name(String item_name) {
		this.item_name = item_name;
	}

	public Date getPeriod_start() {
		return period_start;
	}

	public void setPeriod_start(Date period_start) {
		this.period_start = period_start;
	}

	public Date getPeriod_end() {
		return period_end;
	}

	public void setPeriod_end(Date period_end) {
		this.period_end = period_end;
	}

	public int getTarget_quantity() {
		return target_quantity;
	}

	public void setTarget_quantity(int target_quantity) {
		this.target_quantity = target_quantity;
	}

	public LocalDateTime getCreated_at() {
		return created_at;
	}

	public void setCreated_at(LocalDateTime created_at) {
		this.created_at = created_at;
	}

	public int getCreated_by() {
		return created_by;
	}

	public void setCreated_by(int created_by) {
		this.created_by = created_by;
	}

	public String getCreated_by_name() {
		return created_by_name;
	}

	public void setCreated_by_name(String created_by_name) {
		this.created_by_name = created_by_name;
	}

	public String getCreated_by_role() {
		return created_by_role;
	}

	public void setCreated_by_role(String created_by_role) {
		this.created_by_role = created_by_role;
	}

	public int getOrders_sum() {
		return orders_sum;
	}

	public void setOrders_sum(int orders_sum) {
		this.orders_sum = orders_sum;
	}

	public int getResults_sum() {
		return results_sum;
	}

	public void setResults_sum(int results_sum) {
		this.results_sum = results_sum;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
}
