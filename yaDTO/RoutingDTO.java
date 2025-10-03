package yaDTO;

public class RoutingDTO {
	
	private int routing_id;
	private int item_id;
	private int process_step;
	private String img_path;
	private String workstation;
	public int getRouting_id() {
		return routing_id;
	}
	public void setRouting_id(int routing_id) {
		this.routing_id = routing_id;
	}
	public int getItem_id() {
		return item_id;
	}
	public void setItem_id(int item_id) {
		this.item_id = item_id;
	}
	public int getProcess_step() {
		return process_step;
	}
	public void setProcess_step(int process_step) {
		this.process_step = process_step;
	}
	public String getImg_path() {
		return img_path;
	}
	public void setImg_path(String img_path) {
		this.img_path = img_path;
	}
	public String getWorkstation() {
		return workstation;
	}
	public void setWorkstation(String workstation) {
		this.workstation = workstation;
	}
	@Override
	public String toString() {
		return "RoutingDTO [routing_id=" + routing_id + ", item_id=" + item_id + ", process_step=" + process_step
				+ ", img_path=" + img_path + ", workstation=" + workstation + "]";
	}
	
	
}