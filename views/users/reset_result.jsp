<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>비밀번호 리셋 코드 발급 결과</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">

<style>
body {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  background-color: var(--bg);
  color: var(--text);
  margin: 0;
  font-family: "Pretendard", "Noto Sans KR", sans-serif;
}

.result-box {
  background: var(--card);
  border: 1px solid var(--line);
  border-radius: 12px;
  padding: 40px 60px;
  text-align: center;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.4);
  width: 420px;
}

h2 {
  color: var(--primary);
  margin-bottom: 20px;
  font-size: 22px;
  border-bottom: 1px solid var(--line);
  padding-bottom: 10px;
}

p {
  margin: 10px 0;
  color: var(--text);
  line-height: 1.6;
}

b {
  color: var(--primary);
  font-size: 18px;
}

a {
  display: inline-block;
  margin-top: 25px;
  padding: 10px 20px;
  background-color: var(--primary);
  color: #fff;
  border-radius: 6px;
  text-decoration: none;
  transition: background-color 0.2s;
}

a:hover {
  background-color: var(--primary-hover);
  color: #fff; /* ✅ hover 시 흰 글씨 유지 */
}
</style>
</head>

<body>
  <div class="result-box">
    <h2>리셋 코드 발급 완료</h2>
    <p>사용자: <strong>${target.name}</strong> (${target.login_id})</p>
    <p>유효 시간: 1시간</p>
    <p>리셋 코드: <b>${token}</b></p>
    <%-- <p>${email}로 발송되었습니다.</p> --%>

    <a href="${pageContext.request.contextPath}/users">목록으로 돌아가기</a>
  </div>
</body>
</html>
