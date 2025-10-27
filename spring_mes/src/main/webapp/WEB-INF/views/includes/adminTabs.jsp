<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<c:set var="cxt" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>관리자 탭</title>

<!-- ✅ 공통 CSS -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">

<style>
/* ===============================
   ✅ 관리자 전용 탭 스타일 (공통기반)
   =============================== */

.admin-tabs {
	display: flex;
	align-items: center;
	gap: 32px;
	padding: 16px 24px;
	border-bottom: 1px solid var(--line);
	background: var(--card);
	border-radius: 8px 8px 0 0;
}

/* 기본 탭 링크 */
.admin-tabs a {
	position: relative;
	color: var(--muted);
	font-weight: 600;
	font-size: 15px;
	text-decoration: none;
	padding: 10px 6px;
	transition: color 0.2s ease-in-out, border-bottom 0.2s ease-in-out;
}

/* hover 시 강조 */
.admin-tabs a:hover {
	color: var(--text);
}

/* ✅ 활성 탭 강조 (공통 포인트 컬러 사용) */
.admin-tabs a.active-tab {
	color: var(--primary);
	border-bottom: 3px solid var(--primary);
}
</style>
</head>

<body>
	<div class="admin-tabs">
		<a href="${cxt}/admin/approval"
   			class="${fn:contains(pageContext.request.requestURI, '/admin/approval') ? 'active-tab' : ''}">
		   	승인관리
		</a>
		
		<a href="${cxt}/admin/users"
		   class="${fn:contains(pageContext.request.requestURI, '/admin/users')
		        or fn:contains(pageContext.request.requestURI, 'admin_list.jsp') ? 'active-tab' : ''}">
		   사용자관리
		</a>
	</div>
</body>
</html>
