<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="/WEB-INF/views/includes/header.jsp"%>

<c:set var="cxt" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>불량 관리</title>
<style>
  :root {
    --bg:#0b111c; --surface:#0f1626; --surface-2:#0d1423;
    --line:#253150; --line-2:#2b385c; --text:#e6ebff;
    --muted:#9fb0d6; --accent:#f59e0b; --accent-hover:#d48a07; --danger:#ef4444;
  }
  html,body{
    margin:0;padding:0;
    background:var(--bg);color:var(--text);
    font-family:'Noto Sans KR',system-ui,sans-serif;
  }
  .container{
    max-width:1100px;margin:40px auto;padding:24px;
    background:var(--surface);border:1px solid var(--line);
    border-radius:12px;box-shadow:0 0 10px rgba(0,0,0,.4);
  }
  h2{
    color:var(--accent);border-left:4px solid var(--accent);
    padding-left:10px;margin-bottom:20px;
  }
  table{
    width:100%;border-collapse:collapse;
    background:var(--surface-2);border-radius:10px;overflow:hidden;
  }
  th,td{
    padding:10px 12px;text-align:center;
    border-bottom:1px solid var(--line-2);
  }
  th{background:var(--surface);color:var(--muted);font-weight:600;}
  tr:hover{background:rgba(255,255,255,.05);}
  .msg{text-align:center;color:var(--accent);margin-bottom:15px;font-weight:600;}
  .error-msg{text-align:center;color:var(--danger);margin-bottom:15px;font-weight:600;}

  /* ✅ 상단 탭 */
  .tab-bar{
    display:flex;gap:8px;margin-bottom:20px;
  }
  .tab-btn{
    background:var(--surface-2);color:var(--muted);
    padding:8px 16px;border:none;border-radius:8px;
    cursor:pointer;font-weight:600;transition:.2s;
  }
  .tab-btn.active{background:var(--accent);color:#fff;}
  .tab-btn:hover:not(.active){background:var(--line-2);}

  /* ✅ 상단 버튼 영역 */
  .header-bar{
    display:flex;justify-content:space-between;
    align-items:center;margin-bottom:10px;
  }
  .btn-add{
    background:var(--accent);color:#fff;border:none;border-radius:6px;
    padding:8px 16px;font-weight:600;cursor:pointer;transition:.2s;
  }
  .btn-add:hover{background:var(--accent-hover);}

  /* ✅ 모달 */
  .modal{
    display:none;position:fixed;top:0;left:0;width:100%;height:100%;
    background:rgba(0,0,0,0.6);z-index:999;
    justify-content:center;align-items:center;
  }
  .modal-content{
    background:var(--surface);padding:20px 30px;border-radius:10px;
    width:400px;box-shadow:0 0 10px rgba(0,0,0,.5);
  }
  .modal h3{color:var(--accent);margin-bottom:15px;text-align:center;}
  .modal label{display:block;margin-top:10px;color:var(--muted);}
  .modal input,.modal select,.modal textarea{
    width:100%;background:var(--surface-2);color:var(--text);
    border:1px solid var(--line-2);border-radius:6px;
    padding:6px 8px;margin-top:4px;
  }
  .modal-btns{text-align:center;margin-top:15px;}
  .modal-btns button{margin:0 5px;}
</style>
</head>

<body>
<div class="container">

  <!-- ✅ 상단 탭 -->
  <div class="tab-bar">
    <button class="tab-btn" onclick="location.href='${cxt}/quality/inspection'">품질관리</button>
    <button class="tab-btn active" onclick="location.href='${cxt}/quality/defect'">불량관리</button>
    <button class="tab-btn" onclick="location.href='${cxt}/quality/defect/statistics'">불량 통계</button>
  </div>

  <!-- ✅ 메시지 -->
  <c:if test="${not empty msg}"><div class="msg">${msg}</div></c:if>
  <c:if test="${not empty errorMsg}"><div class="error-msg">${errorMsg}</div></c:if>

  <!-- ✅ 상단 제목 + 등록버튼 -->
  <div class="header-bar">
    <h2>불량 목록</h2>
    <button class="btn-add" onclick="openModal()">+ 불량 등록</button>
  </div>

  <!-- ✅ 불량 목록 테이블 -->
  <table>
    <thead>
      <tr>
        <th>불량ID</th>
        <th>검사ID</th>
        <th>품목명</th>
        <th>불량유형</th>
        <th>불량수량</th>
        <th>비고</th>
        <th>등록자</th>
        <th>등록일</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="d" items="${defectList}">
        <tr>
          <td>${d.defectId}</td>
          <td>${d.inspectId}</td>
          <td>${d.itemName}</td>
          <td>${d.defectType}</td>
          <td>${d.defectQty}</td>
          <td>${d.defectReason}</td>
          <td>${d.inspectorName}</td>
          <td>${d.createdAt}</td>
        </tr>
      </c:forEach>
    </tbody>
  </table>
</div>

<!-- ✅ 불량 등록 모달 -->
<div id="defectModal" class="modal">
  <div class="modal-content">
    <h3>불량 등록</h3>
    <form id="defectForm" method="post" action="${cxt}/quality/defect/add">

      <label>검사 ID (INSPECTION_ID)</label>
      <select id="inspectId" name="inspectId" required>
        <option value="">-- 검사 항목 선택 --</option>
        <c:forEach var="inv" items="${inventoryList}">
          <option value="${inv.inspectionId}" data-item="${inv.itemName}">
            ${inv.inspectionId} (${inv.itemName})
          </option>
        </c:forEach>
      </select>

      <!-- ✅ 총/남은 수량 표시 -->
      <div style="margin-top:8px;color:var(--accent);font-weight:600;">
        총 불량 수량: <span id="totalQty">-</span> |
        남은 불량 수량: <span id="remainingQty">-</span>
      </div>

      <label>불량 유형</label>
      <select id="defectType" name="defectType" required>
        <option value="">-- 불량 유형 선택 --</option>
        <c:forEach var="code" items="${defectCodes}">
          <option value="${code.codeName}">${code.codeName}</option>
        </c:forEach>
      </select>

      <label>불량 수량</label>
      <input type="number" id="defectQty" name="defectQty" required min="1">

      <label>불량 사유</label>
      <textarea name="defectReason" rows="2" placeholder="불량 사유를 입력하세요"></textarea>

      <div class="modal-btns">
        <button type="submit">등록</button>
        <button type="button" onclick="closeModal()">닫기</button>
      </div>
    </form>
  </div>
</div>

<!-- ✅ JS -->
<script>
const modal = document.getElementById("defectModal");
function openModal(){ modal.style.display="flex"; }
function closeModal(){ modal.style.display="none"; }

document.getElementById("defectForm").addEventListener("submit", function(e){
  if(!confirm("불량 정보를 등록하시겠습니까?")) e.preventDefault();
});

// ✅ 총/남은 수량 표시
document.getElementById("inspectId").addEventListener("change", function() {
  const inspectionId = this.value;
  const totalSpan = document.getElementById("totalQty");
  const remainingSpan = document.getElementById("remainingQty");
  const defectInput = document.getElementById("defectQty");

  if (!inspectionId) {
    totalSpan.textContent = "-";
    remainingSpan.textContent = "-";
    defectInput.max = "";
    return;
  }

  fetch('${pageContext.request.contextPath}/quality/defect/qtyinfo/' + inspectionId)
    .then(res => {
      if (!res.ok) throw new Error('HTTP ' + res.status);
      return res.json();
    })
    .then(data => {
      totalSpan.textContent = data.totalQty + "개";
      remainingSpan.textContent = data.remainingQty + "개";
      defectInput.max = data.remainingQty;
    })
    .catch((err) => {
      console.error('조회 실패:', err);
      totalSpan.textContent = "조회 실패";
      remainingSpan.textContent = "조회 실패";
    });
});

// ✅ 초과 입력 시 제한
document.getElementById("defectQty").addEventListener("input", function() {
  const max = parseInt(this.max || 0);
  const val = parseInt(this.value || 0);
  if (max > 0 && val > max) {
    alert(`등록 가능한 최대 불량 수량은 ${max}개입니다.`);
    this.value = max;
  }
});
</script>
</body>
</html>
