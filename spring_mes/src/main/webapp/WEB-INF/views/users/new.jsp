<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head><title>새 사용자 등록</title>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>
</head>
<body>
  <h2>새 사용자 등록</h2>

  <c:if test="${not empty error}">
    <p style="color:red">${error}</p>
  </c:if>

  <form method="post" action="${pageContext.request.contextPath}/users/new">
    <p>로그인 ID: <input type="text" name="login_id" value="${u.login_id}"></p>
    <p>이름: <input type="text" name="name" value="${u.name}"></p>
<%--     <p>이메일: <input type="text" name="email" value="${u.email}"></p> --%>
    <p>권한:
      <select name="user_role">
        <option value="ADMIN">ADMIN</option>
        <option value="MANAGER">MANAGER</option>
        <option value="WORKER">WORKER</option>
      </select>
    </p>
    <p>비밀번호: <input type="password" name="password"></p>

    <button type="submit">등록</button>
    <a href="${pageContext.request.contextPath}/users">목록으로</a>
  </form>
</body>
</html>
