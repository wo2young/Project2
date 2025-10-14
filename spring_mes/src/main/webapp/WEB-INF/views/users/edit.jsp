<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>사용자 정보 수정</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<style>
/* 중앙 카드 스타일 */
.form-container {
  background: var(--card);
  border: 1px solid var(--line);
  border-radius: 12px;
  padding: 40px;
  width: 420px;
  margin: 60px auto;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.4);
  color: var(--text);
}

h2 {
  color: var(--primary);
  text-align: center;
  margin-bottom: 25px;
}

.form-group {
  margin-bottom: 20px;
}

label {
  display: block;
  font-weight: 500;
  margin-bottom: 8px;
  color: #9ca3af;
}

input[type="text"], select {
  width: 100%;
  padding: 10px;
  border-radius: 6px;
  border: 1px solid var(--line);
  background-color: #1f2937;
  color: var(--text);
  font-size: 15px;
}

input:focus, select:focus {
  border-color: var(--primary);
  outline: none;
}

.btn-area {
  display: flex;
  justify-content: space-between;
  margin-top: 30px;
}

.btn {
  padding: 10px 20px;
  border-radius: 6px;
  border: none;
  cursor: pointer;
  font-weight: 500;
  transition: background-color 0.2s;
}

.btn-primary {
  background-color: var(--primary);
  color: #fff;
}

.btn-primary:hover {
  background-color: var(--primary-hover);
  color: #fff;
}

.btn-secondary {
  background-color: #374151;
  color: var(--text);
}

.btn-secondary:hover {
  background-color: #4b5563;
}
</style>
</head>

<body>

  <div class="form-container">
    <h2>사용자 정보 수정</h2>

    <c:if test="${not empty error}">
      <p style="color: var(--danger); text-align: center;">${error}</p>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/users/edit">
      <input type="hidden" name="user_id" value="${u.user_id}">

      <div class="form-group">
        <label>로그인 ID</label>
        <p style="margin:0; color:var(--text);">${u.login_id}</p>
      </div>

      <div class="form-group">
        <label for="name">이름</label>
        <input type="text" name="name" id="name" value="${u.name}">
      </div>

      <div class="form-group">
        <label for="user_role">권한</label>
        <select name="user_role" id="user_role">
          <option value="ADMIN" <c:if test="${u.user_role eq 'ADMIN'}">selected</c:if>>ADMIN</option>
          <option value="MANAGER" <c:if test="${u.user_role eq 'MANAGER'}">selected</c:if>>MANAGER</option>
          <option value="WORKER" <c:if test="${u.user_role eq 'WORKER'}">selected</c:if>>WORKER</option>
        </select>
      </div>

      <div class="btn-area">
        <button type="submit" class="btn btn-primary">저장</button>
        <a href="${pageContext.request.contextPath}/users" class="btn btn-secondary">목록으로</a>
      </div>
    </form>
  </div>

</body>
</html>
