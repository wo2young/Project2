<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>기준관리 - BOM</title>

<%@ include file="/WEB-INF/views/includes/header.jsp" %>
<%@ include file="/WEB-INF/views/includes/2header.jsp" %>

<style>
/* ========= 기본 스타일 ========= */
section.container { padding: 20px; color: white; }
h1 { margin-bottom: 20px; }

table {
  border-collapse: collapse;
  width: 100%;
  margin-top: 10px;
}
th, td {
  border: 1px solid #ccc;
  padding: 10px;
  text-align: center;
}
th { background: #f5f5f5; color: black; }

/* ========= 버튼 ========= */
.btn {
  padding: 6px 10px;
  margin: 2px;
  cursor: pointer;
  border: none;
  border-radius: 5px;
  background: #3B82F6;
  color: white;
}
.btn:hover { background: #2563EB; }

/* ========= 검색 바 ========= */
.search-bar {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 10px;
}

/* ========= 모달 통일 스타일 (item.jsp 기준) ========= */
.modal {
  display: none;
  position: fixed;
  z-index: 999;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  background: rgba(0,0,0,0.5);
  justify-content: center;
  align-items: center;
}

.modal-content {
  background: black;
  padding: 20px;
  width: 450px;
  border-radius: 10px;
  color: white;
}

.modal-content h3 {
  margin-top: 0;
  margin-bottom: 10px;
  border-bottom: 1px solid #444;
  padding-bottom: 8px;
}

.modal-content label {
  display: block;
  margin-top: 10px;
  font-weight: bold;
}

.modal-content select,
.modal-content input {
  width: 100%;
  padding: 6px;
  margin-top: 4px;
  border: none;
  border-radius: 4px;
}

.close {
  float: right;
  cursor: pointer;
  font-weight: bold;
  color: white;
}

.unit-text {
  display: inline-block;
  padding: 6px 10px;
  background: #333;
  border-radius: 4px;
  min-width: 60px;
  text-align: center;
}
</style>
</head>

<body>
<section class="container">
  <h1>BOM 관리</h1>

  <!-- 🔍 검색 영역 -->
  <form method="get" action="">
    <div class="search-bar">
      <select name="type" style="height:30px;">
        <option value="">전체</option>
        <option value="PCD" ${param.type == 'PCD' ? 'selected' : ''}>완제품</option>
        <option value="SGD" ${param.type == 'SGD' ? 'selected' : ''}>반제품</option>
      </select>
      <input type="text" name="keyword" value="${keyword}" placeholder="제품명 또는 자재명 검색" style="height:28px;">
      <button type="submit" class="btn">검색</button>
      <button type="button" class="btn" style="margin-left:auto;" onclick="openAddModal()">+ 추가</button>
    </div>
  </form>

  <!-- 📋 테이블 -->
  <table>
    <thead>
      <tr>
        <th>BOM ID</th>
        <th>상위 제품명</th>
        <th>하위 자재명</th>
        <th>소요량</th>
        
        <th>상태</th>
        <th>생성일</th>
        <th>수정일</th>
        <th>관리</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="b" items="${list}">
        <tr>
          <td>${b.bomId}</td>
          <td>${b.parentItemName}</td>
          <td>${b.childItemName}</td>
          <td>${b.requiredQty} ${b.childUnit}</td>
          <td>${b.status eq 'Y' ? '활성' : '비활성'}</td>
          <td><fmt:formatDate value="${b.createdAt}" pattern="yyyy-MM-dd" timeZone="Asia/Seoul"/></td>
          <td><fmt:formatDate value="${b.updatedAt}" pattern="yyyy-MM-dd" timeZone="Asia/Seoul"/></td>
          <td>
            <button class="btn"
              onclick="openEditModal(${b.bomId}, ${b.parentItem}, ${b.childItem}, ${b.requiredQty}, '${b.status}', '${b.childUnit}')">
              수정/삭제
            </button>
          </td>
        </tr>
      </c:forEach>
      <c:if test="${empty list}">
        <tr><td colspan="9">등록된 BOM이 없습니다.</td></tr>
      </c:if>
    </tbody>
  </table>
</section>

<!-- ================= 모달 영역 ================= -->

<!-- 🔵 BOM 추가 -->
<div class="modal" id="addModal">
  <div class="modal-content">
    <span class="close" onclick="closeModals()">&times;</span>
    <h3>BOM 등록</h3>
    <form id="addForm">
      <label>상위 제품</label>
      <select name="parentItem">
        <c:forEach var="p" items="${parentList}">
          <option value="${p.itemId}">[${p.itemTypeCode}] ${p.itemName}</option>
        </c:forEach>
      </select>

      <label>하위 자재</label>
      <select name="childItem" id="addChildSelect" onchange="updateAddUnit()">
        <c:forEach var="c" items="${childList}">
          <option value="${c.itemId}" data-unit="${c.unit}">[${c.itemTypeCode}] ${c.itemName}</option>
        </c:forEach>
      </select>

      <label>단위</label>
      <span id="addUnitDisplay" class="unit-text"></span>

      <label>소요량</label>
      <input type="number" name="requiredQty" step="0.01" required>

      <label>상태</label>
      <select name="status">
        <option value="Y">활성</option>
        <option value="N">비활성</option>
      </select>

      <button type="button" class="btn" style="margin-top:15px;" onclick="saveAdd()">등록</button>
    </form>
  </div>
</div>

<!-- 🔵 BOM 수정/삭제 -->
<div class="modal" id="editModal">
  <div class="modal-content">
    <span class="close" onclick="closeModals()">&times;</span>
    <h3>BOM 수정 / 삭제</h3>
    <form id="editForm">
      <input type="hidden" name="bomId" id="editBomId">

      <label>상위 제품</label>
      <select name="parentItem" id="editParentSelect">
        <c:forEach var="p" items="${parentList}">
          <option value="${p.itemId}">[${p.itemTypeCode}] ${p.itemName}</option>
        </c:forEach>
      </select>

      <label>하위 자재</label>
      <select name="childItem" id="editChildSelect" onchange="updateEditUnit()">
        <c:forEach var="c" items="${childList}">
          <option value="${c.itemId}" data-unit="${c.unit}">[${c.itemTypeCode}] ${c.itemName}</option>
        </c:forEach>
      </select>

      <label>단위</label>
      <span id="editUnitDisplay" class="unit-text"></span>

      <label>소요량</label>
      <input type="number" name="requiredQty" id="editQty" step="0.01" required>

      <label>상태</label>
      <select name="status" id="editStatus">
        <option value="Y">활성</option>
        <option value="N">비활성</option>
      </select>

      <button type="button" class="btn" style="margin-top:10px;" onclick="saveEdit()">수정</button>
      <button type="button" class="btn" style="background:#EF4444;margin-top:10px;" onclick="deleteEdit()">삭제</button>
    </form>
  </div>
</div>

<script>
function openAddModal(){
  document.getElementById("addModal").style.display="flex";
  updateAddUnit();
}
function openEditModal(bomId, parentItem, childItem, qty, status, unit){
  document.getElementById("editModal").style.display="flex";
  document.getElementById("editBomId").value = bomId;
  document.getElementById("editParentSelect").value = parentItem;

  const childSel = document.getElementById("editChildSelect");
  const found = Array.from(childSel.options).find(o => o.value == childItem);
  childSel.value = found ? childItem : childSel.options[0].value;

  document.getElementById("editQty").value = qty;
  document.getElementById("editStatus").value = status;
  document.getElementById("editUnitDisplay").textContent = unit || "";
}
function closeModals(){
  document.querySelectorAll(".modal").forEach(m => m.style.display="none");
}
window.onclick = e => {
  document.querySelectorAll('.modal').forEach(m=>{
    if(e.target === m) m.style.display="none";
  });
};

function updateAddUnit(){
  const sel = document.getElementById("addChildSelect");
  if(!sel) return;
  const unit = sel.options[sel.selectedIndex].dataset.unit;
  document.getElementById("addUnitDisplay").textContent = unit || "";
}
function updateEditUnit(){
  const sel = document.getElementById("editChildSelect");
  if(!sel) return;
  const unit = sel.options[sel.selectedIndex].dataset.unit;
  document.getElementById("editUnitDisplay").textContent = unit || "";
}

// 🔹 등록
function saveAdd(){
  const form = document.getElementById("addForm");
  const data = new URLSearchParams(new FormData(form)).toString();
  fetch("${pageContext.request.contextPath}/master/bom/insert", {
    method:"POST",
    headers:{"Content-Type":"application/x-www-form-urlencoded"},
    body:data
  }).then(res=>res.text()).then(result=>{
    if(result==="duplicate"){ alert("⚠ 동일한 상위-하위 조합이 이미 존재합니다."); return; }
    if(result!=="success"){ alert("오류가 발생했습니다."); return; }
    alert("✅ 등록되었습니다."); location.reload();
  });
}

// 🔹 수정
function saveEdit(){
  const form = document.getElementById("editForm");
  const data = new URLSearchParams(new FormData(form)).toString();
  fetch("${pageContext.request.contextPath}/master/bom/update", {
    method:"POST",
    headers:{"Content-Type":"application/x-www-form-urlencoded"},
    body:data
  }).then(res=>res.text()).then(result=>{
    if(result==="duplicate"){ alert("⚠ 동일한 상위-하위 조합이 이미 존재합니다."); return; }
    if(result!=="success"){ alert("오류가 발생했습니다."); return; }
    alert("✅ 수정되었습니다."); location.reload();
  });
}

// 🔹 삭제
function deleteEdit(){
  const bomId = document.getElementById("editBomId").value;
  const childItem = document.getElementById("editChildSelect").value;
  if(!confirm("정말 삭제하시겠습니까?")) return;

  fetch("${pageContext.request.contextPath}/master/bom/delete", {
    method:"POST",
    headers:{"Content-Type":"application/x-www-form-urlencoded"},
    body:"bomId="+bomId+"&childItem="+childItem
  }).then(res=>res.text()).then(result=>{
    if(result==="used"){ alert("⚠ 이 자재는 다른 BOM의 상위로 사용 중이라 삭제할 수 없습니다."); return; }
    if(result!=="success"){ alert("오류가 발생했습니다."); return; }
    alert("✅ 삭제되었습니다."); location.reload();
  });
}
</script>

</body>
</html>
