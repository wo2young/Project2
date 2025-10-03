package yaDTO;

public class CodeMasterDTO {
	
	
	private String code_id;
	private String code_name;
	public String getCode_id() {
		return code_id;
	}
	public void setCode_id(String code_id) {
		this.code_id = code_id;
	}
	public String getCode_name() {
		return code_name;
	}
	public void setCode_name(String code_name) {
		this.code_name = code_name;
	}
	@Override
	public String toString() {
		return "codeMasterDTO [code_id=" + code_id + ", code_name=" + code_name + "]";
	}
	
	
}