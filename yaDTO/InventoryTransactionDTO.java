package yaDTO;

import java.time.LocalDateTime;

public class InventoryTransactionDTO {

	
	private int transaction_id;
	private int item_id;
	private String lot_no;
	private String type;
	private int quantity;
	private String location_name;
	private int source_result_id;
	private LocalDateTime date;
	private int created_by;
	public int getTransaction_id() {
		return transaction_id;
	}
	public void setTransaction_id(int transaction_id) {
		this.transaction_id = transaction_id;
	}
	public int getItem_id() {
		return item_id;
	}
	public void setItem_id(int item_id) {
		this.item_id = item_id;
	}
	public String getLot_no() {
		return lot_no;
	}
	public void setLot_no(String lot_no) {
		this.lot_no = lot_no;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public int getQuantity() {
		return quantity;
	}
	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}
	public String getLocation_name() {
		return location_name;
	}
	public void setLocation_name(String location_name) {
		this.location_name = location_name;
	}
	public int getSource_result_id() {
		return source_result_id;
	}
	public void setSource_result_id(int source_result_id) {
		this.source_result_id = source_result_id;
	}
	public LocalDateTime getDate() {
		return date;
	}
	public void setDate(LocalDateTime date) {
		this.date = date;
	}
	public int getCreated_by() {
		return created_by;
	}
	public void setCreated_by(int created_by) {
		this.created_by = created_by;
	}
	@Override
	public String toString() {
		return "InventoryTransactionDTO [transaction_id=" + transaction_id + ", item_id=" + item_id + ", lot_no="
				+ lot_no + ", type=" + type + ", quantity=" + quantity + ", location_name=" + location_name
				+ ", source_result_id=" + source_result_id + ", date=" + date + ", created_by=" + created_by + "]";
	}
	
	
}
