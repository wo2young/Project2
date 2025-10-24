<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="/WEB-INF/views/includes/header.jsp"%>

<c:set var="cxt" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>불량 통계</title>
<style>
  :root {
    --bg:#0b111c; --surface:#0f1626; --surface-2:#0d1423;
    --line:#253150; --line-2:#2b385c; --text:#e6ebff;
    --muted:#9fb0d6; --accent:#f59e0b; --accent-hover:#d48a07;
    --danger:#ef4444;
  }

  html,body{
    margin:0;padding:0;background:var(--bg);color:var(--text);
    font-family:'Noto Sans KR',system-ui,sans-serif;
  }

  .container{
    max-width:1100px;margin:40px auto;padding:24px;
    background:var(--surface);border:1px solid var(--line);
    border-radius:12px;box-shadow:0 0 10px rgba(0,0,0,.4);
    transition: all .3s ease-in-out;
  }

  h2{
    color:var(--accent);border-left:4px solid var(--accent);
    padding-left:10px;margin-bottom:20px;
  }

  /* ✅ 상단 탭 */
  .tab-bar{
    display:flex;gap:8px;margin-bottom:20px;position:relative;
  }
  .tab-btn{
    background:var(--surface-2);color:var(--muted);
    padding:8px 16px;border:none;border-radius:8px;cursor:pointer;
    font-weight:600;transition:all .25s ease;
    transform:translateY(0);
  }
  .tab-btn.active{
    background:var(--accent);color:#fff;
    transform:translateY(-2px);
    box-shadow:0 3px 6px rgba(245,158,11,0.3);
  }
  .tab-btn:hover:not(.active){
    background:var(--line-2);
    transform:translateY(-1px);
  }

  /* ✅ 통계 카드 */
  .stats{
    display:grid;grid-template-columns:repeat(3,1fr);gap:16px;
    margin-bottom:30px;
  }
  .card{
    background:var(--surface-2);border:1px solid var(--line-2);
    border-radius:10px;padding:16px;text-align:center;
    transition:all .25s ease;
  }
  .card:hover{transform:translateY(-3px);box-shadow:0 3px 6px rgba(0,0,0,0.3);}
  .card h3{color:var(--muted);margin-bottom:8px;font-size:15px;}
  .card p{color:var(--accent);font-size:22px;font-weight:700;}

  /* ✅ 차트 영역 */
  .chart-box{
    background:var(--surface-2);padding:20px;border-radius:10px;
    border:1px solid var(--line-2);margin-bottom:20px;
  }
  canvas{width:100%;height:350px;}

</style>
</head>

<body>
<div class="container">
  <!-- ✅ 상단 탭 -->
  <div class="tab-bar">
    <button class="tab-btn" onclick="location.href='${cxt}/quality/inspection'">품질관리</button>
    <button class="tab-btn" onclick="location.href='${cxt}/quality/defect'">불량관리</button>
    <button class="tab-btn active">불량 통계</button>
  </div>

  <!-- ✅ 제목 -->
  <h2>불량 통계 현황</h2>

  <!-- ✅ 통계 요약 -->
  <div class="stats">
    <div class="card">
      <h3>총 양품 수량 (GOOD_QTY)</h3>
      <p>${summary.goodQty}</p>
    </div>
    <div class="card">
      <h3>총 불량 수량 (DEFECT_QTY)</h3>
      <p>${summary.defectQty}</p>
    </div>
    <div class="card">
      <h3>불량률 (%)</h3>
      <p>${summary.defectRate}</p>
    </div>
  </div>

  <!-- ✅ 불량코드별 비율 차트 -->
  <div class="chart-box">
    <h3 style="color:var(--accent);margin-bottom:10px;">불량 코드별 비율</h3>
    <canvas id="defectCodeChart"></canvas>
  </div>

  <!-- ✅ 검사유형별 불량률 차트 -->
  <div class="chart-box">
    <h3 style="color:var(--accent);margin-bottom:10px;">검사유형별 불량률</h3>
    <canvas id="inspectTypeChart"></canvas>
  </div>
</div>

<!-- ✅ Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
  // ✅ 서버에서 전달된 데이터
  const codeLabels = ${codeLabels};      // 불량코드 이름 리스트
  const codeData = ${codeData};          // 불량코드별 수량
  const typeLabels = ${typeLabels};      // 검사유형 이름 리스트
  const typeData = ${typeData};          // 유형별 불량률

  // ✅ 불량코드별 비율 (Pie Chart)
  new Chart(document.getElementById('defectCodeChart'), {
    type: 'pie',
    data: {
      labels: codeLabels,
      datasets: [{
        data: codeData,
        backgroundColor: [
          '#f59e0b','#ef4444','#3b82f6','#10b981','#8b5cf6','#ec4899'
        ]
      }]
    },
    options: {
      plugins: {
        legend: { labels: { color: '#e6ebff' } }
      }
    }
  });

  // ✅ 검사유형별 불량률 (Bar Chart)
  new Chart(document.getElementById('inspectTypeChart'), {
    type: 'bar',
    data: {
      labels: typeLabels,
      datasets: [{
        label: '불량률 (%)',
        data: typeData,
        backgroundColor: '#f59e0b'
      }]
    },
    options: {
      scales: {
        x: { ticks: { color: '#9fb0d6' }, grid: { color: '#253150' } },
        y: { ticks: { color: '#9fb0d6' }, grid: { color: '#253150' } }
      },
      plugins: {
        legend: { labels: { color: '#e6ebff' } }
      }
    }
  });
</script>
</body>
</html>
