<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="/WEB-INF/views/includes/header.jsp"%>

<c:set var="cxt" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>생산 목표 관리</title>
<style>
  :root{
    --bg:#0b111c;--surface:#0f1626;--surface-2:#0d1423;--line:#253150;
    --line-2:#2b385c;--text:#e6ebff;--muted:#9fb0d6;--accent:#f59e0b;
    --accent-hover:#d48a07;--danger:#ef4444;
  }
  html,body{margin:0;padding:0;background:var(--bg);color:var(--text);
    font-family:system-ui,-apple-system,Segoe UI,Roboto,Pretendard,sans-serif;overflow-x:hidden;}
  .container{max-width:1100px;margin:0 auto;padding:20px 16px 48px;}
  .top-bar{display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;}
  .top-bar h2{margin:0;color:#fff;font-size:20px;font-weight:700;}
  .btn{display:inline-flex;align-items:center;justify-content:center;height:38px;padding:0 14px;border-radius:10px;
    border:1px solid var(--line);background:var(--surface-2);color:var(--text);cursor:pointer;text-decoration:none;
    font-size:14px;font-weight:800;}
  .btn-primary{background:var(--accent);color:#111;}
  .btn-primary:hover{background:var(--accent-hover);}
  .btn-danger{background:var(--danger);color:#fff;border:none;}
  .btn-sm{height:30px;padding:0 10px;font-size:13px;}
  .btn-group{display:flex;gap:8px;justify-content:center;}
  .search-bar{display:flex;flex-wrap:wrap;gap:12px;align-items:flex-end;margin:14px 0 16px;
    padding:12px;background:var(--surface);border:1px solid var(--line);border-radius:12px;}
  .search-bar label{font-size:12px;color:#cfe0ff;font-weight:800}
  .search-bar input[type="date"]{height:38px;padding:6px 10px;border:1px solid var(--line-2);
    border-radius:10px;background:var(--surface-2);color:var(--text);}
  .search-bar .actions{margin-left:auto;display:flex;gap:8px}
  .table-wrap{margin-top:12px;border:1px solid var(--line);border-radius:12px;background:var(--surface);}
  table{width:100%;border-collapse:collapse;color:var(--text);}
  th,td{padding:10px;text-align:center;border-top:1px solid var(--line);}
  th{background:#0e1830;color:#fff;font-weight:800;}
  tr:nth-child(odd){background:#0e1527;}
  tr:hover{background:#101a2e;}
  .empty{color:#cbd5e1;text-align:center;padding:20px;}
  .modal{position:fixed;inset:0;display:flex;align-items:center;justify-content:center;background:rgba(0,0,0,.7);
    opacity:0;pointer-events:none;transition:.2s;}
  .modal.show{opacity:1;pointer-events:auto;}
  .modal-content{background:#1a2237;padding:24px;border-radius:14px;color:#fff;width:min(500px,95vw);}
  .modal-content h3{margin:0 0 16px 0;font-size:18px;font-weight:800;border-bottom:1px solid #3b4e78;padding-bottom:10px;}
  .modal-actions{margin-top:20px;display:flex;justify-content:flex-end;gap:10px;}
  label{display:block;margin-top:10px;font-weight:700;color:#cfe0ff;}
  input,select{width:100%;height:38px;border-radius:8px;border:1px solid var(--line-2);
    background:var(--surface-2);color:#fff;padding:0 10px;}
</style>
</head>
<body>

<div class="container">
  <div class="top-bar">
    <h2>생산 목표 조회</h2>
    <button class="btn btn-primary" onclick="openAddModal()">+ 생산 목표 등록</button>
  </div>

  <c:if test="${not empty msg}"><script>alert("${msg}");</script><c:remove var="msg" scope="session"/></c:if>
  <c:if test="${not empty errorMsg}"><script>alert("${errorMsg}");</script><c:remove var="errorMsg" scope="session"/></c:if>

  <form method="get" action="${cxt}/target/list" class="search-bar">
    <div class="field"><label>시작일</label><input type="date" name="searchStart" value="${param.searchStart}"></div>
    <div class="field"><label>종료일</label><input type="date" name="searchEnd" value="${param.searchEnd}"></div>
    <div class="actions"><button type="submit" class="btn btn-primary">조회</button><a class="btn" href="${cxt}/target/list">초기화</a></div>
  </form>

  <c:choose>
    <c:when test="${empty targetList}"><p class="empty">등록된 생산 목표가 없습니다.</p></c:when>
    <c:otherwise>
      <div class="table-wrap"><table><thead><tr>
        <th>ID</th><th>품목명</th><th>시작일</th><th>종료일</th><th>목표 수량</th><th>등록자</th><th>관리</th>
      </tr></thead><tbody>
      <c:forEach var="t" items="${targetList}">
        <tr>
          <td>${t.targetId}</td><td>${t.itemName}</td>
          <td><fmt:formatDate value="${t.startDate}" pattern="yyyy-MM-dd"/></td>
          <td><fmt:formatDate value="${t.endDate}" pattern="yyyy-MM-dd"/></td>
          <td>${t.targetQty}</td><td>${t.createdByName}</td>
          <td>
            <div class="btn-group">
              <!-- ✅ 수정 버튼 추가 -->
              <button type="button" class="btn btn-sm btn-primary" onclick="openEditModal('${t.targetId}', '${t.itemId}', '${t.targetQty}', '${t.startDate}', '${t.endDate}')">수정</button>
              
              <!-- 삭제 버튼 -->
              <form method="post" action="${cxt}/target/delete" onsubmit="return confirm('삭제하시겠습니까?');">
                <input type="hidden" name="targetId" value="${t.targetId}">
                <button type="submit" class="btn btn-sm btn-danger">삭제</button>
              </form>
            </div>
          </td>
        </tr>
      </c:forEach>
      </tbody></table></div>
    </c:otherwise>
  </c:choose>
</div>

<!-- 등록 모달 -->
<div id="addModal" class="modal">
  <div class="modal-content">
    <h3>생산 목표 등록</h3>
    <form action="${cxt}/target/insert" method="post">
      <label>품목 선택</label>
      <select name="itemId" required>
        <option value="">-- 품목 선택 --</option>
        <c:forEach var="item" items="${itemList}">
          <option value="${item.itemId}">${item.itemName}</option>
        </c:forEach>
      </select>
      <label>목표 수량</label><input type="number" name="targetQty" min="1" required>
      <label>시작일</label><input type="date" name="startDate" required>
      <label>종료일</label><input type="date" name="endDate" required>
      <div class="modal-actions">
        <button type="submit" class="btn btn-primary">등록</button>
        <button type="button" class="btn" onclick="closeAddModal()">닫기</button>
      </div>
    </form>
  </div>
</div>

<!-- ✅ 수정 모달 -->
<div id="editModal" class="modal">
  <div class="modal-content">
    <h3>생산 목표 수정</h3>
    <form action="${cxt}/target/update" method="post" onsubmit="return validateUpdateQty();">
      <input type="hidden" name="targetId" id="editTargetId">

      <label>품목 선택</label>
      <select name="itemId" id="editItemId" required>
        <option value="">-- 품목 선택 --</option>
        <c:forEach var="item" items="${itemList}">
          <option value="${item.itemId}">${item.itemName}</option>
        </c:forEach>
      </select>

      <label>목표 수량</label>
      <input type="number" name="targetQty" id="editTargetQty" min="1" required>

      <label>시작일</label>
      <input type="date" name="startDate" id="editStartDate" required>

      <label>종료일</label>
      <input type="date" name="endDate" id="editEndDate" required>

      <div class="modal-actions">
        <button type="submit" class="btn btn-primary">수정</button>
        <button type="button" class="btn" onclick="closeEditModal()">닫기</button>
      </div>
    </form>
  </div>
</div>

<script>
function openAddModal(){document.getElementById("addModal").classList.add("show");}
function closeAddModal(){document.getElementById("addModal").classList.remove("show");}

function openEditModal(id, itemId, qty, start, end){
  document.getElementById("editTargetId").value = id;
  document.getElementById("editItemId").value = itemId;
  document.getElementById("editTargetQty").value = qty;
  document.getElementById("editStartDate").value = start;
  document.getElementById("editEndDate").value = end;
  document.getElementById("editModal").classList.add("show");
}
function closeEditModal(){
  document.getElementById("editModal").classList.remove("show");
}

// ✅ 목표 수량 검증 (생산지시 합계보다 작으면 불가)
function validateUpdateQty(){
  const targetId = document.getElementById("editTargetId").value;
  const targetQty = parseInt(document.getElementById("editTargetQty").value, 10);
  let orderQty = 0;

  const xhr = new XMLHttpRequest();
  xhr.open("GET", `${"${cxt}"}/target/orderSum?targetId=${targetId}`, false);
  xhr.send();

  if(xhr.status === 200){
    orderQty = parseInt(xhr.responseText || "0", 10);
  }

  if(targetQty < orderQty){
    alert(`현재 생산지시 총 수량(${orderQty})보다 적은 목표 수량(${targetQty})은 설정할 수 없습니다.`);
    return false;
  }
  return true;
}
</script>

</body>
</html>
