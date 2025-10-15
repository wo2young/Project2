<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="cxt" value="${pageContext.request.contextPath}" />
<c:set var="u" value="${sessionScope.loginUser}" />

<jsp:include page="/WEB-INF/views/includes/header.jsp" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>마이페이지</title>
<style>
body {
	margin: 0;
	background: #0f1720;
	color: #e5e7eb;
	font-family: system-ui, -apple-system, Segoe UI, Roboto, "Noto Sans KR",
		sans-serif;
}

.wrap {
	max-width: 1100px;
	margin: 28px auto;
	padding: 0 16px;
}

h1 {
	font-size: 28px;
	margin: 12px 0 18px;
}

.grid {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 24px;
}

.card {
	background: #111827;
	border: 1px solid #1f2937;
	border-radius: 16px;
	box-shadow: 0 10px 24px rgba(0, 0, 0, .25);
	padding: 16px 18px;
}

.table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 10px;
}

.table th, .table td {
	padding: 14px;
	border-bottom: 1px dashed #243040;
	text-align: left;
	font-size: 14px;
}

.input {
	width: 100%;
	height: 44px;
	border-radius: 12px;
	border: 1px solid #263244;
	background: #0b1220;
	color: #e5e7eb;
	padding: 0 14px;
	outline: none;
}

.input:focus {
	box-shadow: 0 0 0 4px rgba(99, 102, 241, .25);
	border-color: #818cf8;
}

.btn {
	height: 44px;
	padding: 0 18px;
	border-radius: 12px;
	border: none;
	background: #3b82f6;
	color: #fff;
	font-weight: 700;
	cursor: pointer;
}

.btn:hover {
	background: #2563eb;
}

.error {
	background: #7f1d1d;
	color: #fecaca;
	border: 1px solid #fecaca;
	border-radius: 10px;
	padding: 10px 12px;
	font-size: 13px;
	margin: 8px 0;
}

.ok {
	background: #052e16;
	color: #bbf7d0;
	border: 1px solid #86efac;
	border-radius: 10px;
	padding: 10px 12px;
	font-size: 13px;
	margin: 8px 0;
}

.muted {
	color: #9ca3af;
}
</style>
</head>

<body>
	<div class="wrap">
		<h1>마이페이지</h1>

		<c:if test="${not empty requestScope.msgOk}">
			<div class="ok">${requestScope.msgOk}</div>
		</c:if>
		<c:if test="${not empty requestScope.msgErr}">
			<div class="error">${requestScope.msgErr}</div>
		</c:if>

		<div class="grid">
			<!-- 내 정보 -->
			<div class="card">
				<form method="post" action="${cxt}/mypage/update-info"
					autocomplete="off">
					<table class="table">
						<tr>
							<th>로그인 ID</th>
							<td>${u.loginId}</td>
						</tr>
						<tr>
							<th>이름</th>
							<td><input class="input" type="text" value="${u.name}"
								readonly></td>
						</tr>
						<tr>
							<th>권한</th>
							<td><input class="input" type="text" value="${u.role}"
								readonly></td>
						</tr>
						<tr>
							<th>이메일</th>
							<td><input class="input" name="email" type="email"
								value="${u.email}"></td>
						</tr>
						<tr>
							<th>전화번호</th>
							<td><input class="input" name="phone" type="text"
								value="${u.phone}"></td>
						</tr>
						<tr>
							<th>생년월일</th>
							<td><input class="input" name="birthdate" type="date"
								value="${u.birthdate}"></td>
						</tr>
						<tr>
							<th>우편번호</th>
							<td><input class="input" name="zipcode" type="text"
								value="${u.zipcode}"></td>
						</tr>
						<tr>
							<th>주소</th>
							<td><input class="input" name="address" type="text"
								value="${u.address}"></td>
						</tr>
						<tr>
							<th>상세주소</th>
							<td><input class="input" name="addressDetail" type="text"
								value="${u.addressDetail}"></td>
						</tr>
						<tr>
							<th>생성일</th>
							<td><span class="muted">${u.createdAt}</span></td>
						</tr>
						<tr>
							<th>수정일</th>
							<td><span class="muted">${u.updatedAt}</span></td>
						</tr>
					</table>

					<div style="text-align: center; margin-top: 20px;">
						<button type="submit" class="btn">수정하기</button>
					</div>
				</form>
			</div>

			<!-- 비밀번호 변경 -->
			<div class="card">
				<form method="post" action="${cxt}/mypage/change-password"
					accept-charset="UTF-8" autocomplete="off">
					<c:set var="must"
						value="${sessionScope.mustChangePw == true or sessionScope.FORCE_CHANGE_PASSWORD == true}" />

					<c:if test="${!must}">
						<div style="margin-top: 8px">
							<input class="input" type="password" name="currentPassword"
								placeholder="현재 비밀번호" required />
						</div>
					</c:if>

					<div style="margin-top: 8px">
						<input class="input" type="password" name="newPassword"
							placeholder="새 비밀번호 (8자 이상)" required minlength="8" />
					</div>
					<div style="margin-top: 8px">
						<input class="input" type="password" name="confirmPassword"
							placeholder="새 비밀번호 확인" required minlength="8" />
					</div>

					<div style="margin-top: 14px">
						<button class="btn" type="submit">비밀번호 변경</button>
					</div>
				</form>
			</div>
		</div>
	</div>
</body>
</html>
