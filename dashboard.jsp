<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>대시보드</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
html, body { margin: 0; padding: 0; }
body {
	background-color: #0a0f1a;
	color: #fff;
	font-family: Arial, sans-serif;
}
.wrap { max-width: 1200px; margin: 24px auto; padding: 0 12px; }
.cards {
	display: grid;
	grid-template-columns: repeat(3, 1fr);
	gap: 12px;
	margin-bottom: 16px;
}
.card {
	border: 1px solid #1f2937;
	border-radius: 10px;
	padding: 16px;
	background-color: #111827;
	color: #fff;
}
.big { font-size: 28px; font-weight: 700; }
.grid {
	display: grid;
	grid-template-columns: repeat(2, 1fr);
	gap: 16px;
}
.panel {
	border: 1px solid #1f2937;
	border-radius: 10px;
	padding: 12px;
	background: #111827;
	height: 320px;
	min-height: 320px;
	position: relative;
	overflow: hidden;
	color: #fff;
}
.panel h3 { margin: 0 0 8px 0; font-size: 16px; }
.panel canvas {
	display: block !important;
	width: 100% !important;
	height: calc(100% - 28px) !important;
}
@media (max-width: 900px) {
	.grid { grid-template-columns: 1fr; }
	.cards { grid-template-columns: 1fr; }
}
</style>
</head>
<body>

<%@ include file="/WEB-INF/views/includes/header.jsp"%>

<main class="wrap">
	<h2>대시보드</h2>

	<!-- 상단 요약 카드 -->
	<div class="cards">
		<div class="card">
			<div>오늘 생산량</div>
			<div class="big">${summary.goodQty}</div>
		</div>
		<div class="card">
			<div>오늘 불량</div>
			<div class="big">${summary.defectQty}</div>
		</div>
		<div class="card">
			<div>불량률</div>
			<div class="big">${defectRate}%</div>
		</div>
	</div>

	<div class="grid">
		<div class="panel">
			<h3>최근 7일 생산량</h3>
			<canvas id="chart7"></canvas>
		</div>
		<div class="panel">
			<h3>품목별 목표 & 실적</h3>
			<canvas id="chartMonth"></canvas>
		</div>
		<div class="panel">
			<h3>불량별 현황</h3>
			<canvas id="chartDefectPie"></canvas>
		</div>
		<div class="panel">
			<h3>재고 현황</h3>
			<canvas id="chartInventory"></canvas>
		</div>
		<div class="panel">
			<h3>설비별 가동률</h3>
			<canvas id="chartOEE"></canvas>
		</div>
		<div class="panel">
			<h3>승인 요청 상태</h3>
			<canvas id="chartApproval"></canvas>
		</div>
	</div>
</main>

<script>
// 공통 Chart.js 옵션
Chart.defaults.color = '#e0e0e0';
const commonOpts = {
	responsive: true,
	maintainAspectRatio: false,
	plugins: {
		legend: { position: 'top', labels: { color: '#e0e0e0' } },
		tooltip: { mode: 'index', intersect: false }
	},
	scales: {
		y: { beginAtZero: true, ticks: { precision: 0, color: '#b0b0b0' },
		     grid: { color: 'rgba(255,255,255,0.1)' } },
		x: { ticks: { color: '#b0b0b0' },
		     grid: { color: 'rgba(255,255,255,0.1)' } }
	}
};

// ===== 불량별 현황 =====
const defectLabels = [
	<c:forEach var="item" items="${defSummary}" varStatus="s">
		'${item.label}'<c:if test="${!s.last}">,</c:if>
	</c:forEach>
];
const defectCounts = [
	<c:forEach var="item" items="${defSummary}" varStatus="s">
		${item.value}<c:if test="${!s.last}">,</c:if>
	</c:forEach>
];
new Chart(document.getElementById('chartDefectPie'), {
	type: 'doughnut',
	data: {
		labels: defectLabels,
		datasets: [{
			label: '건수',
			data: defectCounts,
			backgroundColor: ['#60a5fa','#34d399','#fbbf24','#f87171','#a78bfa'],
			borderColor: '#0a0f1a',
			borderWidth: 2
		}]
	},
	options: {
		responsive: true,
		maintainAspectRatio: false,
		plugins: { legend: { position: 'right', labels: { color: '#e0e0e0' } } }
	}
});

// ===== 최근 7일 생산량 =====
const weekLabels = [
	<c:forEach var="w" items="${weeklyProd}" varStatus="s">
		'${w.label}'<c:if test="${!s.last}">,</c:if>
	</c:forEach>
];
const weekGood = [
	<c:forEach var="w" items="${weeklyProd}" varStatus="s">
		${w.value}<c:if test="${!s.last}">,</c:if>
	</c:forEach>
];
new Chart(document.getElementById('chart7'), {
	type: 'line',
	data: {
		labels: weekLabels,
		datasets: [
			{ label: '양품', data: weekGood, borderColor: '#34d399', fill: false }
		]
	},
	options: commonOpts
});

// ===== 이번달 목표 vs 실적 =====
const monthLabels = [
	<c:forEach var="m" items="${monthPerf}" varStatus="s">
		'${m.label}'<c:if test="${!s.last}">,</c:if>
	</c:forEach>
];
const monthTarget = [
	<c:forEach var="m" items="${monthPerf}" varStatus="s">
		${m.targetQty}<c:if test="${!s.last}">,</c:if>
	</c:forEach>
];
const monthActual = [
	<c:forEach var="m" items="${monthPerf}" varStatus="s">
		${m.resultQty}<c:if test="${!s.last}">,</c:if>
	</c:forEach>
];
new Chart(document.getElementById('chartMonth'), {
	data: {
		labels: monthLabels,
		datasets: [
			{
				type: 'line',
				label: '실적',
				data: monthActual,
				borderColor: '#ef4444',
				backgroundColor: '#ef4444',
				fill: false,
				tension: 0.3,
				order: 1
			},
			{
				type: 'bar',
				label: '목표',
				data: monthTarget,
				backgroundColor: '#60a5fa',
				order: 2
			}
		]
	},
	options: commonOpts
});

// ===== 재고 현황 =====
const invLabels = [
	<c:forEach var="i" items="${inventoryList}" varStatus="s">
		'${i.label}'<c:if test="${!s.last}">,</c:if>
	</c:forEach>
];
const invCounts = [
	<c:forEach var="i" items="${inventoryList}" varStatus="s">
		${i.value}<c:if test="${!s.last}">,</c:if>
	</c:forEach>
];
new Chart(document.getElementById('chartInventory'), {
	type: 'bar',
	data: {
		labels: invLabels,
		datasets: [{
			label: '재고 수량',
			data: invCounts,
			backgroundColor: '#fbbf24'
		}]
	},
	options: commonOpts
});

// ===== 설비별 가동률 =====
new Chart(document.getElementById('chartOEE'), {
	type: 'bar',
	data: {
		labels: [<c:forEach var="e" items="${equipOEE}" varStatus="s">'${e.label}'<c:if test="${!s.last}">,</c:if></c:forEach>],
		datasets: [{
			label: '가동률(%)',
			data: [<c:forEach var="e" items="${equipOEE}" varStatus="s">${e.value}<c:if test="${!s.last}">,</c:if></c:forEach>],
			backgroundColor: '#fbbf24'
		}]
	},
	options: commonOpts
});

// ===== 승인 요청 상태 =====
new Chart(document.getElementById('chartApproval'), {
	type: 'pie',
	data: {
		labels: [<c:forEach var="a" items="${approvalStat}" varStatus="s">'${a.label}'<c:if test="${!s.last}">,</c:if></c:forEach>],
		datasets: [{
			data: [<c:forEach var="a" items="${approvalStat}" varStatus="s">${a.value}<c:if test="${!s.last}">,</c:if></c:forEach>],
			backgroundColor: ['#fbbf24','#34d399','#f87171']
		}]
	},
	options: {
		responsive: true,
		maintainAspectRatio: false,
		plugins: { legend: { position: 'right', labels: { color: '#e0e0e0' } } }
	}
});
</script>
</body>
</html>
