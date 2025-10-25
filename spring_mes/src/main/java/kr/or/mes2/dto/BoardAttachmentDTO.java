package kr.or.mes2.dto;

import java.util.Date;
import lombok.Data;

@Data
public class BoardAttachmentDTO {
    private int attachId;          // ATTACH_ID
    private int postId;            // POST_ID
    private String originalName;   // ORIGINAL_NAME
    private String storedName;     // STORED_NAME (UUID 등으로 변경 저장)
    private String storagePath;    // STORAGE_PATH (파일 실제 경로)
    private long fileSize;         // FILE_SIZE
    private String contentType;    // CONTENT_TYPE
    private Date uploadedAt;       // UPLOADED_AT
    private int uploaderId;        // UPLOADER_ID
}
