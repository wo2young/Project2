<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="/WEB-INF/views/includes/header.jsp"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>불량 승인 관리</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">

<style>
/* ======== 승인 페이지 전용 스타일 (공통 제거 후 정리본) ======== */

/* ✅ 공통 색상, 테이블, 버튼, 페이징은 common.css에서 관리 */
/* ✅ 여기서는 승인 전용 요소만 유지 */

.admin-card {
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

/* 상단 바 */
.top-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

/* 필터 버튼 영역 */
.filter-buttons {
  text-align: right;
  margin-bottom: 16px;
}

.filter-buttons a {
  margin-left: 6px;
  padding: 6px 14px;
  border-radius: 6px;
  text-decoration: none;
  color: #fff;
  font-weight: 600;
  background-color: #374151;
}

.filter-buttons a.active {
  background-color: #2563eb;
}

/* 상태 컬러 표시 */
.status {
  font-weight: bold;
}

.status.PENDING {
  color: #f1c40f;
}

.status.APPROVED {
  color: #4caf50;
}

.status.REJECTED {
  color: #e74c3c;
}

/* 승인/반려 버튼 */
.actions {
  display: flex;
  justify-content: center;
  gap: 10px;
}

.btn.approve {
  background-color: #2563eb;
}

.btn.reject {
  background-color: #b91c1c;
}

.btn:hover {
  opacity: 0.9;
}
</style>
</head>

<body>
	<main class="wrap">
		<div class="admin-card">
			<h2>불량 승인 요청 목록</h2>
			<div class="top-bar">
				<%@ include file="/WEB-INF/views/includes/adminTabs.jsp"%>
				<div class="filter-buttons">
					<a href="${cxt}/admin/approval?status=ALL&page=1"
						class="${status eq 'ALL' ? 'active' : ''}">전체</a> <a
						href="${cxt}/admin/approval?status=PENDING&page=1"
						class="${status eq 'PENDING' ? 'active' : ''}">대기중</a> <a
						href="${cxt}/admin/approval?status=APPROVED&page=1"
						class="${status eq 'APPROVED' ? 'active' : ''}">승인됨</a> <a
						href="${cxt}/admin/approval?status=REJECTED&page=1"
						class="${status eq 'REJECTED' ? 'active' : ''}">반려됨</a>
				</div>
			</div>

			<table class="admin-table">
				<thead>
					<tr>
						<th>요청 ID</th>
						<th>불량 유형</th>
						<th>요청자</th>
						<th>승인 상태</th>
						<th>요청일</th>
						<th>비고</th>
						<th>처리</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="r" items="${requests}">
						<tr>
							<td>${r.defectId}</td>
							<td>${r.defectType}</td>
							<td>${r.requesterName}</td>
							<td><span class="status ${r.approvalStatus}">${r.approvalStatus}</span></td>
							<td><fmt:formatDate value="${r.createdAt}"
									pattern="yyyy-MM-dd HH:mm" /></td>
							<td>${r.remark}</td>
							<td class="actions"><c:if
									test="${r.approvalStatus eq 'PENDING'}">
									<form method="post" action="${cxt}/admin/approval/approve"
										style="display: inline;"
										onsubmit="event.preventDefault(); addRemarkAndSubmit(this);">
										<input type="hidden" name="defectId" value="${r.defectId}" />
										<button type="submit" class="btn approve">승인</button>
									</form>
									<form method="post" action="${cxt}/admin/approval/reject"
										style="display: inline;"
										onsubmit="event.preventDefault(); addRemarkAndSubmit(this);">
										<input type="hidden" name="defectId" value="${r.defectId}" />
										<button type="submit" class="btn reject">반려</button>
									</form>
								</c:if> <c:if test="${r.approvalStatus ne 'PENDING'}">-</c:if></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>

			<!-- ✅ approval_list.jsp 공통 페이징 정리 완료 -->
			<div class="pagination">
			  <!-- 맨 앞으로 (≪) / 이전 (<) -->
			  <c:if test="${page > 1}">
			    <a href="${cxt}/admin/approval?status=${status}&page=1">≪</a>
			    <a href="${cxt}/admin/approval?status=${status}&page=${page - 1}">‹</a>
			  </c:if>
			  <c:if test="${page <= 1}">
			    <span class="disabled">≪</span>
			    <span class="disabled">‹</span>
			  </c:if>
			  <!-- 페이지 번호 -->
			  <c:forEach var="i" begin="${startPage}" end="${endPage}">
			    <a href="${cxt}/admin/approval?status=${status}&page=${i}"
			       class="${page == i ? 'active' : ''}">
			      ${i}
			    </a>
			  </c:forEach>
			  <!-- 다음 (>) / 맨 뒤로 (≫) -->
			  <c:if test="${page < totalPage}">
			    <a href="${cxt}/admin/approval?status=${status}&page=${page + 1}">›</a>
			    <a href="${cxt}/admin/approval?status=${status}&page=${totalPage}">≫</a>
			  </c:if>
			  <c:if test="${page >= totalPage}">
			    <span class="disabled">›</span>
			    <span class="disabled">≫</span>
			  </c:if>
			</div>
		</div>
	</main>
	<script>
		function addRemarkAndSubmit(form) {
			const actionType = form.action.includes('approve') ? '승인 사유를 입력하세요:'
					: '반려 사유를 입력하세요:';
			const remark = prompt(actionType);
			if (remark === null)
				return;
			let input = document.createElement('input');
			input.type = 'hidden';
			input.name = 'remark';
			input.value = remark;
			form.appendChild(input);
			form.submit();
		}
	</script>
</body>
</html>
