<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>


<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>사용자 목록</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common.css">
<style>
.admin-card {
	background: var(--card);
	padding: 30px 40px;
	border-radius: 12px;
	box-shadow: 0 0 15px rgba(0, 0, 0, 0.5);
	max-width: 1200px;
	margin: 60px auto;
	color: var(--text);
}

/* ===== 제목 ===== */
h2 {
	color: var(--primary);
	margin-bottom: 24px;
	border-bottom: 2px solid var(--primary);
	padding-bottom: 6px;
	text-align: left;
	font-weight: 600;
	letter-spacing: 0.5px;
	font-size: 20px;
}

/* ===== 테이블 ===== */
table {
	width: 100%;
	border-collapse: collapse;
	table-layout: fixed;
	text-align: center;
}

th, td {
	padding: 14px 10px;
	border-bottom: 1px solid var(--line);
	vertical-align: middle;
	overflow-wrap: break-word;
}

th {
	background-color: #1f2937;
	color: var(--primary);
	font-weight: bold;
	font-size: 15px;
}

/* ===== 상태 표시 ===== */
.status {
	font-weight: bold;
	letter-spacing: 0.3px;
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

/* ===== 버튼 ===== */
/* .btn { */
/*   padding: 8px 16px; */
/*   border-radius: 6px; */
/*   border: none; */
/*   cursor: pointer; */
/*   font-weight: 600; */
/*   font-size: 14px; */
/*   transition: all 0.2s ease; */
/* } */

/* .btn.approve { */
/*   background-color: #2563eb; */
/*   color: #fff; */
/* } */
/* .btn.approve:hover { */
/*   background-color: #1e40af; */
/* } */

/* .btn.reject { */
/*   background-color: #b91c1c; */
/*   color: #fff; */
/* } */
/* .btn.reject:hover { */
/*   background-color: #991b1b; */
/* } */

/* ===== 처리 버튼 영역 ===== */
.actions {
	display: flex;
	justify-content: center;
	gap: 10px;
}
</style>
</head>
<body>
<main class="wrap">
  
  <div class="admin-card">
    <div class="admin-header">
      <%@ include file="/WEB-INF/views/includes/adminTabs.jsp" %>
    </div>

    <table class="admin-table">
      <thead>
        <tr>
          <th>ID</th>
          <th>유형</th>
          <th>요청자</th>
          <th>상태</th>
          <th>요청일</th>
          <th>비고</th>
          <th>처리</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="r" items="${requests}">
          <tr>
            <td>${r.requestId}</td>
            <td>${r.requestType}</td>
            <td>${r.requesterName}</td>
            <td>
              <span class="status ${r.status}">
                ${r.status}
              </span>
            </td>
            <td>
              <fmt:formatDate value="${r.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
            </td>
            <td>${r.remark}</td>
            <td class="actions">
              <button class="btn-reset approve" onclick="approve(${r.requestId})">승인</button>
              <button class="btn-reset reject" onclick="reject(${r.requestId})">반려</button>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
</main>



<script>
function approve(id) {
  const remark = prompt("승인 코멘트를 입력하세요:");
  updateStatus(id, "APPROVED", remark);
}
function reject(id) {
  const remark = prompt("반려 사유를 입력하세요:");
  updateStatus(id, "REJECTED", remark);
}
function updateStatus(id, status, remark) {
  fetch("${pageContext.request.contextPath}/admin/approval/updateStatus", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({ requestId: id, status, remark })
  })
  .then(res => res.text())
  .then(result => {
    if (result === "ok") location.reload();
    else alert("처리 실패: " + result);
  })
  .catch(err => alert("에러: " + err.message));
}
</script>
</body>
</html>
