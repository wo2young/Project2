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
	font-family: system-ui, -apple-system, Segoe UI, Roboto, "Noto Sans KR", sans-serif;
	font-size: 14px; /* 전체 글자 크기 살짝 축소 */
}

.wrap {
	max-width: 850px; /* 기존 1100px → 850px */
	margin: 24px auto;
	padding: 0 12px;
}

h1 {
	font-size: 24px; /* 기존 28px → 24px */
	margin: 10px 0 16px;
	text-align: center;
}

/* ✅ 기존 grid → flex column 변경 */
.grid {
	display: flex;
	flex-direction: column;
	gap: 28px; /* 위아래 간격 */
}

/* 카드 디자인 동일 유지 */
/* 전체 영역 카드 */
.card {
	background: #111827;
	border: 1px solid #1f2937;
	border-radius: 14px;
	box-shadow: 0 6px 18px rgba(0, 0, 0, 0.25);
	padding: 1px 16px 20px;
}

/* table 조정 */
.table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 6px;
}

.table th, .table td {
	padding: 10px 12px; /* 전체 간격 축소 */
	border-bottom: 1px dashed #243040;
	text-align: left;
	font-size: 13.5px;
}

/* ✅ th 배경색 제거 + 폰트 밝기 통일 */
.table th {
	background: transparent;
	color: #9ca3af; /* 중간 회색 톤 */
	font-weight: 600;
	white-space: nowrap;
	width: 160px;
}

/* input 박스 */
.input {
	width: 100%;
	height: 38px; /* 기존 44px → 38px */
	border-radius: 10px;
	border: 1px solid #263244;
	background: #0b1220;
	color: #e5e7eb;
	padding: 0 12px;
	outline: none;
	font-size: 13.5px;
}
.input:focus {
	box-shadow: 0 0 0 3px rgba(99, 102, 241, .25);
	border-color: #6366f1;
}

/* 버튼 */
.btn {
	height: 38px; /* 버튼도 비율 맞춰서 축소 */
	padding: 0 16px;
	border-radius: 10px;
	border: none;
	background: #3b82f6;
	color: #fff;
	font-weight: 600;
	cursor: pointer;
	font-size: 14px;
	transition: 0.15s;
}
.btn:hover {
	background: #2563eb;
	transform: translateY(-1px);
}

/* 상태 메시지 */
.error, .ok {
	border-radius: 8px;
	padding: 8px 10px;
	font-size: 13px;
	margin: 6px 0;
}
.error {
	background: #7f1d1d;
	color: #fecaca;
	border: 1px solid #fecaca;
}
.ok {
	background: #052e16;
	color: #bbf7d0;
	border: 1px solid #86efac;
}

/* 섹션 간격 줄이기 */
.grid {
	display: flex;
	flex-direction: column;
	gap: 18px; /* 기존 28px → 18px */
}

/* ✅ 주소/상세주소 input은 전체 폭 차지 */
.table td[colspan] .input {
	width: 100%;
}

/* 카드 내부 버튼 정렬 */
form > div:last-child {
	text-align: center;
	margin-top: 16px;
}
</style>
</head>

<body>
	<div class="wrap">
		<c:if test="${not empty requestScope.msgOk}">
			<div class="ok">${requestScope.msgOk}</div>
		</c:if>
		<c:if test="${not empty requestScope.msgErr}">
			<div class="error">${requestScope.msgErr}</div>
		</c:if>

		<div class="grid">
			<!-- ✅ 1️⃣ 내 정보 -->
			<div class="card">
				<h2>내정보</h2>
				<form method="post" action="${cxt}/mypage/update-info"
					autocomplete="off">
					<table class="table">
						<tr>
							<th>로그인 ID</th><td>${u.loginId}</td>
							<th>이름</th><td>${u.name}</td>
						</tr>
						<tr>
							<th>권한</th><td>${u.role}</td>
							<th>이메일</th><td><input class="input" name="email" type="email" value="${u.email}"></td>
						</tr>
						<tr>
							<th>전화번호</th><td><input class="input" name="phone" type="text" value="${u.phone}"></td>
							<th>생년월일</th><td><input class="input" name="birthdate" type="date" value="${u.birthdate}"></td>
						</tr>
						<tr>
							<th colspan="1">우편번호</th><td colspan="2"><input class="input" name="zipcode" type="text" value="${u.zipcode}"></td>
						</tr>
						<tr>
							<th colspan="1">주소</th><td colspan="3"><input class="input" name="address" type="text" value="${u.address}"></td>	
						</tr>
						<tr><th colspan="1">상세주소</th><td colspan="3"><input class="input" name="addressDetail" type="text" value="${u.addressDetail}"></td></tr>
					</table>

					<div style="text-align: center; margin-top: 20px;">
						<button type="submit" class="btn">수정하기</button>
					</div>
				</form>
			</div>

			<!-- ✅ 2️⃣ 비밀번호 변경 -->
			<div class="card">
				<h2>비밀번호 변경</h2>
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

					<div style="margin-top: 14px; text-align: right;">
						<button class="btn" type="submit">비밀번호 변경</button>
					</div>
				</form>
			</div>
		</div>
	</div>
	
<script>
// 페이지 로드 후 실행
window.addEventListener('DOMContentLoaded', () => {
  const msg = document.getElementById('flashMsg');
  if (msg) {
    // 3초 뒤 서서히 사라짐
    setTimeout(() => {
      msg.style.transition = 'opacity 0.6s ease';
      msg.style.opacity = '0';
      setTimeout(() => msg.remove(), 600); // 완전히 사라지면 DOM에서 제거
    }, 3000);
  }
});
</script>
</body>
</html>
