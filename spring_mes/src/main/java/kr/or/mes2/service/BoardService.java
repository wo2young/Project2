package kr.or.mes2.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.mes2.dao.BoardDAO;
import kr.or.mes2.dto.*;

@Service
public class BoardService {

    @Autowired
    private BoardDAO boardDAO;

    /** ✅ 게시글 목록 (검색 + 페이징) */
    public Map<String, Object> getPagedPostList(String q, Integer categoryId, int page, int size) {
        int startRow = (page - 1) * size + 1;
        int endRow = page * size;

        List<BoardPostDTO> list = boardDAO.getPostListPaged(q, categoryId, startRow, endRow);
        int totalCount = boardDAO.getPostCount(q, categoryId);
        int totalPage = (int) Math.ceil((double) totalCount / size);

        // 5페이지 단위 블록 계산
        int blockSize = 5;
        int startPage = ((page - 1) / blockSize) * blockSize + 1;
        int endPage = Math.min(startPage + blockSize - 1, totalPage);

        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("totalCount", totalCount);
        result.put("totalPage", totalPage);
        result.put("page", page);
        result.put("size", size);
        result.put("startPage", startPage);
        result.put("endPage", endPage);
        return result;
    }

    /** 게시글 상세 조회 (조회수 증가 포함) */
    public BoardPostDTO getPostDetail(int postId) {
        boardDAO.increaseViewCount(postId);
        return boardDAO.getPostDetail(postId);
    }

    /** 게시글 등록 */
    public int insertPost(BoardPostDTO post) {
        int nextId = boardDAO.getNextPostId();
        post.setPostId(nextId);
        boardDAO.insertPost(post);
        return nextId;
    }

    /** 게시글 수정 */
    public int updatePost(BoardPostDTO post) {
        return boardDAO.updatePost(post);
    }

    /** 게시글 삭제 (첨부파일 포함) */
    public int deletePost(int postId) {
        boardDAO.deleteAttachmentByPostId(postId);
        return boardDAO.deletePost(postId);
    }

    /** 카테고리 목록 조회 */
    public List<BoardCategoryDTO> getCategories() {
        return boardDAO.getCategories();
    }

    /** 댓글 관련 */
    public List<BoardCommentDTO> getComments(int postId) {
        return boardDAO.getCommentsByPostId(postId);
    }

    public int insertComment(BoardCommentDTO dto) {
        return boardDAO.insertComment(dto);
    }

    public int updateComment(BoardCommentDTO dto) {
        return boardDAO.updateComment(dto);
    }

    public int deleteComment(int commentId) {
        return boardDAO.deleteComment(commentId);
    }

    /** 첨부파일 관련 */
    public List<BoardAttachmentDTO> getAttachments(int postId) {
        return boardDAO.getAttachments(postId);
    }

    public int insertAttachment(BoardAttachmentDTO dto) {
        return boardDAO.insertAttachment(dto);
    }

    public int deleteAttachmentByPostId(int postId) {
        return boardDAO.deleteAttachmentByPostId(postId);
    }

    /** 댓글 ID 자동 증가 */
    public int getNextCommentId() {
        return boardDAO.getMaxCommentId() + 1;
    }
}
