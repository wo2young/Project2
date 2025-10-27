package kr.or.mes2.controller;

import java.io.File;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import kr.or.mes2.dto.BoardAttachmentDTO;
import kr.or.mes2.dto.BoardCategoryDTO;
import kr.or.mes2.dto.BoardCommentDTO;
import kr.or.mes2.dto.BoardPostDTO;
import kr.or.mes2.dto.UserDTO;
import kr.or.mes2.service.BoardService;

@Controller
@RequestMapping("/board")
public class BoardController {

	@Autowired
	private BoardService boardService;
	
	@GetMapping("")
	public String boardRoot(
	        @RequestParam(value = "categoryId", required = false) Integer categoryId,
	        @RequestParam(value = "keyword", required = false) String keyword) {
	    String redirectUrl = "/board/list";
	    boolean hasParams = categoryId != null || (keyword != null && !keyword.isEmpty());
	    if (hasParams) {
	        redirectUrl += "?";
	        if (categoryId != null) redirectUrl += "categoryId=" + categoryId + "&";
	        if (keyword != null && !keyword.isEmpty()) redirectUrl += "keyword=" + keyword;
	    }
	    return "redirect:" + redirectUrl;
	}

	@GetMapping("/list")
	public String list(
	    @RequestParam(value = "categoryId", required = false) Integer categoryId,
	    @RequestParam(value = "keyword", required = false) String keyword,
	    @RequestParam(value = "page", defaultValue = "1") int page,
	    @RequestParam(value = "size", defaultValue = "10") int size,
	    Model model
	) {
	    Map<String, Object> data = boardService.getPagedPostList(keyword, categoryId, page, size);

	    model.addAttribute("posts", data.get("list"));
	    model.addAttribute("categories", boardService.getCategories());
	    model.addAttribute("selectedCategoryId", categoryId);
	    model.addAttribute("keyword", keyword);

	    // ✅ 페이징 정보 JSP로 전달
	    model.addAttribute("page", data.get("page"));
	    model.addAttribute("size", data.get("size"));
	    model.addAttribute("totalPage", data.get("totalPage"));
	    model.addAttribute("startPage", data.get("startPage"));
	    model.addAttribute("endPage", data.get("endPage"));
	    model.addAttribute("totalCount", data.get("totalCount"));

	    return "board/list";
	}

	@GetMapping("/view")
	public String view(@RequestParam("id") int postId, Model model) {
		BoardPostDTO post = boardService.getPostDetail(postId);
		List<BoardCommentDTO> comments = boardService.getComments(postId);
		List<BoardAttachmentDTO> attachments = boardService.getAttachments(postId);

		model.addAttribute("post", post);
		model.addAttribute("comments", comments);
		model.addAttribute("attachments", attachments);

		return "board/view";
	}

	// 글쓰기 폼
	@GetMapping("/write")
	public String writeForm(Model model) {
		model.addAttribute("categories", boardService.getCategories());
		return "board/write";
	}

	// 글 등록 (첨부파일 포함)
	@PostMapping("/write")
	public String write(@ModelAttribute BoardPostDTO post,
			@RequestParam(value = "file", required = false) MultipartFile file,
			@RequestParam(value = "fileUrl", required = false) String fileUrl) throws Exception {

		// ===== 디버깅 로그 =====
		System.out.println("===== [DEBUG] 게시글 등록 요청 =====");
		System.out.println("카테고리: " + post.getCategoryId());
		System.out.println("제목: " + post.getTitle());
		System.out.println("내용: " + post.getContent());
		System.out.println("작성자: " + post.getWriterId());
		System.out.println("파일URL: " + fileUrl);
		System.out.println("=============================");

		// 1️⃣ 게시글 저장
		if (fileUrl != null && !fileUrl.isBlank()) {
			post.setFileUrl(fileUrl); // 외부 링크 저장
		}

		boardService.insertPost(post);

		// 2️⃣ (선택) 파일 업로드 로직 - 외부 링크 없을 때만 동작
		if ((fileUrl == null || fileUrl.isBlank()) && file != null && !file.isEmpty()) {
			String uploadDir = "D:/uploads/board";
			File dir = new File(uploadDir);
			if (!dir.exists())
				dir.mkdirs();

			String ext = file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf("."));
			String storedName = UUID.randomUUID().toString() + ext;

			File saveFile = new File(uploadDir, storedName);
			file.transferTo(saveFile);

			BoardAttachmentDTO attach = new BoardAttachmentDTO();
			attach.setPostId(post.getPostId());
			attach.setOriginalName(file.getOriginalFilename());
			attach.setStoredName(storedName);
			attach.setStoragePath(uploadDir + "/" + storedName);
			attach.setFileSize(file.getSize());
			attach.setContentType(file.getContentType());
			attach.setUploaderId(post.getWriterId());

			boardService.insertAttachment(attach);
		}

		return "redirect:/board/list";
	}

	// 글 수정 폼
	@GetMapping("/edit")
	public String editForm(@RequestParam("id") int postId, Model model) {
		model.addAttribute("post", boardService.getPostDetail(postId));
		model.addAttribute("categories", boardService.getCategories());
		return "board/edit";
	}

	// 글 수정
	@PostMapping("/edit")
	public String edit(BoardPostDTO post, @RequestParam(value = "file", required = false) MultipartFile file,
			@RequestParam(value = "fileUrl", required = false) String fileUrl) throws Exception {

		// fileUrl 수정 반영
		post.setFileUrl(fileUrl);
		boardService.updatePost(post);

		// 새 파일 업로드 시 처리 (기존 파일 덮어쓰기)
		if (file != null && !file.isEmpty()) {
			String uploadDir = "D:/uploads/board";
			File dir = new File(uploadDir);
			if (!dir.exists())
				dir.mkdirs();

			String ext = file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf("."));
			String storedName = UUID.randomUUID().toString() + ext;

			File saveFile = new File(uploadDir, storedName);
			file.transferTo(saveFile);

			// 기존 첨부 삭제 후 새로 등록하는 로직도 가능
			boardService.deleteAttachmentByPostId(post.getPostId());

			BoardAttachmentDTO attach = new BoardAttachmentDTO();
			attach.setPostId(post.getPostId());
			attach.setOriginalName(file.getOriginalFilename());
			attach.setStoredName(storedName);
			attach.setStoragePath(uploadDir + "/" + storedName);
			attach.setFileSize(file.getSize());
			attach.setContentType(file.getContentType());
			attach.setUploaderId(post.getWriterId());

			boardService.insertAttachment(attach);
		}

		return "redirect:/board/view?id=" + post.getPostId();
	}

	// 글 삭제
	@PostMapping("/delete")
	public String delete(@RequestParam("postId") int postId) {
		boardService.deletePost(postId);
		return "redirect:/board/list";
	}

	@PostMapping("/comment/add")
	public String addComment(BoardCommentDTO comment, HttpSession session) {
		UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
		if (loginUser == null)
			return "redirect:/login";

		comment.setWriterId(loginUser.getUserId());
		comment.setCommentId(boardService.getNextCommentId());

		// level 기본값 처리
		if (comment.getCommentLevel() == 0)
			comment.setCommentLevel(1);

		boardService.insertComment(comment);
		return "redirect:/board/view?id=" + comment.getPostId();
	}

	// 댓글 수정
	@PostMapping("/comment/update")
	public String updateComment(BoardCommentDTO comment, HttpSession session) {
		UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
		if (loginUser == null)
			return "redirect:/login";

		comment.setWriterId(loginUser.getUserId());

		System.out.println("[DEBUG] 댓글 수정: commentId=" + comment.getCommentId() + ", content=" + comment.getContent());

		boardService.updateComment(comment);
		return "redirect:/board/view?id=" + comment.getPostId();
	}

	// 댓글 삭제
	@PostMapping("/comment/delete")
	public String deleteComment(@RequestParam("commentId") int commentId, @RequestParam("postId") int postId,
			HttpSession session) {
		UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
		if (loginUser == null)
			return "redirect:/login";

		System.out.println("[DEBUG] 댓글 삭제: commentId=" + commentId);

		boardService.deleteComment(commentId);
		return "redirect:/board/view?id=" + postId;
	}
}
