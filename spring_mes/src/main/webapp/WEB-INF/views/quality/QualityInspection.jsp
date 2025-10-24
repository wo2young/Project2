<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="/WEB-INF/views/includes/header.jsp"%>

<c:set var="cxt" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>품질 검사 관리</title>
<style>
  :root {
    --bg:#0b111c; --surface:#0f1626; --surface-2:#0d1423;
    --line:#253150; --line-2:#2b385c; --text:#e6ebff;
    --muted:#9fb0d6; --accent:#f59e0b; --accent-hover:#d48a07; --danger:#ef4444;
  }
  html,body{margin:0;padding:0;background:var(--bg);color:var(--text);
    font-family:'Noto Sans KR',system-ui,sans-serif;}
  .container{max-width:1100px;margin:40px auto;padding:24px;
    background:var(--surface);border:1px solid var(--line);
    border-radius:12px;box-shadow:0 0 10px rgba(0,0,0,.4);}
  h2{color:var(--accent);border-left:4px solid var(--accent);
    padding-left:10px;margin-bottom:20px;}
  table{width:100%;border-collapse:collapse;background:var(--surface-2);
    border-radius:10px;overflow:hidden;}
  th,td{padding:10px 12px;text-align:center;border-bottom:1px solid var(--line-2);}
  th{background:var(--surface);color:var(--muted);font-weight:600;}
  tr:hover{background:rgba(255,255,255,.05);}
  .msg{text-align:center;color:var(--accent);margin-bottom:15px;font-weight:600;}
  .error-msg{text-align:center;color:var(--danger);margin-bottom:15px;font-weight:600;}
  
  /* ✅ 상단 탭 */
  .tab-bar{display:flex;gap:8px;margin-bottom:20px;}
  .tab-btn{
    background:var(--surface-2);color:var(--muted);
    padding:8px 16px;border:none;border-radius:8px;cursor:pointer;
    font-weight:600;transition:.2s;
  }
  .tab-btn.active{background:var(--accent);color:#fff;}
  .tab-btn:hover:not(.active){background:var(--line-2);}
  
  /* ✅ 상단 버튼 영역 */
  .header-bar{display:flex;justify-content:space-between;align-items:center;margin-bottom:10px;}
  .btn-add{
    background:var(--accent);color:#fff;border:none;border-radius:6px;
    padding:8px 16px;font-weight:600;cursor:pointer;transition:.2s;
  }
  .btn-add:hover{background:var(--accent-hover);}
  
  /* ✅ 모달 */
  .modal{display:none;position:fixed;top:0;left:0;width:100%;height:100%;
    background:rgba(0,0,0,0.6);z-index:999;justify-content:center;align-items:center;}
  .modal-content{
    background:var(--surface);padding:20px 30px;border-radius:10px;
    width:400px;box-shadow:0 0 10px rgba(0,0,0,.5);
  }
  .modal h3{color:var(--accent);margin-bottom:15px;text-align:center;}
  .modal label{display:block;margin-top:10px;color:var(--muted);}
  .modal input,.modal select,.modal textarea{
    width:100%;background:var(--surface-2);color:var(--text);
    border:1px solid var(--line-2);border-radius:6px;padding:6px 8px;margin-top:4px;
  }
  .modal-btns{text-align:center;margin-top:15px;}
  .modal-btns button{margin:0 5px;}
</style>
</head>

<body>
<div class="container">
  <!-- ✅ 상단 탭 -->
  <div class="tab-bar">
    <button class="tab-btn active" onclick="location.href='${cxt}/quality/inspection'">품질관리</button>
    <button class="tab-btn" onclick="location.href='${cxt}/quality/defect'">불량관리</button>
    <button class="tab-btn" onclick="location.href='${cxt}/quality/defect/statistics'">불량 통계</button>
  </div>

  <!-- ✅ 메시지 -->
  <c:if test="${not empty msg}"><div class="msg">${msg}</div></c:if>
  <c:if test="${not empty errorMsg}"><div class="error-msg">${errorMsg}</div></c:if>

  <!-- ✅ 상단 제목 + 등록버튼 -->
  <div class="header-bar">
    <h2>품질 검사 목록</h2>
    <button class="btn-add" onclick="openModal()">+ 검사 등록</button>
  </div>

  <!-- ✅ 검사 목록 -->
  <table>
    <thead>
      <tr>
        <th>검사ID</th>
        <th>TXN_ID</th>
        <th>품목명</th>
        <th>품목상태</th>
        <th>검사자</th>
        <th>불량수량</th>
        <th>검사결과</th>
        <th>비고</th>
        <th>등록일</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="i" items="${inspectionList}">
        <tr>
          <td>${i.inspectionId}</td>
          <td>${i.txnId}</td>
          <td>${i.itemName}</td>
          <td>${i.inspectType}</td>
          <td>${i.inspectorId}</td>
          <td>${i.defectQty}</td>
          <td>${i.inspectionResult}</td>
          <td>${i.remarks}</td>
          <td>${i.createdAt}</td>
        </tr>
      </c:forEach>
    </tbody>
  </table>
</div>

<!-- ✅ 모달창 -->
<div id="inspectionModal" class="modal">
  <div class="modal-content">
    <h3>품질검사 등록</h3>
    <form id="inspectionForm" method="post" action="${cxt}/quality/inspection/add">
      <label>인벤토리 ID (TXN_ID)</label>
      <select id="txnId" name="txnId" required>
        <option value="">-- 검사전 목록 --</option>
        <c:forEach var="inv" items="${inventoryList}">
          <option value="${inv.txnId}" data-qty="${inv.quantity}" data-type="${inv.itemTypeCode}">
            ${inv.txnId} (${inv.itemName})
          </option>
        </c:forEach>
      </select>

      <label>품목 상태</label>
      <input type="text" id="inspectType" name="inspectType" readonly>

      <label>검사 수량</label>
      <input type="number" id="inspectionQty" name="inspectionQty" readonly>

      <label>불량 수량</label>
      <input type="number" id="defectQty" name="defectQty" required>

      <input type="hidden" id="inspectionResult" name="inspectionResult">

      <label>비고</label>
      <textarea name="remarks" rows="2" placeholder="비고를 입력하세요"></textarea>

      <div class="modal-btns">
        <button type="submit">등록</button>
        <button type="button" onclick="closeModal()">닫기</button>
      </div>
    </form>
  </div>
</div>

<!-- ✅ JS -->
<script>
const modal = document.getElementById("inspectionModal");
function openModal(){ modal.style.display="flex"; }
function closeModal(){ modal.style.display="none"; }

// ✅ 등록 전 확인
document.getElementById("inspectionForm").addEventListener("submit", function(e){
  if(!confirm("등록하시겠습니까?")) e.preventDefault();
});

// ✅ 검사 유형 자동 입력
document.getElementById("txnId").addEventListener("change", async function(){
  const sel = this.options[this.selectedIndex];
  if(!sel.value) return;

  const qty = parseInt(sel.dataset.qty) || 0;
  document.getElementById("inspectionQty").value = qty;

  try {
    const res = await fetch("${cxt}/quality/getItemTypeCode?txnId=" + sel.value);
    const data = await res.json();
    document.getElementById("inspectType").value = data.inspectType || "확인 불가";
  } catch(err) {
    console.error(err);
    document.getElementById("inspectType").value = "오류 발생";
  }
});

// ✅ 불량률 계산
document.getElementById("defectQty").addEventListener("input", function(){
  const total = parseFloat(document.getElementById("inspectionQty").value) || 0;
  const defect = parseFloat(this.value) || 0;

  if(defect > total){
    alert("❌ 불량 수량은 검사 수량을 초과할 수 없습니다.");
    this.value = total;
    return;
  }

  if(total <= 0) return;
  const rate = (defect / total) * 100;
  const result = rate >= 10 ? "NG" : "OK";
  document.getElementById("inspectionResult").value = result;
});
</script>
</body>
</html>
