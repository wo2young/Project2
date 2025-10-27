<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:set var="cxt" value="${pageContext.request.contextPath}" />
<c:set var="user" value="${sessionScope.loginUser}" />

<c:choose>
  <c:when test="${not empty user}">
    <c:set var="roleRaw" value="${user.role}" />
  </c:when>
  <c:otherwise>
    <c:set var="roleRaw" value="" />
  </c:otherwise>
</c:choose>

<c:set var="uri" value="${pageContext.request.requestURI != null ? pageContext.request.requestURI : ''}" />
<c:set var="isBoard" value="${fn:startsWith(uri, cxt.concat('/board'))}" />

<!-- ✅ 공통 CSS -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">

<style>
/* ==========================
   ✅ 헤더 전용 스타일만 유지
   ========================== */

/* 상단 배너 */
.top-banner {
  background: var(--primary);
  color: #fff;
  text-align: center;
  padding: 8px 12px;
  font-size: 14px;
}
.top-banner a {
  color: #fff;
  text-decoration: underline;
  font-weight: 700;
}

/* 메인 헤더 영역 */
.main-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 56px;
  background: #0f1720;
  color: var(--text);
  padding: 0 16px;
  position: relative;
  z-index: 20;
  isolation: isolate;
  font-family: 'Pretendard', 'Noto Sans KR', sans-serif;
}

/* 로고 */
.logo a {
  color: #fff;
  text-decoration: none;
  font-weight: 800;
  font-size: 18px;
  display: inline-flex;
  align-items: center;
  height: 40px;
}

/* 네비게이션 메뉴 */
.nav-menu {
  display: flex;
  gap: 12px;
  align-items: center;
  flex: 1;
  justify-content: flex-start;
  margin-left: 20px;
}
.nav-menu a {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  height: 36px;
  padding: 0 10px;
  border-radius: 6px;
  font-size: 14px;
  font-weight: 600;
  color: #fff;
  text-decoration: none;
  transition: background 0.15s, color 0.15s;
}
.nav-menu a:hover {
  background: rgba(255, 255, 255, 0.12);
}
.nav-menu a.active {
  background: rgba(255, 255, 255, 0.2);
  font-weight: 700;
}

/* 사용자 영역 */
.user-side {
  display: flex;
  align-items: center;
  gap: 12px;
}
.user-label {
  opacity: 0.95;
  font-size: 14px;
  white-space: nowrap;
}
.user-label .role {
  opacity: 0.8;
}
.chip {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  height: 32px;
  padding: 0 10px;
  border-radius: 999px;
  background: var(--primary);
  color: #fff;
  font-weight: 700;
  font-size: 12px;
  text-decoration: none;
}
.chip:hover {
  background: var(--primary-hover);
  color: #fff;
}

/* 링크 */
.link {
  color: #fff;
  text-decoration: none;
  font-size: 14px;
}
.link:hover {
  text-decoration: underline;
}

/* 모바일 메뉴 */
.menu-toggle {
  display: none;
  cursor: pointer;
  font-size: 24px;
  color: #fff;
}
.mobile-menu {
  display: none;
  position: absolute;
  top: 56px;
  left: 0;
  width: 100%;
  background: #111827;
  flex-direction: column;
  padding: 16px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  z-index: 10;
}
.mobile-menu a {
  display: block;
  height: 44px;
  line-height: 44px;
  padding: 0 16px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  color: #fff;
  text-decoration: none;
}
.mobile-menu a:last-child {
  border-bottom: none;
}

/* ✅ 반응형 */
@media (max-width: 1024px) {
  .nav-menu { display: none; }
  .user-side { display: none; }
  .menu-toggle { display: block; }
}
</style>

<c:if test="${sessionScope.mustChangePw == true}">
  <div class="top-banner">
    비밀번호 변경이 필요합니다. <a href="${cxt}/mypage">지금 변경하기</a>
  </div>
</c:if>

<header class="main-header">
  <div class="logo"><a href="${cxt}/dashboard">MES 음료</a></div>

  <div class="menu-toggle" onclick="toggleMenu()">☰</div>

  <nav class="nav-menu">
    <a href="${cxt}/dashboard">대시보드</a>
    <a href="${cxt}/target/list">생산 관리</a>
    <a href="${cxt}/order">생산 지시</a>
    <a href="${cxt}/result/new">작업 실적</a>
    <a href="${cxt}/quality/inspection"
       class="${fn:startsWith(uri, cxt.concat('/quality/inspection')) ? 'active' : ''}">품질 관리</a>
    <a href="${cxt}/inventory/in/new">재고 관리</a>
    <a href="${cxt}/board/list" class="${isBoard ? 'active' : ''}">게시판</a>
    <c:if test="${user != null && roleRaw != null && roleRaw.toUpperCase() == 'ADMIN'}">
      <a href="${cxt}/master/code">기준 관리</a>
      <a href="${cxt}/admin/approval">승인 관리</a>
    </c:if>
  </nav>

  <div class="user-side">
    <c:if test="${user != null}">
      <span class="user-label">
        <c:out value="${empty user.name ? user.login_id : user.name}" />
        (<span class="role"><c:out value="${roleRaw}" /></span>)
      </span>
      <a class="chip" href="${cxt}/mypage">마이페이지</a>
      <a class="link" href="${cxt}/logout">로그아웃</a>
    </c:if>
    <c:if test="${user == null}">
      <a class="link" href="${cxt}/login">로그인</a>
    </c:if>
  </div>
</header>

<nav class="mobile-menu">
  <a href="${cxt}/dashboard">대시보드</a>
  <a href="${cxt}/target/list">생산 관리</a>
  <a href="${cxt}/order">생산 지시</a>
  <a href="${cxt}/result/new">작업 실적</a>
  <a href="${cxt}/quality/inspection"
     class="${fn:startsWith(uri, cxt.concat('/quality/inspection')) ? 'active' : ''}">품질 관리</a>
  <a href="${cxt}/inventory/in/new">재고 관리</a>
  <a href="${cxt}/board/list" class="${isBoard ? 'active' : ''}">게시판</a>
  <c:if test="${user != null && roleRaw != null && roleRaw.toUpperCase() == 'ADMIN'}">
    <a href="${cxt}/master/code">기준 관리</a>
    <a href="${cxt}/admin/approval">승인 관리</a>
  </c:if>
</nav>

<script>
function toggleMenu() {
  const mobileMenu = document.querySelector('.mobile-menu');
  mobileMenu.style.display = mobileMenu.style.display === 'flex' ? 'none' : 'flex';
}
window.addEventListener('resize', () => {
  const mobileMenu = document.querySelector('.mobile-menu');
  if (window.innerWidth > 1024) mobileMenu.style.display = 'none';
});
</script>
