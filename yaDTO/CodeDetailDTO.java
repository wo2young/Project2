package yaDTO;

public class CodeDetailDTO {

	private String code_id;
	private String detail_code;
	private String code_Dname;
	private String is_active;
	private String Code_dname;

	public String getCode_dname() {
		return Code_dname;
	}

	public void setCode_dname(String code_dname) {
		Code_dname = code_dname;
	}

	public String getCode_Dname() {
		return code_Dname;
	}

	public String getIs_active() {
		return is_active;
	}

	public String getCode_id() {
		return code_id;
	}

	public String getIsActive() {
		return is_active;
	}

	public void setIs_active(String is_active) {
		this.is_active = is_active;
	}

	public void setCode_id(String code_id) {
		this.code_id = code_id;
	}

	public String getDetail_code() {
		return detail_code;
	}

	public void setDetail_code(String detail_code) {
		this.detail_code = detail_code;
	}

	public String getCodeDname() {
		return code_Dname;
	}

	public void setCode_Dname(String code_Dname) {
		this.code_Dname = code_Dname;
	}


	@Override
	public String toString() {
		return "codeDetailDTO [code_id=" + code_id + ", detail_code=" + detail_code + ", code_Dname=" + code_Dname
				+ ", is_Active=" + is_active + "]";
	}

}