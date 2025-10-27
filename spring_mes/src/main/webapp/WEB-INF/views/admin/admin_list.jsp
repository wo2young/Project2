<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="../includes/header.jsp"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>사용자 목록</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">

<style>
/* ======== 사용자 관리 전용 스타일 (공통 제거 후 정리본) ======== */

/* ✅ 공통 테마/버튼/테이블/페이징은 common.css에서 관리됨 */
/* ✅ 여기서는 사용자 목록 전용 요소와 모달만 유지 */

/* 테이블 감싸는 카드 */
.table-container {
  background: var(--card);
  padding: 30px 40px;
  border-radius: 12px;
  box-shadow: 0 0 15px rgba(0, 0, 0, 0.5);
  max-width: 1200px;
  margin: 60px auto;
  color: var(--text);
}

/* 제목 */
h2 {
  color: var(--primary);
  margin-bottom: 24px;
  border-bottom: 2px solid var(--primary);
  padding-bottom: 6px;
  text-align: left;
  font-weight: 600;
  letter-spacing: 0.5px;
}

/* 모달 오버레이 */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.6);
  display: flex;
  justify-content: center;
  align-items: center;
  visibility: hidden;
  opacity: 0;
  transition: opacity 0.3s ease, visibility 0.3s ease;
  z-index: 999;
}

.modal-overlay.active {
  visibility: visible;
  opacity: 1;
}

/* 모달 박스 */
.modal-box {
  background: var(--card);
  color: var(--text);
  border-radius: 12px;
  padding: 40px 50px;
  text-align: center;
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.5);
  min-width: 380px;
  position: relative;
}

/* 닫기 버튼 */
.modal-close {
  position: absolute;
  top: 10px;
  right: 15px;
  font-size: 20px;
  color: #aaa;
  cursor: pointer;
}
.modal-close:hover {
  color: var(--primary);
}

/* 모달 텍스트 */
.modal-box h2 {
  color: var(--primary);
  margin-bottom: 15px;
  font-size: 22px;
}
.modal-box p {
  margin: 8px 0;
  line-height: 1.6;
}
.modal-box b {
  color: var(--primary);
  font-size: 18px;
}
</style>
</head>
<body>
	<div class="table-container">
		<h2>사용자 목록</h2>
		<div
			style="display: flex; justify-content: space-between; align-items: center;">
			<%@ include file="/WEB-INF/views/includes/adminTabs.jsp"%>
			<button class="btn btn-primary" onclick="loadUserAdd()">＋
				사용자 추가</button>
		</div>

		<table class="table">
			<thead>
				<tr>
					<th>번호</th>
					<th>아이디</th>
					<th>이름</th>
					<th>권한</th>
					<th>생성일</th>
					<th>비밀번호 초기화</th>
					<th>수정</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="u" items="${list}">
					<tr>
						<td>${u.userId}</td>
						<td>${u.loginId}</td>
						<td>${u.name}</td>
						<td>${u.role}</td>
						<td><fmt:formatDate value="${u.createdAt}"
								pattern="yyyy-MM-dd HH:mm" /></td>
						<td>
							<button class="btn btn-danger"
								onclick="resetPassword(${u.userId}, '${u.name}')">비밀번호
								리셋</button>
						</td>
						<td>
							<button class="btn btn-primary"
								onclick="loadUserEdit(${u.userId})">수정</button>
						</td>
					</tr>
				</c:forEach>
				<!-- ✅ 페이징 영역 -->
			</tbody>
		</table>
		<!-- ✅ admin_list.jsp 공통 페이징 정리 완료 -->
		<div class="pagination">
		  <!-- 맨 앞으로 (≪) / 이전 (<) -->
		  <c:if test="${page > 1}">
		    <a href="${pageContext.request.contextPath}/admin/users?page=1&q=${q}">≪</a>
		    <a href="${pageContext.request.contextPath}/admin/users?page=${page - 1}&q=${q}">‹</a>
		  </c:if>
		  <c:if test="${page <= 1}">
		    <span class="disabled">≪</span>
		    <span class="disabled">‹</span>
		  </c:if>
		
		  <!-- 페이지 번호 반복 -->
		  <c:forEach var="i" begin="${startPage}" end="${endPage}">
		    <a href="${pageContext.request.contextPath}/admin/users?page=${i}&q=${q}"
		       class="${page == i ? 'active' : ''}">
		      ${i}
		    </a>
		  </c:forEach>
		  <!-- 다음 (>) / 맨 뒤로 (≫) -->
		  <c:if test="${page < totalPage}">
		    <a href="${pageContext.request.contextPath}/admin/users?page=${page + 1}&q=${q}">›</a>
		    <a href="${pageContext.request.contextPath}/admin/users?page=${totalPage}&q=${q}">≫</a>
		  </c:if>
		  <c:if test="${page >= totalPage}">
		    <span class="disabled">›</span>
		    <span class="disabled">≫</span>
		  </c:if>
		</div>
	</div>

	<!-- ✅ 모달 -->
	<div class="modal-overlay" id="resetModal">
		<div class="modal-box">
			<span class="modal-close" id="modalClose">&times;</span>
			<h2>비밀번호 재설정 메일 발송 완료</h2>
			<p>
				사용자: <b id="modalUser"></b> (<span id="modalLoginId"></span>)
			</p>
			<p>
				해당 사용자의 이메일로 <b>비밀번호 재설정 링크</b>가 발송되었습니다.
			</p>
			<p>메일을 확인하고, 1시간 이내에 새 비밀번호를 설정하세요.</p>
		</div>
	</div>

	<script>
		function loadUserAdd() {
		  fetch("${pageContext.request.contextPath}/admin/userAdd")
		    .then(res => res.text())
		    .then(html => document.getElementById("tabContent").innerHTML = html);
		}
		
		function loadUserEdit(id) {
		  fetch("${pageContext.request.contextPath}/admin/userEdit?id=" + id)
		    .then(res => res.text())
		    .then(html => document.getElementById("tabContent").innerHTML = html);
		}
		
		//✅ 비밀번호 리셋
		function resetPassword(id, name) {
		  fetch("${pageContext.request.contextPath}/admin/users/reset-pw?id=" + id, { method: "POST" })
		    .then(res => res.json())
		    .then(data => {
		      if (data.status === "ok") {
		        const modal = document.getElementById('resetModal');
		        document.getElementById('modalUser').textContent = data.name;
		        document.getElementById('modalLoginId').textContent = data.loginId;
		        modal.classList.add('active');
		        setTimeout(() => modal.classList.remove('active'), 4000);
		      } else {
		        alert("리셋 실패: " + (data.message || "관리자에게 문의하세요."));
		      }
		    })
		    .catch(err => alert("리셋 실패: " + err.message));
		}
	</script>
</body>
</html>
