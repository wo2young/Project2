<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>새 사용자 등록</title>
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

input[type="text"], input[type="password"], select {
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
  <h2>새 사용자 등록</h2>

  	<form action="${pageContext.request.contextPath}/admin/users/new" method="post">
	  <div class="form-group">
	    <label for="loginId">로그인 ID</label>
	    <input type="text" name="loginId" id="loginId" required>
	  </div>
	
	  <div class="form-group">
	    <label for="name">이름</label>
	    <input type="text" name="name" id="name" required>
	  </div>
	
	  <div class="form-group">
	    <label for="role">권한</label>
	    <select name="role" id="role">
	      <option value="ADMIN">ADMIN</option>
	      <option value="MANAGER">MANAGER</option>
	      <option value="WORKER">WORKER</option>
	    </select>
	  </div>
	
	  <div class="form-group">
	    <label for="password">비밀번호</label>
	    <input type="password" name="password" id="password" required>
	  </div>
	
	  <div class="btn-area">
	    <button type="submit" class="btn btn-primary">등록</button>
	    <button type="button" class="btn btn-secondary"
	            onclick="window.location.href='${pageContext.request.contextPath}/admin/users'">
	      목록으로
	    </button>
	  </div>
	</form>
  </div>
</body>
</html>
