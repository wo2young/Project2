<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="/WEB-INF/views/includes/header.jsp"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>게시판</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
<style>
/* ======== 게시판 전용 스타일 (공통 제거 후 정리본) ======== */

/* ✅ 공통 다크모드 및 버튼, 테이블, 페이징 등은 common.css에서 관리됨 */
/* ✅ 여기서는 게시판 전용 레이아웃 및 탭, 챗봇 UI만 유지 */

/* 페이지 전체 영역 */
main {
  overflow: auto;
  -webkit-overflow-scrolling: touch;
}

.wrap {
  max-width: 1100px;
  margin: 24px auto;
  padding: 0 16px;
}

/* 페이지 헤더 */
.page-head {
  display: flex;
  align-items: end;
  justify-content: space-between;
  gap: 12px;
  margin: 12px 0 16px;
}

.page-head h2 {
  margin: 0;
  font-size: 22px;
  font-weight: 800;
}

.muted {
  color: var(--muted, #aab4d4);
  font-size: 13px;
  margin: 6px 0 0;
}

/* ======== 게시판 카테고리 탭 ======== */
.tabs {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
  margin: 8px 0 10px;
}

.tab {
  padding: 8px 14px;
  border: 1px solid var(--line, #374151);
  border-radius: 999px;
  text-decoration: none;
  color: var(--muted, #aab4d4);
  background: var(--card, #111827);
  transition: 0.15s;
  line-height: 1;
  white-space: nowrap;
}

.tab:hover {
  background: var(--hover, #1a2333);
  color: #fff;
  transform: translateY(-1px);
}

.tab.active {
  background: var(--primary, #f59e0b);
  color: #111827;
  border-color: var(--primary, #f59e0b);
}

/* ======== 검색바 ======== */
.toolbar {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 8px;
  background: var(--card);
  border: 1px solid var(--line);
  border-radius: 12px;
  padding: 10px;
}

.toolbar input[type="text"] {
  flex: 1;                    /* 입력창은 남는 공간 채우기 */
  min-width: 180px;
  padding: 8px 10px;
  border: 1px solid var(--line);
  border-radius: 8px;
  background: var(--input-bg);
  color: var(--text);
}

.toolbar .btn {
  flex-shrink: 0;              /* 줄어들지 않게 */
  padding: 8px 14px;
  font-weight: 600;
  border-radius: 8px;
  cursor: pointer;
  border: none;
  transition: 0.2s;
}

/* 검색 버튼 (흰색 계열) */
.toolbar .btn-search {
  background: #e5e7eb;
  color: #111;
}
.toolbar .btn-search:hover {
  background: #d1d5db;
}

/* 글쓰기 버튼 (강조 색상) */
.toolbar .btn-write {
  background: var(--primary);
  color: #111;
}
.toolbar .btn-write:hover {
  background: var(--primary-hover);
}

/* 글쓰기 버튼만 살짝 줄이기 */
.btn-write {
  padding: 6px 12px;   /* 기존보다 높이 약 4px 감소 */
  font-size: 14px;     /* 살짝 작게 조정 */
  line-height: 1.4;
}

/* ======== 게시판 카드(목록 테두리용) ======== */
.card {
  background: var(--card, #111827);
  border: 1px solid var(--line, #374151);
  border-radius: 12px;
  overflow: hidden;
}

/* ======== 제목/카테고리 ======== */
.title-cell {
  display: flex;
  align-items: center;
  gap: 8px;
  min-width: 240px;
}

.title-link {
  color: var(--text, #e6ebff);
  text-decoration: none;
  display: inline-block;
  max-width: 100%;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.badge {
  display: inline-block;
  background: #f87171;
  color: #fff;
  padding: 2px 8px;
  border-radius: 999px;
  font-size: 12px;
  flex-shrink: 0;
}

.cat-pill {
  display: inline-block;
  padding: 4px 8px;
  border: 1px solid var(--primary, #f59e0b);
  border-radius: 999px;
  font-size: 12px;
  color: var(--primary, #f59e0b);
  background: transparent;
  white-space: nowrap;
}

/* ======== 챗봇 UI ======== */
.chatbot-icon {
  position: fixed;
  bottom: 20px;
  right: 20px;
  cursor: pointer;
  font-size: 28px;
  background: var(--primary, #f59e0b);
  color: #111827;
  border-radius: 50%;
  width: 55px;
  height: 55px;
  text-align: center;
  line-height: 55px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
  z-index: 999;
}

.chatbot-popup {
  display: none;
  position: fixed;
  bottom: 90px;
  right: 20px;
  width: 320px;
  height: 400px;
  background: var(--card, #111827);
  border: 1px solid var(--line, #374151);
  border-radius: 12px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.4);
  padding: 10px;
  z-index: 1000;
}

.chatbot-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-weight: bold;
  margin-bottom: 5px;
  color: var(--text, #e6ebff);
}

#chatLog {
  width: 100%;
  height: 280px;
  margin-bottom: 8px;
  padding: 5px;
  resize: none;
  background: var(--input-bg, #1f2937);
  color: var(--text, #e6ebff);
  border: 1px solid var(--line, #374151);
  border-radius: 6px;
  white-space: normal;
}

#userInput {
  width: 70%;
  padding: 5px;
  background: var(--input-bg, #1f2937);
  color: var(--text, #e6ebff);
  border: 1px solid var(--line, #374151);
  border-radius: 6px;
}

#sendBtn {
  padding: 6px 12px;
  background: var(--primary, #f59e0b);
  border: none;
  border-radius: 6px;
  font-weight: bold;
  cursor: pointer;
}

#sendBtn:hover {
  background: var(--primary-hover, #d97706);
}

/* 챗봇 ‘생각 중...’ 애니메이션 */
.thinking {
  color: var(--muted, #aab4d4);
  font-style: italic;
  animation: blink 1.2s infinite;
}

@keyframes blink {
  50% { opacity: 0.4; }
}

/* ======== 반응형 추가 ======== */
@media (max-width: 1024px) {
  .page-head h2 {
    font-size: 20px;
  }

  .tabs {
    justify-content: center;
  }

  .toolbar {
    flex-direction: column;
    align-items: stretch;
    text-align: center;
  }

  .toolbar input[type="text"] {
    width: 100%;
  }
}

@media (max-width: 768px) {
   .toolbar {
    flex-direction: column;
    align-items: stretch;
  }

  .toolbar input[type="text"] {
    width: 100%;
  }

  .toolbar .btn {
    width: 100%;
    text-align: center;
    padding: 10px 0;   /* 높이 균형 맞추기 */
  }
  
  table {
    display: block;
    overflow-x: auto;
    white-space: nowrap;
  }

  .toolbar .btn-write {
    width: 100%;
    padding: 8px 0;    /* 글쓰기 버튼만 살짝 줄이기 */
  }

  th, td {
    padding: 8px;
    font-size: 13px;
  }

  .chatbot-popup {
    width: 90%;
    right: 5%;
    bottom: 80px;
  }

  .chatbot-icon {
    width: 50px;
    height: 50px;
    line-height: 50px;
    font-size: 24px;
  }
}
</style>
</head>
<body>

	<main class="wrap">
		<div class="page-head">
			<h2>게시판</h2>
			<p class="muted">
				※ <b>공지</b> 카테고리 글은 항상 제목 옆에 표시됩니다.
			</p>
		</div>

		<!-- 탭 -->
		<div class="tabs">
			<a class="tab ${empty selectedCategoryId ? 'active' : ''}"
				href="${ctx}/board">전체</a>
			<c:forEach var="c" items="${categories}">
				<c:if test="${c.categoryName ne '공지'}">
					<a
						class="tab ${selectedCategoryId == c.categoryId ? 'active' : ''}"
						href="${ctx}/board?categoryId=${c.categoryId}"> <c:out
							value="${c.categoryName}" />
					</a>
				</c:if>
			</c:forEach>
		</div>

		<!-- 검색/글쓰기 -->
		<form class="toolbar" method="get" action="${ctx}/board">
		  <input type="text" name="keyword" value="${param.keyword}" placeholder="제목 또는 본문 키워드">
		  <button class="btn btn-search" type="submit">검색</button>
		  <a class="btn btn-write" href="${ctx}/board/write">글쓰기</a>
		</form>

		<!-- 목록 -->
		<div class="card" style="margin-top: 10px">
			<table>
				<thead>
					<tr>
						<th style="width: 160px">카테고리</th>
						<th>제목</th>
						<th style="width: 120px">작성자</th>
						<th style="width: 170px">작성일</th>
						<th style="width: 90px" class="right">조회</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="p" items="${posts}">
						<tr>
							<td><c:set var="catName" value="" /> <c:forEach var="c"
									items="${categories}">
									<c:if test="${c.categoryId == p.categoryId}">
										<c:set var="catName" value="${c.categoryName}" />
									</c:if>
								</c:forEach> <span class="cat-pill"> <c:out
										value="${empty catName ? p.categoryId : catName}" />
							</span></td>
							<td>
								<div class="title-cell">
									<a class="title-link" href="${ctx}/board/view?id=${p.postId}">
										<c:out value="${p.title}" />
									</a>
									<!-- ✅ 카테고리가 공지(1)일 때 빨간 라벨 -->
									<c:if test="${p.categoryId == 1}">
										<span class="badge">공지</span>
									</c:if>
								</div>
							</td>
							<td><c:out value="${p.writerId}" /></td>
							<td><fmt:formatDate value="${p.createdAt}"
									pattern="yyyy-MM-dd HH:mm" /></td>
							<td class="right">${p.viewCount}</td>
						</tr>
					</c:forEach>
					<c:if test="${empty posts}">
						<tr>
							<td colspan="5" style="text-align: center">게시글이 없습니다.</td>
						</tr>
					</c:if>
				</tbody>
			</table>
		</div>

		<!-- ✅ 페이징 -->
		<!-- ✅ board/list.jsp 공통 페이징 최종 버전 -->
		<div class="pagination">
		  <!-- 맨 앞으로 (≪) / 이전 (<) -->
		  <c:if test="${page > 1}">
		    <a href="${ctx}/board?page=1&categoryId=${param.categoryId}&keyword=${param.keyword}">≪</a>
		    <a href="${ctx}/board?page=${page - 1}&categoryId=${param.categoryId}&keyword=${param.keyword}">‹</a>
		  </c:if>
		  <c:if test="${page <= 1}">
		    <span class="disabled">≪</span>
		    <span class="disabled">‹</span>
		  </c:if>
		  <!-- 페이지 번호 반복 -->
		  <c:forEach var="p" begin="${startPage}" end="${endPage}">
		    <a href="${ctx}/board?page=${p}&categoryId=${param.categoryId}&keyword=${param.keyword}"
		       class="${p == page ? 'active' : ''}">
		      ${p}
		    </a>
		  </c:forEach>
		  <!-- 다음 (>) / 맨 뒤로 (≫) -->
		  <c:if test="${page < totalPage}">
		    <a href="${ctx}/board?page=${page + 1}&categoryId=${param.categoryId}&keyword=${param.keyword}">›</a>
		    <a href="${ctx}/board?page=${totalPage}&categoryId=${param.categoryId}&keyword=${param.keyword}">≫</a>
		  </c:if>
		  <c:if test="${page >= totalPage}">
		    <span class="disabled">›</span>
		    <span class="disabled">≫</span>
		  </c:if>
		</div>
	</main>

	<!-- ✅ 챗봇 아이콘 -->
	<div class="chatbot-icon" onclick="toggleChatbot()">🤖</div>

	<!-- ✅ 챗봇 팝업 -->
	<div id="chatbotPopup" class="chatbot-popup">
		<div class="chatbot-header">
			<span>또야또야 MES AI</span>
			<button onclick="toggleChatbot()">X</button>
		</div>

		<!-- ✅ 로그창 -->
		<div id="chatLog"
			style="width: 100%; height: 280px; overflow-y: auto; background: var(--input-bg); color: var(--text-color); border: 1px solid var(--line); border-radius: 6px; padding: 8px; font-size: 14px; white-space: normal;">
		</div>

		<div style="margin-top: 8px; display: flex; gap: 6px;">
			<input type="text" id="userInput" placeholder="메시지를 입력하세요"
				style="flex: 1; padding: 6px;" />
			<button id="sendBtn" onclick="sendMessage()">전송</button>
		</div>
	</div>

<script>
function toggleChatbot() {
  const popup = document.getElementById("chatbotPopup");
  const visible = popup.style.display === "block";
  popup.style.display = visible ? "none" : "block";
  if (visible) fetch("${ctx}/chatbot/reset", { method: "POST" });
}

function appendMessage(sender, text, isThinking = false) {
  const chatLog = document.getElementById("chatLog");
  const msg = document.createElement("div");
  msg.style.marginBottom = "6px";
  msg.style.lineHeight = "1.4";

  // '생각 중...'은 회색 기울임체로 표시
  if (isThinking) {
    msg.className = "thinking";
    msg.style.color = "#aaa";
    msg.style.fontStyle = "italic";
  }

  msg.innerHTML = "<b>" + sender + ":</b> " + text;
  chatLog.appendChild(msg);
  chatLog.scrollTop = chatLog.scrollHeight;
  return msg; // DOM 객체 반환 (삭제용)
}

async function sendMessage() {
  const userInput = document.getElementById("userInput");
  const userText = userInput.value.trim();
  if (!userText) return;

  appendMessage("사용자", userText);
  userInput.value = "";

  // ✅ 챗봇 "생각 중..." 메시지 표시
  const thinkingMsg = appendMessage("봇", "답변 생각 중...", true);

  try {
    const res = await fetch("${ctx}/chatbot", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: "message=" + encodeURIComponent(userText)
    });

    const data = await res.json();
    const botReply = data.reply || "응답 없음";

    // ✅ '생각 중...' 제거 후 실제 답변 표시
    thinkingMsg.remove();
    appendMessage("봇", botReply);

  } catch (err) {
    thinkingMsg.remove();
    appendMessage("봇", "[오류 발생: " + err.message + "]");
  }
}

document.addEventListener("DOMContentLoaded", () => {
  appendMessage("봇", "안녕하세요! MES 고객센터입니다 😊<br>궁금한 점을 물어봐주세요♡");

  const input = document.getElementById("userInput");
  input.addEventListener("keydown", e => {
    if (e.key === "Enter" && !e.shiftKey) {
      e.preventDefault();
      sendMessage();
    }
  });
});
</script>

</body>
</html>
