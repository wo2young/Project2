package yaDTO;

public class ItemMasterDTO {
	private int item_id;
	private String item_name;
	private String lot_code; // LOT 코드(자유입력)
	private int self_life_day; // 유통기한(숫자)
	private String kind; // FG / RM
	private String detail_code; // PDC 계열 디테일 코드 선택

	private String item_spec;
	// bom 에서 표시할 용도!
	private String unit;
	private String ui_label;

	public String getItem_spec() {
		return item_spec;
	}

	public void setItem_spec(String item_spec) {
		this.item_spec = item_spec;
	}

	public int getItem_id() {
		return item_id;
	}

	public void setItem_id(int item_id) {
		this.item_id = item_id;
	}

	public String getItem_name() {
		return item_name;
	}

	public void setItem_name(String item_name) {
		this.item_name = item_name;
	}

	public String getLot_code() {
		return lot_code;
	}

	public void setLot_code(String lot_code) {
		this.lot_code = lot_code;
	}

	public int getSelf_life_day() {
		return self_life_day;
	}

	public void setSelf_life_day(int self_life_day) {
		this.self_life_day = self_life_day;
	}

	public String getKind() {
		return kind;
	}

	public void setKind(String kind) {
		this.kind = kind;
	}

	public String getDetail_code() {
		return detail_code;
	}

	public void setDetail_code(String detail_code) {
		this.detail_code = detail_code;
	}

	public String getUnit() {
		return unit;
	}

	public void setUnit(String unit) {
		this.unit = unit;
	}

	public String getUi_label() {
		return ui_label;
	}

	public void setUi_label(String ui_label) {
		this.ui_label = ui_label;
	}
}