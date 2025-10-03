package yaDTO;

import java.sql.Date;
import java.sql.Timestamp;

public class UserDTO {
    private int user_id;
    private String login_id;
    private String password;
    private String name;
    private String user_role;
    private Timestamp created_at;
    private Timestamp updated_at;
    
 // 비밀번호 초기화(토큰) 기능용 - DB에 컬럼 추가했을 때만 사용됨
    private String reset_token;          // nullable
    private Timestamp reset_expires;     // nullable

    
    public String getReset_token() {
		return reset_token;
	}
	public void setReset_token(String reset_token) {
		this.reset_token = reset_token;
	}
	public Timestamp getReset_expires() {
		return reset_expires;
	}
	public void setReset_expires(Timestamp reset_expires) {
		this.reset_expires = reset_expires;
	}
    
    public int getUser_id() {
        return user_id;
    }
    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public String getUser_role() {
        return user_role;
    }
    public void setUser_role(String user_role) {
        this.user_role = user_role;
    }
    public Timestamp getCreated_at() {
        return created_at;
    }
    public void setCreated_at(Timestamp timestamp) {
        this.created_at = timestamp;
    }
    public Timestamp getUpdated_at() {
        return updated_at;
    }
    public void setUpdated_at(Timestamp timestamp) {
        this.updated_at = timestamp;
    }

    public String getLogin_id() {
        return login_id;
    }
    public void setLogin_id(String login_id) {
        this.login_id = login_id;
    }
    @Override
    public String toString() {
        return "UserDTO [user_id=" + user_id +
               ", login_id=" + login_id +
               ", name=" + name +
               ", user_role=" + user_role +
               ", created_at=" + created_at +
               ", updated_at=" + updated_at +
               "]";
    }

}