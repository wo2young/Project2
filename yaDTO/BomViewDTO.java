package yaDTO;

public class BomViewDTO {
	private int bomId;
	private int parentItemId;
	private String parentName;
	private String parentLot; // ▼ 추가: 완제품 LOT
	private int childItemId;
	private String childName;
	private String childLot; // ▼ 추가: 원재료 LOT
	private double quantity;
	private String childUnit; // ▼ 추가: 원재료 단위

	public int getBomId() {
		return bomId;
	}

	public void setBomId(int bomId) {
		this.bomId = bomId;
	}

	public int getParentItemId() {
		return parentItemId;
	}

	public void setParentItemId(int parentItemId) {
		this.parentItemId = parentItemId;
	}

	public String getParentName() {
		return parentName;
	}

	public void setParentName(String parentName) {
		this.parentName = parentName;
	}

	public String getParentLot() {
		return parentLot;
	}

	public void setParentLot(String parentLot) {
		this.parentLot = parentLot;
	}

	public int getChildItemId() {
		return childItemId;
	}

	public void setChildItemId(int childItemId) {
		this.childItemId = childItemId;
	}

	public String getChildName() {
		return childName;
	}

	public void setChildName(String childName) {
		this.childName = childName;
	}

	public String getChildLot() {
		return childLot;
	}

	public void setChildLot(String childLot) {
		this.childLot = childLot;
	}

	public double getQuantity() {
		return quantity;
	}

	public void setQuantity(double quantity) {
		this.quantity = quantity;
	}

	public String getChildUnit() {
		return childUnit;
	}

	public void setChildUnit(String childUnit) {
		this.childUnit = childUnit;
	}
}
