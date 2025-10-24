<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<c:set var="cxt" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>관리자 탭</title>
<style>
.admin-tabs {
	display: flex;
	align-items: center;
	gap: 32px;
	padding: 16px 24px;
	background-color: #0f1626;
	border-bottom: 1px solid #1f2b45;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.25);
	border-radius: 8px 8px 0 0;
}

.admin-tabs a {
	position: relative;
	color: #a7b4d4;
	font-weight: 600;
	font-size: 15px;
	text-decoration: none;
	padding: 10px 6px;
	transition: color 0.2s ease-in-out, border-bottom 0.2s ease-in-out;
}

.admin-tabs a:hover {
	color: #ffffff;
}

/* 현재 활성 탭 강조 */
/* .admin-tabs a.active-tab { */
/* 	color: #ffb74d !important; */
/* 	border-bottom: 3px solid #ffb74d; */
/* } */

</style>
</head>

<body>
	<div class="admin-tabs">
		<a href="${cxt}/admin/approval"
			class="${fn:contains(pageContext.request.requestURI, '/admin/approval') ? 'active-tab' : ''}">
			승인관리
		</a>

		<a href="${cxt}/admin/users"
			class="${fn:contains(pageContext.request.requestURI, '/admin/users') ? 'active-tab' : ''}">
			사용자관리
		</a>
	</div>
</body>
</html>
