<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="/WEB-INF/views/includes/header.jsp"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="loginUserId" value="${sessionScope.loginUserId}" />
<c:set var="isAdmin" value="${sessionScope.isAdmin}" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title><c:out value="${post.title}" /> - 게시글</title>
<style>
:root { 
--bg: #0a0f1a; 
--panel: #0f1626; 
--line: #1f2b45; 
--text: #e6ebff; 
--muted: #a7b0c5; 
--input: #1a202c; 
--accent: #f59e0b; 
--accent-hover: #d97706; 
--blue: #1e3a8a; 
--blue-hover: #2563eb; 
--danger: #c2410c; 
--danger-bg: #7f1d1d; 
--danger-border: #b91c1c; 
--hover: #111a2b;
}

* {
	box-sizing: border-box
}

body {
	margin: 0;
	padding: 0;
	background: var(--bg);
	color: var(--text);
	font-family: system-ui, Segoe UI, Arial, 'Noto Sans KR', sans-serif
}

.wrap {
	max-width: 900px;
	margin: 24px auto;
	padding: 0 16px
}

.card {
	background: var(--panel);
	border: 1px solid var(--line);
	border-radius: 12px;
	overflow: hidden
}

.card-body {
	padding: 12px 14px;
}

.title {
	margin: 0 0 6px;
	font-size: 22px;
	line-height: 1.35;
	word-break: break-word
}

.sub {
	display: flex;
	gap: 10px;
	flex-wrap: wrap;
	align-items: center
}

.meta {
	color: var(--muted);
	font-size: 13px
}

.pill {
	display: inline-block;
	padding: 2px 8px;
	border-radius: 999px;
	font-size: 12px;
	font-weight: 600;
	color: #111827;
	background: var(--accent);
	border: 1px solid var(--accent)
}

.content {
	white-space: normal;
	border-top: 1px solid var(--line);
	padding-top: 12px;
	margin-top: 12px;
	line-height: 1.7
}

.files {
	margin-top: 8px
}

.file-item {
	display: flex;
	align-items: center;
	gap: 8px;
	padding: 6px 0;
	border-top: 1px dashed var(--line)
}

.file-item:first-child {
	border-top: none
}

.btn {
	display: inline-block;
	min-width: 70px;
	text-align: center;
	padding: 6px 10px;
	border-radius: 10px;
	cursor: pointer;
	text-decoration: none;
	font-weight: 600;
	border: 1px solid var(--line);
	background: var(--panel);
	color: var(--text);
	transition: .15s;
	font-size: 13px
}

.btn:hover {
	background: var(--hover);
	transform: translateY(-1px)
}

.btn-primary {
	background: var(--accent);
	border-color: var(--accent);
	color: #111827
}

.btn-primary:hover {
	background: var(--accent-hover);
	border-color: var(--accent-hover)
}

.btn-blue {
	background: var(--blue);
	border-color: var(--blue);
	color: #e6ebff
}

.btn-blue:hover {
	background: var(--blue-hover);
	border-color: var(--blue-hover);
	color: #fff
}

.btn-danger {
	background: transparent;
	border-color: var(--danger-border);
	color: #fecaca
}

.btn-danger:hover {
	background: var(--danger-bg);
	border-color: var(--danger-border);
	color: #fff;
	box-shadow: 0 0 0 3px rgba(220, 38, 38, .15)
}

.toolbar {
  display: flex;
  align-items: center;       /* 버튼 세로 중앙 정렬 */
  gap: 10px;                 /* 버튼 간격 일정하게 */
  margin-top: 12px;
  flex-wrap: wrap;           /* 혹시 버튼이 많아질 경우 자동 줄바꿈 */
}

.toolbar a,
.toolbar form {
  display: flex;             /* form 안 버튼을 flex로 정렬 */
  align-items: center;       /* 버튼 세로 정렬 동일하게 */
  margin: 0;                 /* 여백 제거 */
}

.toolbar .btn {
  height: 38px;              /* 버튼 높이 고정 (a, button 동일하게) */
  display: flex;
  align-items: center;
  justify-content: center;
}

.cm-row {
	background: var(--panel);
	border: 1px solid var(--line);
	border-radius: 8px;
	padding: 8px 12px;
	margin: 8px 0;
}

.cm-row.reply {
	margin-left: 18px;
	border-left: 2px solid var(--line);
	padding-left: 10px;
	border-radius: 8px;
	background-color: #111a2b;
}

.cm-meta {
	font-weight: 700;
	color: #e6ebff;
	margin-right: 6px;
}

.meta {
	color: var(--muted);
	font-size: 13px;
}

.cm-text {
	margin: 4px 0 6px;
	line-height: 1.5;
	font-size: 14px;
	padding-left: 0;
}

.cm-actions {
	margin-top: 4px;
}

textarea {
	width: 100%;
	padding: 10px;
	border: 1px solid var(--line);
	border-radius: 10px;
	background: var(--input);
	color: var(--text)
}

textarea:focus {
	outline: none;
	border-color: var(--accent);
	box-shadow: 0 0 0 2px rgba(245, 158, 11, .2)
}

details summary {
	cursor: pointer;
	color: var(--blue-hover)
}

details[open] summary {
	color: var(--accent)
}
</style>

<script>
function toggleEditForm(id){
  const div = document.getElementById("cm-view-"+id);
  const form = document.getElementById("cm-edit-"+id);
  if(div.style.display === "none"){
    div.style.display="block"; form.style.display="none";
  } else {
    div.style.display="none"; form.style.display="block";
  }
  return false;
}
</script>
</head>

<body>
	<main class="wrap">

		<!-- 게시글 -->
		<div class="card">
			<div class="card-body">
				<h2 class="title">
					<c:out value="${post.title}" />
				</h2>
				<div class="sub">
					<span class="meta">글번호 #${post.postId}</span> <span class="meta">작성자
						<c:out value="${post.writerLoginId}" />
					</span> <span class="meta">조회수 ${post.viewCount}</span> <span class="meta">
						작성일 <fmt:formatDate value="${post.createdAt}"
							pattern="yyyy-MM-dd HH:mm" />
					</span>
					<c:if test="${post.noticeYn == 'Y'}">
						<span class="pill">공지</span>
					</c:if>
				</div>

				<div class="content">
					<c:out value="${post.content}" />
				</div>

				<c:if test="${not empty attachments}">
					<div class="files">
						<strong>첨부파일:</strong>
						<c:forEach var="f" items="${attachments}">
							<div class="file-item">
								📎 <span><c:out value="${f.originalName}" /></span> <span
									class="meta">(${f.fileSize} bytes)</span>
							</div>
						</c:forEach>
					</div>
				</c:if>

				<!-- ✅ 목록 + 수정/삭제 버튼 (게시글 작성자 or 관리자만 보이게) -->
				<div class="toolbar">
					<a class="btn btn-primary" href="${ctx}/board">목록</a>

					<c:if test="${isAdmin or loginUserId == post.writerId}">
						<a class="btn btn-blue" href="${ctx}/board/edit/${post.postId}">수정</a>
						<form method="post" action="${ctx}/board/delete"
							style="display: inline" onsubmit="return confirm('게시글을 삭제할까요?');">
							<input type="hidden" name="postId" value="${post.postId}" />
							<button class="btn btn-danger" type="submit">삭제</button>
						</form>
					</c:if>
				</div>
			</div>
		</div>

		<!-- 댓글 -->
		<h3 id="comments" style="margin: 18px 0 8px">댓글</h3>
		<c:forEach var="cm" items="${comments}">
			<div class="card cm-row ${cm.commentLevel == 2 ? 'reply' : ''}">
				<div class="card-body">
					<div>
						<span class="cm-meta"><c:out value="${cm.writerName}" /></span> <span
							class="meta">· <fmt:formatDate value="${cm.createdAt}"
								pattern="yyyy-MM-dd HH:mm" /></span>
					</div>

					<div id="cm-view-${cm.commentId}" class="cm-text">
						<c:out value="${cm.content}" />
					</div>

					<!-- 댓글 수정 폼 -->
					<form id="cm-edit-${cm.commentId}" method="post"
						action="${ctx}/board/comment/update"
						style="display: none; margin-top: 6px">
						<input type="hidden" name="commentId" value="${cm.commentId}" />
						<input type="hidden" name="postId" value="${post.postId}" />
						<textarea name="content" rows="3" required><c:out
								value="${cm.content}" /></textarea>
						<div style="margin-top: 6px">
							<button class="btn btn-primary" type="submit">저장</button>
							<button class="btn"
								onclick="return toggleEditForm(${cm.commentId})">취소</button>
						</div>
					</form>

					<!-- 댓글 수정/삭제 버튼 -->
					<c:if test="${isAdmin or loginUserId eq post.writerId}">
						<div class="cm-actions">
							<button class="btn btn-blue"
								onclick="return toggleEditForm(${cm.commentId})">수정</button>
							<form method="post" action="${ctx}/board/comment/delete"
								style="display: inline" onsubmit="return confirm('댓글을 삭제할까요?');">
								<input type="hidden" name="commentId" value="${cm.commentId}" />
								<input type="hidden" name="postId" value="${post.postId}" />
								<button class="btn btn-danger" type="submit">삭제</button>
							</form>
						</div>
					</c:if>

					<!-- 답글 -->
					<c:if test="${cm.commentLevel != 2}">
						<details style="margin-top: 6px">
							<summary>답글 달기</summary>
							<form method="post" action="${ctx}/board/comment/add"
								style="margin-top: 6px">
								<input type="hidden" name="postId" value="${post.postId}" /> <input
									type="hidden" name="parentId" value="${cm.commentId}" /> <input
									type="hidden" name="commentLevel" value="2" />
								<textarea name="content" rows="3" placeholder="답글을 입력하세요"
									required></textarea>
								<div style="margin-top: 6px">
									<button class="btn btn-primary" type="submit">등록</button>
								</div>
							</form>
						</details>
					</c:if>
				</div>
			</div>
		</c:forEach>

		<!-- 최상위 댓글 작성 -->
		<div class="card" style="margin-top: 14px">
			<div class="card-body">
				<form method="post" action="${ctx}/board/comment/add">
					<input type="hidden" name="postId" value="${post.postId}" /> <input
						type="hidden" name="level" value="1" />
					<textarea name="content" rows="4" placeholder="댓글을 입력하세요" required></textarea>
					<div style="margin-top: 8px">
						<button class="btn btn-primary" type="submit">댓글 등록</button>
					</div>
				</form>
			</div>
		</div>

	</main>
</body>
</html>
