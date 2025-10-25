<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
  }
  html,body{margin:0;padding:0;background:var(--bg);color:var(--text);font-family:'Noto Sans KR',system-ui,sans-serif;}
  .container{max-width:1100px;margin:40px auto;padding:32px 40px;background:var(--surface);border:1px solid var(--line);
    border-radius:12px;box-shadow:0 0 15px rgba(0,0,0,.45);}
  h2{color:var(--accent);border-left:4px solid var(--accent);padding-left:10px;margin-bottom:24px;font-size:22px;}
  .tab-bar{display:flex;gap:8px;margin-bottom:25px;}
  .tab-btn{background:var(--surface-2);color:var(--muted);padding:10px 20px;border:none;border-radius:8px;cursor:pointer;font-weight:600;transition:.25s;}
  .tab-btn.active{background:var(--accent);color:#fff;}
  .tab-btn:hover:not(.active){background:var(--line-2);}
  .stats{display:grid;grid-template-columns:repeat(3,1fr);gap:20px;margin-top:25px;}
  .card{background:var(--surface-2);border:1px solid var(--line-2);border-radius:10px;padding:24px 10px;text-align:center;transition:.25s;}
  .card:hover{transform:translateY(-4px);box-shadow:0 3px 8px rgba(0,0,0,0.35);}
  .card h3{color:var(--muted);margin-bottom:8px;font-size:16px;}
  .card p{color:var(--accent);font-size:24px;font-weight:700;}
  .loading{text-align:center;color:var(--muted);font-size:15px;margin-top:15px;}
  table{width:100%;border-collapse:collapse;margin-top:30px;font-size:15px;}
  th,td{border:1px solid var(--line);padding:12px;text-align:center;}
  th{background:var(--surface-2);color:var(--muted);font-weight:600;}
  td{color:var(--text);}
  tr:hover td{background:var(--line-2);}
</style>
</head>

<body>
<div class="container">
  <div class="tab-bar">
    <button class="tab-btn" onclick="location.href='${cxt}/quality/inspection'">품질관리</button>
    <button class="tab-btn" onclick="location.href='${cxt}/quality/defect'">불량관리</button>
    <button class="tab-btn active">불량 통계</button>
  </div>

  <h2 id="title">불량 통계 현황</h2>

  <div style="margin-bottom:16px;">
    <button id="btnPCD" class="tab-btn active">완제품</button>
    <button id="btnSGD" class="tab-btn">반제품</button>
  </div>

  <div class="stats">
    <div class="card"><h3>총수량</h3><p id="totalQty">-</p></div>
    <div class="card"><h3>승인된 불량수량</h3><p id="defectQty">-</p></div>
    <div class="card"><h3>불량률 (%)</h3><p id="defectRate">-</p></div>
  </div>

  <h2 style="margin-top:45px;">불량유형별 승인건 수량</h2>
  <table>
    <thead><tr><th>불량유형명 (DEFECT_NAME)</th><th>승인된 불량수량</th></tr></thead>
    <tbody id="defectTypeBody"><tr><td colspan="2" style="color:var(--muted);">데이터 없음</td></tr></tbody>
  </table>
  <div id="loadingMsg" class="loading"></div>
</div>

<script>
const cxt = '${cxt}';
function showLoading(msg){document.getElementById('loadingMsg').textContent = msg || '';}

// ✅ JSP EL 충돌 없이 순수 JS 문자열 사용
async function loadStatistics(type){
  showLoading("📊 데이터를 불러오는 중...");
  try{
    const res = await fetch(cxt + "/quality/defect/statistics/data?type=" + type + "&_=" + Date.now());
    const data = await res.json();
    const summary = data.summary || {};
    const defectTypeStats = data.defectTypeStats || [];

    document.getElementById('title').textContent = (type === 'PCD') ? '완제품 불량 통계' : '반제품 불량 통계';
    document.getElementById('totalQty').textContent = summary.totalQty ? Number(summary.totalQty).toLocaleString() : '0';
    document.getElementById('defectQty').textContent = summary.defectQty ? Number(summary.defectQty).toLocaleString() : '0';
    document.getElementById('defectRate').textContent = ((summary.defectRate || 0).toFixed(2)) + '%';

    const tbody = document.getElementById('defectTypeBody');
    tbody.innerHTML = '';

    if(defectTypeStats.length === 0){
      tbody.innerHTML = '<tr><td colspan="2" style="color:var(--muted);">데이터 없음</td></tr>';
    }else{
      defectTypeStats.forEach(r=>{
        const name = r.defectTypeName || r.DEFECTTYPENAME || r.defectType || r.DEFECT_TYPE || '-';
        const qty = r.defectQty || r.DEFECTQTY || r.defectcount || r.DEFECTCOUNT || 0;
        const tr = document.createElement('tr');
        // ✅ 백틱 안 쓰고 문자열 연결로 완전 회피
        tr.innerHTML = '<td>' + name + '</td><td>' + Number(qty).toLocaleString() + '</td>';
        tbody.appendChild(tr);
      });
    }
    showLoading("");
  }catch(e){
    console.error("❌ 불량 통계 불러오기 오류:", e);
    showLoading("❌ 데이터를 불러오는 중 오류가 발생했습니다.");
  }
}

document.getElementById('btnPCD').addEventListener('click', ()=>{
  document.getElementById('btnPCD').classList.add('active');
  document.getElementById('btnSGD').classList.remove('active');
  loadStatistics('PCD');
});
document.getElementById('btnSGD').addEventListener('click', ()=>{
  document.getElementById('btnSGD').classList.add('active');
  document.getElementById('btnPCD').classList.remove('active');
  loadStatistics('SGD');
});

window.addEventListener('DOMContentLoaded', ()=>loadStatistics('PCD'));
</script>
</body>
</html>
