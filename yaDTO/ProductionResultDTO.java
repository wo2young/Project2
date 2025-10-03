package yaDTO;


import java.time.LocalDateTime;

public class ProductionResultDTO {
	private int result_id;
	private int order_id;
	private int worker_id;
	private int good_qty;
	private int fail_qty;
	private LocalDateTime work_date;
	private LocalDateTime created_at;
	public int getResult_id() {
		return result_id;
	}
	public void setResult_id(int result_id) {
		this.result_id = result_id;
	}
	public int getOrder_id() {
		return order_id;
	}
	public void setOrder_id(int order_id) {
		this.order_id = order_id;
	}
	public int getWorker_id() {
		return worker_id;
	}
	public void setWorker_id(int worker_id) {
		this.worker_id = worker_id;
	}
	public int getGood_qty() {
		return good_qty;
	}
	public void setGood_qty(int good_qty) {
		this.good_qty = good_qty;
	}
	public int getFail_qty() {
		return fail_qty;
	}
	public void setFail_qty(int fail_qty) {
		this.fail_qty = fail_qty;
	}
	public LocalDateTime getWork_date() {
		return work_date;
	}
	public void setWork_date(LocalDateTime work_date) {
		this.work_date = work_date;
	}
	public LocalDateTime getCreated_at() {
		return created_at;
	}
	public void setCreated_at(LocalDateTime created_at) {
		this.created_at = created_at;
	}
	@Override
	public String toString() {
		return "ProductionResultDTO [result_id=" + result_id + ", order_id=" + order_id + ", worker_id=" + worker_id
				+ ", good_qty=" + good_qty + ", fail_qty=" + fail_qty + ", work_date=" + work_date + ", created_at="
				+ created_at + "]";
	}
	
	
	
	
}
