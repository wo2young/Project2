<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>기준관리-BOM</title>

<%@ include file="/WEB-INF/views/includes/header.jsp" %>
<%@ include file="/WEB-INF/views/includes/2header.jsp" %>

<style>
section.container { padding: 20px; }

table {
  border-collapse: collapse;
  width: 100%;
  margin-top: 10px;
}
th, td {
  border: 1px solid #ccc;
  padding: 8px;
  text-align: center;
}
th { background: #f8f8f8; }

.btn {
  padding: 5px 10px;
  margin: 2px;
  cursor: pointer;
  border: 1px solid #aaa;
  border-radius: 4px;
  background: #fafafa;
}
.btn:hover { background: #eaeaea; }

.search-bar {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 10px;
}

.modal {
  display: none;
  border: 1px solid #ccc;
  background: #fafafa;
  padding: 20px;
  width: 520px;
  position: fixed;
  top: 15%;
  left: 50%;
  transform: translateX(-50%);
  box-shadow: 0 2px 8px rgba(0,0,0,0.2);
  z-index: 1000;
}
.modal h3 { margin-top: 0; }

.unit-text {
  display: inline-block;
  padding: 6px 10px;
  border: 1px solid #ddd;
  background: #eee;
  min-width: 60px;
  text-align: center;
  border-radius: 4px;
}
.overlay {
  display: none;
  position: fixed;
  top: 0; left: 0;
  width: 100%; height: 100%;
  background: rgba(0,0,0,0.3);
  z-index: 900;
}
</style>
</head>
<body>

<section class="container">
  <h1>BOM 관리</h1>

<!-- 동현이형 이거 검색창임 -->
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

<!-- 형 이건 테이블 -->
  <table>
    <thead>
      <tr>
        <th>BOM ID</th>
        <th>상위 제품명</th>
        <th>하위 자재명</th>
        <th>소요량</th>
        <th>단위</th>
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
          <td>${b.requiredQty}</td>
          <td>${b.childUnit}</td>
          <td>${b.status eq 'Y' ? '활성' : '비활성'}</td>
          <!-- 한국시간으로 저장 -->
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

<div class="overlay" id="overlay" onclick="closeModals()"></div>

<!-- 동현이형 이거 추가 모달임 -->
<div class="modal" id="addModal">
  <h3>BOM 등록</h3>
  <form id="addForm">
    <label>상위 제품:</label><br>
    <select name="parentItem">
      <c:forEach var="p" items="${parentList}">
        <option value="${p.itemId}">[${p.itemTypeCode}] ${p.itemName}</option>
      </c:forEach>
    </select><br><br>

    <label>하위 자재:</label><br>
    <select name="childItem" id="addChildSelect" onchange="updateAddUnit()">
      <c:forEach var="c" items="${childList}">
        <option value="${c.itemId}" data-unit="${c.unit}">[${c.itemTypeCode}] ${c.itemName}</option>
      </c:forEach>
    </select><br><br>

    <label>단위:</label><br>
    <span id="addUnitDisplay" class="unit-text"></span><br><br>

    <label>소요량:</label><br>
    <input type="number" name="requiredQty" step="0.01" required><br><br>

    <label>상태:</label><br>
    <select name="status">
      <option value="Y">활성</option>
      <option value="N">비활성</option>
    </select><br><br>

    <button type="button" class="btn" onclick="saveAdd()">등록</button>
    <button type="button" class="btn" onclick="closeModals()">닫기</button>
  </form>
</div>

<!-- 동현이형 이거 수정/삭제 모달임 -->
<div class="modal" id="editModal">
  <h3>BOM 수정 / 삭제</h3>
  <form id="editForm">
    <input type="hidden" name="bomId" id="editBomId">

    <label>상위 제품:</label><br>
    <select name="parentItem" id="editParentSelect">
      <c:forEach var="p" items="${parentList}">
        <option value="${p.itemId}">[${p.itemTypeCode}] ${p.itemName}</option>
      </c:forEach>
    </select><br><br>

    <label>하위 자재:</label><br>
    <select name="childItem" id="editChildSelect" onchange="updateEditUnit()">
      <c:forEach var="c" items="${childList}">
        <option value="${c.itemId}" data-unit="${c.unit}">[${c.itemTypeCode}] ${c.itemName}</option>
      </c:forEach>
    </select><br><br>

    <label>단위:</label><br>
    <span id="editUnitDisplay" class="unit-text"></span><br><br>

    <label>소요량:</label><br>
    <input type="number" name="requiredQty" id="editQty" step="0.01" required><br><br>

    <label>상태:</label><br>
    <select name="status" id="editStatus">
      <option value="Y">활성</option>
      <option value="N">비활성</option>
    </select><br><br>

    <button type="button" class="btn" onclick="saveEdit()">저장</button>
    <button type="button" class="btn" onclick="deleteEdit()">삭제</button>
    <button type="button" class="btn" onclick="closeModals()">닫기</button>
  </form>
</div>

<script>
function openAddModal(){ document.getElementById("overlay").style.display="block"; document.getElementById("addModal").style.display="block"; updateAddUnit(); }
function openEditModal(bomId, parentItem, childItem, qty, status, unit){
  document.getElementById("overlay").style.display="block";
  document.getElementById("editModal").style.display="block";
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
  document.getElementById("overlay").style.display="none";
  document.getElementById("addModal").style.display="none";
  document.getElementById("editModal").style.display="none";
}

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
