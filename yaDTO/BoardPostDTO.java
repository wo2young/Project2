package yaDTO;

import java.sql.Timestamp;

public class BoardPostDTO {
    private long postId;
    private int categoryId;
    private String title;
    private String content;     // CLOB은 문자열로 매핑
    private String isNotice;    // 'Y'/'N'
    private long viewCnt;
    private long likeCnt;
    private String isDeleted;   // 'Y'/'N'
    private long createdBy;     // 작성자 user_id (FK)
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // ✅ 추가: 작성자 로그인 아이디 (조인 결과용)
    private String writerLoginId;

    // ✅ 추가: 작성자 이름(표시용, login_id와 동일하게 쓸 수도 있음)
    private String writerName;

    // ----- getters / setters -----
    public long getPostId() { return postId; }
    public void setPostId(long postId) { this.postId = postId; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getIsNotice() { return isNotice; }
    public void setIsNotice(String isNotice) { this.isNotice = isNotice; }

    public long getViewCnt() { return viewCnt; }
    public void setViewCnt(long viewCnt) { this.viewCnt = viewCnt; }

    public long getLikeCnt() { return likeCnt; }
    public void setLikeCnt(long likeCnt) { this.likeCnt = likeCnt; }

    public String getIsDeleted() { return isDeleted; }
    public void setIsDeleted(String isDeleted) { this.isDeleted = isDeleted; }

    public long getCreatedBy() { return createdBy; }
    public void setCreatedBy(long createdBy) { this.createdBy = createdBy; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public String getWriterLoginId() { return writerLoginId; }
    public void setWriterLoginId(String writerLoginId) { this.writerLoginId = writerLoginId; }

    public String getWriterName() { return writerName; }
    public void setWriterName(String writerName) { this.writerName = writerName; }

    @Override
    public String toString() {
        return "BoardPostDTO{" +
                "postId=" + postId +
                ", categoryId=" + categoryId +
                ", title='" + title + '\'' +
                ", content='" + (content != null ? content.substring(0, Math.min(20, content.length())) + "..." : null) + '\'' +
                ", isNotice='" + isNotice + '\'' +
                ", viewCnt=" + viewCnt +
                ", likeCnt=" + likeCnt +
                ", isDeleted='" + isDeleted + '\'' +
                ", createdBy=" + createdBy +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                ", writerLoginId='" + writerLoginId + '\'' +
                ", writerName='" + writerName + '\'' +
                '}';
    }
}
