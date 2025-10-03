package yaDTO;

public class RoutingViewDTO {
	private int routingId;
	private int itemId;
	private String itemName;
	private int processStep;
	private String imgPath;
	private String workstation;

	public int getRoutingId() {
		return routingId;
	}

	public void setRoutingId(int routingId) {
		this.routingId = routingId;
	}

	public int getItemId() {
		return itemId;
	}

	public void setItemId(int itemId) {
		this.itemId = itemId;
	}

	public String getItemName() {
		return itemName;
	}

	public void setItemName(String itemName) {
		this.itemName = itemName;
	}

	public int getProcessStep() {
		return processStep;
	}

	public void setProcessStep(int processStep) {
		this.processStep = processStep;
	}

	public String getImgPath() {
		return imgPath;
	}

	public void setImgPath(String imgPath) {
		this.imgPath = imgPath;
	}

	public String getWorkstation() {
		return workstation;
	}

	public void setWorkstation(String workstation) {
		this.workstation = workstation;
	}
}
