<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="cxt" value="${pageContext.request.contextPath}" />
<c:set var="user" value="${sessionScope.loginUser}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>글쓰기</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
<style>
/* ===== 글쓰기 페이지 전용 스타일 ===== */
main.wrap {
  max-width: 760px;
  margin: 0 auto;
  padding: calc(64px + 16px) 16px 24px; /* 헤더 높이 고려 */
}

/* ===== 게시글 작성 form 레이아웃 교정 ===== */
.editor label,
.editor input[type=text],
.editor textarea,
.editor select,
.editor input[type=file] {
  display: block;
  width: 100%;
  box-sizing: border-box;
}

/* label과 input 간격 */
.editor label {
  margin-top: 16px;
  margin-bottom: 6px;
  font-weight: 600;
  color: var(--muted);
}

/* input/textarea 영역 */
.editor input[type=text],
.editor textarea,
.editor select,
.editor input[type=file] {
  background: var(--input-bg, #111827);
  border: 1px solid var(--line, #2c354a);
  border-radius: 8px;
  padding: 10px;
  color: var(--text, #e6ebff);
  font-size: 14px;
}

/* textarea 높이 조정 */
.editor textarea {
  resize: vertical;
  min-height: 160px;
}

/* input focus */
.editor input:focus,
.editor textarea:focus,
.editor select:focus {
  outline: none;
  border-color: var(--primary, #f59e0b);
  box-shadow: 0 0 0 2px rgba(245, 158, 11, 0.2);
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  margin-top: 24px;
}

.form-actions .btn {
  padding: 10px 20px;
  border-radius: 6px;
  font-weight: 600;
  width: auto; /* ✅ PC에서는 자동 너비로 복원 */
  flex: 0 0 auto;
}

/* 취소 버튼 */
.btn-cancel {
  background: #1e3a8a;
  border: 1px solid #1e3a8a;
  color: #e6ebff;
}
.btn-cancel:hover {
  background: #2563eb;
  border-color: #2563eb;
  color: #fff;
}


/* ===== 반응형 (모바일용) ===== */
@media (max-width: 768px) {
  .editor {
    padding: 16px;
  }

  .form-actions {
    flex-direction: column;
    gap: 8px;
  }

  .form-actions .btn {
    width: 100%; /* ✅ 모바일에서만 꽉 차게 */
  }
}
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/includes/header.jsp"></jsp:include>

	<main class="wrap">
		<h2>게시글 작성</h2>


		<form class="editor" method="post" action="${cxt}/board/write"
			enctype="multipart/form-data" onsubmit="return v();">

			<!-- 카테고리 -->
			<label>카테고리</label> <select name="categoryId" required>
				<c:forEach var="c" items="${categories}">
					<c:if test="${!(c.categoryId == 1 && !sessionScope.isAdmin)}">
						<option value="${c.categoryId}">
							<c:out value="${c.categoryName}" />
						</option>
					</c:if>
				</c:forEach>
			</select>

			<!-- 제목 -->
			<label>제목</label> <input type="text" name="title"
				placeholder="제목을 입력하세요" required>

			<!-- 내용 -->
			<label>내용</label>
			<textarea name="content" rows="8" placeholder="내용을 입력하세요" required></textarea>

			<!-- 작성자 (숨김 필드) -->
			<input type="hidden" name="writerId" value="${user.userId}">

			<!-- 파일 업로드 -->
			<label>첨부파일</label> <input type="file" name="file" accept="*/*">

			<!-- 외부 링크 -->
			<label>첨부파일 링크</label> <input type="text" name="fileUrl"
				placeholder="Google Drive 또는 MyBox 링크 입력">

			<div class="form-actions">
			  <button type="submit" class="btn btn-primary">등록</button>
			  <button type="button" class="btn btn-cancel" onclick="location.href='${cxt}/board/list'">취소</button>
			</div>
		</form>
	</main>

	<script>
		function v() {
			const f = document.forms[0];
			if (!f.title.value.trim()) {
				alert('제목을 입력하세요');
				f.title.focus();
				return false;
			}
			if (!f.content.value.trim()) {
				alert('내용을 입력하세요');
				f.content.focus();
				return false;
			}
			if (!f.categoryId.value) {
				alert('카테고리를 선택하세요');
				return false;
			}
			return true;
		}
	</script>
</body>
</html>
