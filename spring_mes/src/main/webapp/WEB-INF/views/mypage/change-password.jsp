<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
  <title>비밀번호 변경</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
  <style>
    .password-page {
      display: flex;
      align-items: center;
      justify-content: center;
      height: 100vh;
    }
    .password-box {
      background: var(--card);
      border: 1px solid var(--line);
      border-radius: 12px;
      padding: 40px 50px;
      width: 420px;
      box-shadow: 0 4px 20px rgba(0,0,0,0.3);
      text-align: center;
    }
    .password-box h2 {
      margin-bottom: 25px;
      color: var(--primary);
    }
    .password-box input {
      width: 100%;
      padding: 12px;
      margin-bottom: 18px;
      border: 1px solid var(--line);
      border-radius: 6px;
      background-color: #1f2937;
      color: var(--text);
    }
    .password-box input:focus {
      outline: none;
      border-color: var(--primary);
    }
    .btn-primary {
      width: 100%;
      padding: 12px;
      border-radius: 6px;
      background-color: var(--primary);
      color: #fff;
      border: none;
      cursor: pointer;
      font-weight: bold;
      transition: 0.2s;
    }
    .btn-primary:hover {
      background-color: var(--primary-hover);
    }
    .error-msg {
      color: var(--danger);
      margin-bottom: 12px;
    }
  </style>
</head>

<body>
  <div class="password-page">
    <div class="password-box">
      <h2>비밀번호 변경</h2>

      <c:if test="${not empty error}">
        <p class="error-msg">${error}</p>
      </c:if>

     <form method="post"
                action="${pageContext.request.contextPath}/password/reset">
                <input type="hidden" name="loginId" value="${loginId}"> <input
                    type="hidden" name="token" value="${token}"> <input
                    type="password" name="password" placeholder="새 비밀번호" required>
                <input type="password" name="password2" placeholder="비밀번호 확인"
                    required>
                <button type="submit" class="btn-primary">변경하기</button>
            </form>
    </div>
  </div>

  <c:if test="${not empty msg}">
    <div id="flash-msg">${msg}</div>
  </c:if>

  <script>
    const msg = document.getElementById("flash-msg");
    if (msg) {
      msg.style.position = "fixed";
      msg.style.top = "50%";
      msg.style.left = "50%";
      msg.style.transform = "translate(-50%, -50%)";
      msg.style.background = "var(--primary)";
      msg.style.color = "#fff";
      msg.style.padding = "15px 25px";
      msg.style.borderRadius = "8px";
      msg.style.boxShadow = "0 0 15px rgba(0,0,0,0.3)";
      msg.style.zIndex = "9999";
      msg.style.fontWeight = "bold";
      setTimeout(() => {
        msg.style.transition = "opacity 0.8s ease-out";
        msg.style.opacity = "0";
      }, 2500);
      setTimeout(() => msg.remove(), 3500);
    }
  </script>
</body>
</html>
