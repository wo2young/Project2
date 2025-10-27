<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
.topbar {
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding: 12px 20px;
	background: #152033; /* ← 기존 #111 대신 다크네이비 */
	color: #fff;
	margin: 0 0 20px;
	border-radius: 6px;
	font-family: Arial, sans-serif;
}

.brand {
	font-weight: 800;
	letter-spacing: .5px
}

.nav {
	display: flex;
	gap: 10px;
	align-items: center
}

.nav a {
	display: inline-flex;
	align-items: center;
	justify-content: center;
	height: 36px;
	padding: 0 12px;
	color: #ddd;
	text-decoration: none;
	border: 1px solid rgba(255, 255, 255, .12);
	border-radius: 6px;
	transition: all .15s;
	font-size: 14px
}

.nav a:hover {
	background: #1f1f1f;
	color: #fff
}

.nav a.active {
	background: #fff;
	color: #111;
	border-color: #fff;
	font-weight: 700
}
</style>
<header class="topbar">
	<div class="brand">기준 관리</div>
	<nav class="nav">
		<a class="${'codes'    == requestScope.activeNav ? 'active':''}"
			href="${pageContext.request.contextPath}/master/code">코드</a>
		<a class="${'products' == requestScope.activeNav ? 'active':''}"
			href="${pageContext.request.contextPath}/master/item">제품</a>
		<a class="${'bom'      == requestScope.activeNav ? 'active':''}"
			href="${pageContext.request.contextPath}/master/bom">BOM</a>
		<a class="${'routing'  == requestScope.activeNav ? 'active':''}"
			href="${pageContext.request.contextPath}/master/routing">공정</a>
		<a class="${'equip'  == requestScope.activeNav ? 'active':''}"
			href="${pageContext.request.contextPath}/master/equip">설비</a>
	</nav>
</header>