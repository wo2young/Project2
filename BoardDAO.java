package kr.or.mes2.dao;

import java.io.File;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.or.mes2.dto.BoardAttachmentDTO;
import kr.or.mes2.dto.BoardCategoryDTO;
import kr.or.mes2.dto.BoardCommentDTO;
import kr.or.mes2.dto.BoardPostDTO;

@Repository
public class BoardDAO {

    @Autowired
    private SqlSession sqlSession;
    private static final String NS = "kr.or.mes2.mapper.BoardMapper.";

    // 게시글 ID 조회
    public int getNextPostId() { return sqlSession.selectOne(NS + "getNextPostId"); }

    // 글 등록
    public int insertPost(BoardPostDTO post) { return sqlSession.insert(NS + "insertPost", post); }

    // 글 목록 조회
    public List<BoardPostDTO> getPostList() { return sqlSession.selectList(NS + "getPostList"); }

    // 글 상세조회
    public BoardPostDTO getPostDetail(int postId) { return sqlSession.selectOne(NS + "getPostDetail", postId); }

    // 조회수 증가
    public int increaseViewCount(int postId) { return sqlSession.update(NS + "increaseViewCount", postId); }

    // 글 수정
    public int updatePost(BoardPostDTO post) { return sqlSession.update(NS + "updatePost", post); }

    // 글 삭제
    public int deletePost(int postId) { return sqlSession.update(NS + "deletePost", postId); }

    // 카테고리 목록 조회
    public List<BoardCategoryDTO> getCategories() { return sqlSession.selectList(NS + "getCategories"); }

    // 댓글 목록 조회
    public List<BoardCommentDTO> getCommentsByPostId(int postId) { return sqlSession.selectList(NS + "getCommentsByPostId", postId); }

    // 댓글 등록
    public int insertComment(BoardCommentDTO dto) { return sqlSession.insert(NS + "insertComment", dto); }

    // 댓글 수정
    public int updateComment(BoardCommentDTO dto) { return sqlSession.update(NS + "updateComment", dto); }

    // 댓글 삭제 (소프트 삭제)
    public int deleteComment(int commentId) { return sqlSession.update(NS + "deleteComment", commentId); }

    // 첨부파일 목록 조회
    public List<BoardAttachmentDTO> getAttachments(int postId) {
        return sqlSession.selectList(NS + "getAttachments", postId);
    }

    // 첨부파일 등록
    public int insertAttachment(BoardAttachmentDTO dto) {
        return sqlSession.insert(NS + "insertAttachment", dto);
    }

    // ✅ 첨부파일 삭제 (DB + 실제 파일)
    public int deleteAttachmentByPostId(int postId) {
        List<BoardAttachmentDTO> attachments = sqlSession.selectList(NS + "getAttachments", postId);
        String baseDir = "D:/uploads/board";

        for (BoardAttachmentDTO attach : attachments) {
            String path = attach.getStoragePath();
            if (path != null && path.startsWith(baseDir)) {
                File file = new File(path);
                if (file.exists()) {
                    boolean deleted = file.delete();
                    System.out.println("파일 삭제됨: " + file.getAbsolutePath() + " → " + deleted);
                } else {
                    System.out.println("삭제 실패(파일 없음): " + file.getAbsolutePath());
                }
            } else {
                System.out.println("삭제 스킵(잘못된 경로): " + path);
            }
        }

        return sqlSession.delete(NS + "deleteAttachmentByPostId", postId);
    }
    

    // categoryId를 이용해 게시글 목록 조회
    public List<BoardPostDTO> selectPostList(Integer categoryId) {
        return sqlSession.selectList(NS + "selectPostList", categoryId);
    }
    
    public int getMaxCommentId() {
        return sqlSession.selectOne("kr.or.mes2.mapper.BoardMapper.getMaxCommentId");
    }
}
