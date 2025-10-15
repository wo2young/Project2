<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>MES System - 로그인</title>

  <style>
    :root {
      --bg: #0a0f1a;
      --card: #111827;
      --line: #1f2b45;
      --line2: #4b5563;
      --text: #e6ebff;
      --muted: #a7b0c5;
      --input-bg: #1a202c;
      --primary: #f59e0b;
      --primary-hover: #d97706;
      --radius: 12px;
      --shadow: 0 6px 18px rgba(0,0,0,.4);
    }

    html, body {
      margin: 0;
      padding: 0;
      height: 100%;
      background: var(--bg);
      color: var(--text);
      font-family: Segoe UI, Pretendard, 'Noto Sans KR', Arial, sans-serif;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .card {
      width: min(400px, 92vw);
      background: var(--card);
      border: 1px solid var(--line);
      border-radius: var(--radius);
      box-shadow: var(--shadow);
      padding: 32px 24px;
    }

    .brand {
      text-align: center;
      font-size: 28px;
      font-weight: 700;
      color: var(--primary);
      margin-bottom: 6px;
    }

    .subtitle {
      text-align: center;
      color: var(--muted);
      font-size: 14px;
      margin-bottom: 24px;
    }

    .error {
      background: #2d1b1b;
      border: 1px solid #b91c1c;
      color: #fca5a5;
      padding: 10px 12px;
      border-radius: 8px;
      font-size: 13px;
      text-align: center;
      margin-bottom: 14px;
    }

    .field { margin: 16px 0; }

    .label {
      display: block;
      font-weight: 600;
      font-size: 14px;
      margin-bottom: 8px;
    }

    .input {
      width: 100%;
      height: 44px;
      border-radius: 8px;
      border: 1px solid var(--line2);
      background: var(--input-bg);
      padding: 0 12px;
      font-size: 14px;
      color: #e6ebff !important;
      -webkit-text-fill-color: #e6ebff !important;
      caret-color: #e6ebff !important;
      outline: none;
      box-sizing: border-box;
    }

    .input:focus {
      border-color: var(--primary);
    }

    .btn {
      width: 100%;
      height: 46px;
      border: none;
      border-radius: 8px;
      background: var(--primary);
      color: #fff;
      font-size: 15px;
      font-weight: 600;
      cursor: pointer;
      transition: background .2s;
      margin-top: 12px;
    }

    .btn:hover {
      background: var(--primary-hover);
    }

    .helper {
      text-align: center;
      color: var(--muted);
      font-size: 12px;
      margin-top: 16px;
      line-height: 1.5;
    }
  </style>
</head>

<body>
  <main class="card">
    <h1 class="brand">MES System</h1>
    <p class="subtitle">음료수 공장 관리 시스템</p>

    <!-- ✅ 에러 메시지 (Controller에서 model.addAttribute("error", "...") 로 전달됨) -->
    <c:if test="${not empty error}">
      <div class="error">${error}</div>
    </c:if>

    <!-- ✅ 로그인 폼 -->
    <form method="post" action="${pageContext.request.contextPath}/login" accept-charset="UTF-8">
      <div class="field">
        <label class="label" for="loginId">사용자 ID</label>
        <input class="input" id="loginId" name="loginId" type="text"
               autocomplete="username" placeholder="아이디를 입력하세요" required />
      </div>

      <div class="field">
        <label class="label" for="password">비밀번호</label>
        <input class="input" id="password" name="password" type="password"
               autocomplete="current-password" placeholder="비밀번호 또는 리셋코드를 입력하세요" required />
      </div>

      <button class="btn" type="submit">로그인</button>

      <!-- ✅ 안내 문구 / 링크 -->
      <p class="helper">
        비밀번호 대신 <strong>리셋코드</strong>로도 로그인할 수 있습니다.<br>
        <a href="${pageContext.request.contextPath}/password/reset"
           style="color: var(--primary); text-decoration: none; font-weight: 600;">
           비밀번호를 잊으셨나요?
        </a>
      </p>
    </form>
  </main>
</body>
</html>
