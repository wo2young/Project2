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
<link rel="stylesheet" href="${ctx}/resources/css/common.css">
<style>
/* ===== 게시글 상세 페이지 전용 ===== */
.wrap {
  max-width: 900px;
  margin: 24px auto;
  padding: 0 16px;
}

/* 카드 구조 */
.card {
  background: var(--card);
  border: 1px solid var(--line);
  border-radius: 12px;
  overflow: hidden;
}
.card-body { padding: 16px; }

/* 제목, 메타정보 */
.title {
  font-size: 22px;
  font-weight: 800;
  margin: 0 0 8px;
  word-break: break-word;
}
.sub {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  font-size: 13px;
  color: var(--muted);
  margin-bottom: 12px;
}
.pill {
  display: inline-block;
  padding: 3px 8px;
  border-radius: 999px;
  background: var(--primary);
  color: #111;
  font-weight: 600;
  font-size: 12px;
}

/* 본문 */
.content {
  border-top: 1px solid var(--line);
  margin-left: -140px; /* 4~8px 사이로 조정 */
  margin-top: 10px;
  line-height: 1.7;
  white-space: pre-wrap;
  text-align: left;      /* ✅ 텍스트 좌측 정렬 */
}

/* 파일 목록 */
.file-item {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 6px 0;
  border-top: 1px dashed var(--line);
  font-size: 14px;
}
.file-item:first-child { border-top: none; }

/* 툴바 버튼 */
.toolbar {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 8px;
  margin-top: 14px;
}
.toolbar .btn {
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: fff;
}

.btn-blue {
  background: #2563eb;       /* 중간 블루톤 */
  border-color: #2563eb;
  color: #e6ebff;
}
.btn-blue:hover {
  background: #3b82f6;       /* hover 시 더 밝은 블루 */
  border-color: #3b82f6;
  color: #fff;
}

/*  a태그 버튼 높이 보정  */
 a.btn { 
   display: inline-flex;      /* 인라인 요소를 플렉스로 */ 
   align-items: center;       /* 텍스트 세로 중앙 정렬 */ 
   justify-content: center; */
   height: 36px;              /* button과 같은 높이 */ 
   line-height: 1;            /* 기준선 통일 */ 
   padding: 0 12px;           /* 상하 여백 제거, 좌우만 유지 */ 
   vertical-align: middle;    /* 줄 간 간격 정렬 */ 
   margin-bottom: 16px;
 } 

/* 댓글 */
.cm-row {
  background: var(--card);
  border: 1px solid var(--line);
  border-radius: 8px;
  padding: 8px 12px;
  margin: 8px 0;
}
.cm-row.reply {
  margin-left: 18px;
  border-left: 2px solid var(--line);
  background-color: var(--hover);
}
.cm-meta {
  font-weight: 700;
  color: var(--text);
  margin-right: 6px;
}
.cm-text {
  margin: 4px 0 6px;
  font-size: 14px;
  line-height: 1.5;
}
.cm-actions { margin-top: 4px; }

/* 댓글 textarea */
textarea {
  width: 100%;
  padding: 10px;
  border: 1px solid var(--line);
  border-radius: 10px;
  background: var(--input-bg);
  color: var(--text);
  resize: vertical;
}
textarea:focus {
  border-color: var(--primary);
  box-shadow: 0 0 0 2px rgba(245, 158, 11, 0.2);
}

/* ===== 반응형 ===== */
@media (max-width: 768px) {
  .wrap { padding: 0 12px; }

  .toolbar {
    flex-wrap: wrap;
    justify-content: left;
  }

/*   .toolbar .btn { */
/*     flex: 1 1 30%;             /* 한 줄에 3개까지 균등 분할 */ */
/*     min-width: 90px; */
/*     max-width: 180px; */
/*     color: fff; */
/*   } */

  a.btn {
    min-width: 100px;   /* 최소 크기 (버튼 너무 작아지지 않게) */
    max-width: 160px;   /* 최대 크기 제한 (너무 커지지 않게) */
    flex: 1 1 auto;     /* flex 컨테이너 안에서 자동 크기 조정 */
  }

  .content {
    font-size: 15px;
  }

  textarea {
    font-size: 14px;
  }
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
								📎 <span><c:out value="${f.originalName}" /></span> 
								<span class="meta">(${f.fileSize} bytes)</span>
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
