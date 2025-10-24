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

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">

<style>
:root {
  /* 버튼 공통 */
  --primary:#111827; --primary-hover:#0d1320;
  --btn-txt:#111827; --btn-txt-inv:#fff;
  --hover:#f8fafc;
  /* 헤더 전용 */
  --header-h:56px;
  --text:#fff;
  --accent:#f59e0b;
  --accent-hover:#d97706;
  --banner:#2563eb;
}

/* 기본 버튼 */
.btn{ color:var(--btn-txt); transition:all .15s; }
.btn:hover{ background:var(--hover); color:var(--btn-txt); }

/* 프라이머리 */
.btn-primary{ background:var(--primary); color:var(--btn-txt-inv); border-color:var(--primary); }
.btn-primary:hover{ background:var(--primary-hover); color:var(--btn-txt-inv); border-color:var(--primary-hover); }

/* 위험/삭제 */
.btn-danger{ background:#fff; color:#b91c1c; border-color:#fecaca; }
.btn-danger:hover{ background:#fff; color:#b91c1c; border-color:#fca5a5; }

/* 상단 배너 */
.top-banner{ background:var(--banner); color:#fff; text-align:center; padding:8px 12px; font-size:14px }
.top-banner a{ color:#fff; text-decoration:underline; font-weight:700 }

/* ============================
    헤더(폰트/렌더링/크기 잠금)
    ============================ */
.main-header{
  display:flex; align-items:center; justify-content:space-between;
  height:var(--header-h); background:#0f1720; color:var(--text); padding:0 16px;
  position:relative; z-index:20;

  /* ▼ 외부 CSS 영향 차단 */
  isolation:isolate; contain:layout style paint;

  /* ▼ 폰트/렌더링 고정 (페이지 전역과 무관) */
  font-family:system-ui,-apple-system,'Segoe UI',Roboto,'Noto Sans KR','Apple SD Gothic Neo',Arial,sans-serif;
  -webkit-font-smoothing:antialiased;
  -moz-osx-font-smoothing:grayscale;
  text-rendering:optimizeLegibility;
  font-kerning:normal;
  letter-spacing:0;
  line-height:1; /* 줄간격 고정 */
}

.logo a{
  color:#fff; text-decoration:none; font-weight:800;
  font-size:18px; line-height:1;
  display:inline-flex; align-items:center; height:40px; /* 시각적 기준 라인 */
}

/* 네비 */
.nav-menu{
  display:flex; gap:12px; align-items:center;
  flex:1; justify-content:flex-start; margin-left:20px;
}
.nav-menu a{
  /* 높이/정렬/폰트 고정 */
  display:inline-flex; align-items:center; justify-content:center;
  height:36px; padding:0 10px;
  border-radius:6px; font-size:14px; font-weight:600; line-height:1;
  color:#fff; text-decoration:none; white-space:nowrap;
  transition:background .15s, color .15s, border-color .15s;
}
/* 어두운 헤더용 호버/활성 */
.nav-menu a:hover{ background:rgba(255,255,255,.12); color:#fff; }
.nav-menu a.active{ background:rgba(255,255,255,.20); color:#fff; font-weight:700; }

.user-side{ display:flex; align-items:center; gap:12px; }
.user-label{ opacity:.95; font-size:14px; line-height:1; white-space:nowrap; }
.user-label .role{ opacity:.8; }

.chip{
  display:inline-flex; align-items:center; justify-content:center;
  height:32px; padding:0 10px; border-radius:999px; background:var(--accent);
  color:#111827; font-weight:700; font-size:12px; text-decoration:none;
  transition:background .15s; white-space:nowrap; line-height:1;
}
.chip:hover{ background:var(--accent-hover); color:#111827 }

.link{ color:#fff; text-decoration:none; font-size:14px; white-space:nowrap; line-height:1; }
.link:hover{ text-decoration:underline }

/* 모바일 메뉴 */
.menu-toggle{ display:none; cursor:pointer; font-size:24px; color:#fff; }
.mobile-menu{
  display:none; position:absolute; top:var(--header-h); left:0; width:100%;
  background:#111827; flex-direction:column; padding:16px;
  box-shadow:0 4px 6px rgba(0,0,0,.1); z-index:10;

  /* 폰트/렌더링 고정(헤더와 동일 스택 상속) */
  font: inherit;
}
.mobile-menu a{
  display:block; height:44px; line-height:44px; /* 터치 타깃 고정 */
  padding:0 16px; border-bottom:1px solid rgba(255,255,255,.1);
  color:#fff; text-decoration:none; font-size:14px; white-space:nowrap;
}
.mobile-menu a:last-child{ border-bottom:none; }

/* ✅ 반응형 개선 */
@media (max-width:1024px){
  .nav-menu{ display:none; }
  .user-side{ display:none; } /* ★ user-side 숨김 */
  .menu-toggle{ display:block; }
  .main-header{ justify-content:space-between; } /* ★ 모바일에서 정렬 맞추기 */
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
   class="${fn:startsWith(uri, cxt.concat('/quality/inspection')) ? 'active' : ''}">
   품질 관리
</a>

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
   class="${fn:startsWith(uri, cxt.concat('/quality/inspection')) ? 'active' : ''}">
   품질 관리
</a>

  <a href="${cxt}/inventory/in/new">재고 관리</a>
  <a href="${cxt}/board/list" class="${isBoard ? 'active' : ''}">게시판</a>
  <c:if test="${user != null && roleRaw != null && roleRaw.toUpperCase() == 'ADMIN'}">
    <a href="${cxt}/master/code">기준 관리</a>
    <a href="${cxt}/admin/approval">승인 관리</a>
  </c:if>
</nav>

<script>
function toggleMenu(){
  const mobileMenu = document.querySelector('.mobile-menu');
  mobileMenu.style.display = mobileMenu.style.display === 'flex' ? 'none' : 'flex';
}

window.addEventListener('resize', () => {
  const mobileMenu = document.querySelector('.mobile-menu');
  if (window.innerWidth > 1024) mobileMenu.style.display = 'none';
});
</script>