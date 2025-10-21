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
<style>
/* ===== 다크톤 팔레트 ===== */
:root { -
	-bg-color: #0a0f1a; -
	-panel-bg: #0f1626; -
	-line: #1f2b45; -
	-text-color: #e6ebff; -
	-muted: #a7b0c5; -
	-input-bg: #1a202c; -
	-accent: #f59e0b; -
	-accent-light: #d97706; -
	-hover: #1a2333; -
	-header-h: 64px;
}

* {
	box-sizing: border-box
}

html, body {
	margin: 0;
	padding: 0;
	background: var(- -bg-color);
	color: var(- -text-color);
	font-family: system-ui, Segoe UI, Arial, 'Noto Sans KR', sans-serif;
	min-height: 100dvh;
}

main.wrap {
	max-width: 760px;
	margin: 0 auto;
	padding: calc(var(- -header-h)+ 16px) 16px 24px;
}

h2 {
	font-size: 22px;
	margin: 0 0 20px;
	font-weight: 800;
	text-align: center;
}

.editor {
	background: var(- -panel-bg);
	border: 1px solid var(- -line);
	border-radius: 12px;
	padding: 20px;
	width: 100%;
	margin: 0 auto;
}

label {
	display: block;
	margin: 12px 0 6px;
	font-weight: 600;
	color: var(- -muted);
}

input[type=text], textarea, select {
	width: 100%;
	padding: 10px;
	border: 1px solid var(- -line);
	border-radius: 8px;
	background: var(- -input-bg);
	color: var(- -text-color);
	font-size: 14px;
}

textarea {
	resize: vertical
}

input[type=text]:focus, textarea:focus, select:focus {
	outline: none;
	border-color: var(- -accent);
	box-shadow: 0 0 0 2px rgba(245, 158, 11, .2);
}

.btn {
	display: inline-block;
	padding: 8px 14px;
	border: 1px solid var(- -line);
	border-radius: 10px;
	text-decoration: none;
	color: var(- -text-color);
	background: var(- -panel-bg);
	transition: background .15s, transform .15s, border-color .15s;
	min-width: 90px;
	text-align: center;
	font-weight: 600;
	cursor: pointer;
}

.btn:hover {
	background: var(- -hover);
	transform: translateY(-1px);
}

.btn-primary {
	background: var(- -accent);
	border-color: var(- -accent);
	color: #111827;
}

.btn-primary:hover {
	background: var(- -accent-light);
	border-color: var(- -accent-light);
	color: #111827;
}

.btn-cancel {
	background: #1e3a8a;
	border-color: #1e3a8a;
	color: #e6ebff;
}

.btn-cancel:hover {
	background: #2563eb;
	border-color: #2563eb;
	color: #fff;
}

.form-actions {
	display: flex;
	gap: 10px;
	margin-top: 20px;
	justify-content: flex-end;
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
				<button class="btn btn-primary" type="submit">등록</button>
				<a class="btn btn-cancel" href="${cxt}/board/list">취소</a>
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
