package kr.or.mes2.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.mes2.dao.BoardDAO;
import kr.or.mes2.dto.*;

@Service
public class BoardService {

    @Autowired
    private BoardDAO boardDAO;

    // 게시글 목록 조회
    public List<BoardPostDTO> getPostList() {
        return boardDAO.getPostList();
    }

    // 게시글 상세 조회 (조회수 포함)
    public BoardPostDTO getPostDetail(int postId) {
        boardDAO.increaseViewCount(postId);
        return boardDAO.getPostDetail(postId);
    }

    // 게시글 등록
    public int insertPost(BoardPostDTO post) {
        int nextId = boardDAO.getNextPostId();
        post.setPostId(nextId);
        boardDAO.insertPost(post);
        return nextId;
    }

    // 게시글 수정
    public int updatePost(BoardPostDTO post) {
        return boardDAO.updatePost(post);
    }

    // 게시글 삭제 (첨부파일도 함께 삭제)
    public int deletePost(int postId) {
        boardDAO.deleteAttachmentByPostId(postId);
        return boardDAO.deletePost(postId);
    }

    // 카테고리 목록 조회
    public List<BoardCategoryDTO> getCategories() {
        return boardDAO.getCategories();
    }

    // 댓글 목록 조회
    public List<BoardCommentDTO> getComments(int postId) {
        return boardDAO.getCommentsByPostId(postId);
    }

    // 댓글 등록
    public int insertComment(BoardCommentDTO dto) {
        return boardDAO.insertComment(dto);
    }

    // 댓글 수정
    public int updateComment(BoardCommentDTO dto) {
        return boardDAO.updateComment(dto);
    }

    // 댓글 삭제
    public int deleteComment(int commentId) {
        return boardDAO.deleteComment(commentId);
    }

    // 첨부파일 목록 조회
    public List<BoardAttachmentDTO> getAttachments(int postId) {
        return boardDAO.getAttachments(postId);
    }

    // 첨부파일 등록
    public int insertAttachment(BoardAttachmentDTO dto) {
        return boardDAO.insertAttachment(dto);
    }

    // 첨부파일 삭제
    public int deleteAttachmentByPostId(int postId) {
        return boardDAO.deleteAttachmentByPostId(postId);
    }
    
    public List<BoardPostDTO> getPostList(Integer categoryId) {
        return boardDAO.selectPostList(categoryId);
    }
    
    public int getNextCommentId() {
        int nextId = boardDAO.getMaxCommentId() + 1;
        return nextId;
    }
}
