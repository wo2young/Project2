<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../includes/header.jsp"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>사용자 목록</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/common.css">

<style>
/* ===== 사용자 목록 전용 보강 스타일 ===== */
.table-container {
	background: var(- -card);
	padding: 30px 40px;
	border-radius: 12px;
	box-shadow: 0 0 15px rgba(0, 0, 0, 0.5);
	max-width: 1200px;
	margin: 60px auto;
	color: var(- -text);
}

h2 {
	color: var(- -primary);
	margin-bottom: 24px;
	border-bottom: 2px solid var(- -primary);
	padding-bottom: 6px;
	text-align: left;
	font-weight: 600;
	letter-spacing: 0.5px;
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
	border-bottom: 1px solid var(- -line);
	vertical-align: middle;
	overflow-wrap: break-word;
}

th {
	background-color: #1f2937;
	color: var(- -primary);
	font-weight: bold;
	font-size: 15px;
}

/* ===== 버튼 ===== */
.btn {
	padding: 8px 14px;
	border-radius: 6px;
	border: none;
	cursor: pointer;
	color: #fff;
	font-size: 14px;
	font-weight: 500;
	transition: background-color 0.2s;
}

.btn-primary {
	background-color: var(- -primary);
}

.btn-primary:hover {
	background-color: var(- -primary-hover);
}

.btn-danger {
	background-color: var(- -danger);
}

.btn-danger:hover {
	background-color: var(- -danger-hover);
	color: #fff; /* ✅ hover 시에도 흰색 유지 */
}

/* ===== 페이징 ===== */
.pagination {
	margin-top: 25px;
	text-align: center;
}

.pagination a {
	color: var(- -text);
	text-decoration: none;
	padding: 8px 12px;
	border-radius: 6px;
	border: 1px solid var(- -line);
	margin: 0 3px;
	display: inline-block;
	min-width: 36px;
	transition: background-color 0.2s, color 0.2s;
}

.pagination a.active {
	background-color: var(- -primary);
	color: #fff;
	border: 1px solid var(- -primary);
}

.pagination a:hover {
	background-color: var(- -primary-hover);
	color: #fff;
}

/* ====== 모달 전체 ====== */
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

/* ====== 모달 박스 ====== */
.modal-box {
	background: var(- -card);
	color: var(- -text);
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
	color: var(- -primary);
}

/* 텍스트 */
.modal-box h2 {
	color: var(- -primary);
	margin-bottom: 15px;
	font-size: 22px;
}

.modal-box p {
	margin: 8px 0;
	line-height: 1.6;
}

.modal-box b {
	color: var(- -primary);
	font-size: 18px;
}
</style>
</head>

<body>
	<div class="table-container">
		<h2>사용자 목록</h2>

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
						<td>${u.user_id}</td>
						<td>${u.login_id}</td>
						<td>${u.name}</td>
						<td>${u.user_role}</td>
						<td>${u.created_at}</td>
						<td>
							<form action="${pageContext.request.contextPath}/users/reset-pw"
								method="post" style="display: inline;">
								<input type="hidden" name="id" value="${u.user_id}">
								<button type="submit" class="btn btn-danger">비밀번호 리셋</button>
							</form>
						</td>
						<td><a
							href="${pageContext.request.contextPath}/users/edit?id=${u.user_id}"
							class="btn btn-primary">수정</a></td>
					</tr>
				</c:forEach>
			</tbody>
		</table>

		<!-- ✅ 모달 -->
		<div class="modal-overlay" id="resetModal">
			<div class="modal-box">
				<span class="modal-close" id="modalClose">&times;</span>
				<h2>리셋 코드 발급 완료</h2>
				<p>
					사용자: <b id="modalUser"></b>
				</p>
				<p>
					리셋 코드: <b id="modalToken"></b>
				</p>
				<p>유효 시간: 1시간</p>
			</div>
		</div>

		<!-- ✅ 페이징 -->
		<div class="pagination">
			<c:forEach var="i" begin="1" end="${totalPages}">
				<a href="?p=${i}" class="${i == page ? 'active' : ''}">${i}</a>
			</c:forEach>
		</div>
	</div>

<script>
  // ✅ JSP에서 메시지가 있을 때 자동 모달 표시
  <%if (request.getAttribute("token") != null) {%>
  const modal = document.getElementById('resetModal');
  const user = document.getElementById('modalUser');
  const token = document.getElementById('modalToken');

  user.textContent = "<%=((kr.or.human99.dto.UserDTO) request.getAttribute("target")).getName()%>";
  token.textContent = "<%=request.getAttribute("token")%>";

  modal.classList.add('active');
  setTimeout(() => modal.classList.remove('active'), 3000);

  document.getElementById('modalClose').onclick = () => modal.classList.remove('active');
  <%}%>
</script>
</body>
</html>
