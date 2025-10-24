<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>기준관리 - 공정</title>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>
<%@ include file="/WEB-INF/views/includes/2header.jsp" %>

<style>
section.container { padding: 20px; }

table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 15px;
}
th, td {
  border: 1px solid #ccc;
  padding: 10px;
  text-align: center;
}
th { background: #f8f8f8; }

.btn {
  padding: 6px 10px;
  border: 1px solid #aaa;
  border-radius: 4px;
  background: #fafafa;
  cursor: pointer;
}
.btn:hover { background: #eaeaea; }

/* 🔸 모달 스타일 */
.overlay {
  display: none;
  position: fixed;
  top: 0; left: 0;
  width: 100%; height: 100%;
  background: rgba(0,0,0,0.6);
  z-index: 900;
}
.modal {
  display: none;
  background: #000;
  color: #fff;
  padding: 25px;
  width: 450px;
  border-radius: 10px;
  position: fixed;
  top: 15%;
  left: 50%;
  transform: translateX(-50%);
  box-shadow: 0 0 15px rgba(0,0,0,0.3);
  z-index: 1000;
}
.modal h3 { margin-top: 0; color: #fff; }
.modal label { display: block; margin-top: 10px; font-weight: bold; }

.modal input, .modal select, .modal textarea {
  width: 100%;
  margin-top: 5px;
  padding: 6px;
  border-radius: 4px;
  border: none;
}
.modal button { margin-top: 10px; }
img.preview {
  max-width: 100%;
  border: 1px solid #333;
  margin-top: 10px;
}
</style>
</head>
<body>

<section class="container">
  <h1>공정 관리</h1>

  <div class="search-bar" style="display:flex;align-items:center;gap:10px;margin-bottom:10px;">
    <form method="get" action="">
      <select name="itemId" style="height:30px;">
        <option value="">전체 제품</option>
        <c:forEach var="it" items="${itemOptions}">
          <option value="${it.itemId}" ${selectedItemId == it.itemId ? 'selected' : ''}>${it.itemName}</option>
        </c:forEach>
      </select>
      <input type="text" name="keyword" value="${keyword}" placeholder="제품명 / 설비명 검색" style="height:28px;">
      <button type="submit" class="btn">검색</button>
    </form>
    <button class="btn" style="margin-left:auto;" onclick="openAddModal()">+ 공정 추가</button>
  </div>

  <table>
    <thead>
      <tr>
        <th>ID</th>
        <th>제품명</th>
        <th>유형</th>
        <th>순서</th>
        <th>설비명</th>
        <th>비고</th>
        <th>이미지</th>
        <th>관리</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="r" items="${routingList}">
        <tr>
          <td>${r.routingId}</td>
          <td>${r.itemName}</td>
          <td>${r.itemTypeCode}</td>
          <td>${r.processStep}</td>
          <td>${r.equipName}</td>
          <td>${r.remark}</td>
          <td>
            <c:if test="${not empty r.imgPath}">
              <img src="${pageContext.request.contextPath}${r.imgPath}" width="50">
            </c:if>
          </td>
          <td>
            <button class="btn" onclick="openEditModal(${r.routingId})">수정/삭제</button>
          </td>
        </tr>
      </c:forEach>
      <c:if test="${empty routingList}">
        <tr><td colspan="8">등록된 공정이 없습니다.</td></tr>
      </c:if>
    </tbody>
  </table>
</section>

<div class="overlay" id="overlay" onclick="closeModals()"></div>

<div class="modal" id="addModal">
  <h3>공정 등록</h3>
  <form id="addForm" enctype="multipart/form-data">
    <label>제품 선택</label>
    <select name="itemId" required>
      <option value="">-- 선택 --</option>
      <c:forEach var="it" items="${itemOptions}">
        <option value="${it.itemId}">${it.itemName}</option>
      </c:forEach>
    </select>

    <label>공정 순서</label>
    <input type="number" name="processStep" required>

    <label>설비 선택</label>
    <select name="equipDetailCode" required>
      <option value="">-- 선택 --</option>
      <c:forEach var="e" items="${equipOptions}">
        <option value="${e.equipDetailCode}">${e.equipName}</option>
      </c:forEach>
    </select>

    <label>공정 이미지</label>
    <input type="file" name="imgFile">

    <label>비고</label>
    <textarea name="remark" rows="3"></textarea>

    <button type="button" class="btn" onclick="saveAdd()">등록</button>
    <button type="button" class="btn" onclick="closeModals()">닫기</button>
  </form>
</div>

<div class="modal" id="editModal">
  <h3>공정 수정 / 삭제</h3>
  <form id="editForm" enctype="multipart/form-data">
    <input type="hidden" name="routingId" id="editRoutingId">

    <label>제품명</label>
    <input type="text" id="editItemName" readonly>

    <label>공정 순서</label>
    <input type="number" name="processStep" id="editProcessStep" required>

    <label>설비 선택</label>
    <select name="equipDetailCode" id="editEquipSelect">
      <option value="">-- 선택 --</option>
      <c:forEach var="e" items="${equipOptions}">
        <option value="${e.equipDetailCode}">${e.equipName}</option>
      </c:forEach>
    </select>

    <label>공정 이미지</label>
    <input type="file" name="imgFile">
    <img id="editPreview" class="preview" src="" alt="">

    <label>비고</label>
    <textarea name="remark" id="editRemark" rows="3"></textarea>

    <button type="button" class="btn" onclick="saveEdit()">수정</button>
    <button type="button" class="btn" style="background:#e33;color:#fff;" onclick="deleteRouting()">삭제</button>
    <button type="button" class="btn" onclick="closeModals()">닫기</button>
  </form>
</div>

<script>
const contextPath = '<c:out value="${pageContext.request.contextPath}" />';
const overlay = document.getElementById("overlay");
const addModal = document.getElementById("addModal");
const editModal = document.getElementById("editModal");

function openAddModal(){
  overlay.style.display="block";
  addModal.style.display="block";
}
function closeModals(){
  overlay.style.display="none";
  addModal.style.display="none";
  editModal.style.display="none";
}

function openEditModal(id){
  fetch(contextPath + "/master/routing/detail?routingId=" + id)
  .then(res=>res.json())
  .then(data=>{
    overlay.style.display="block";
    editModal.style.display="block";

    document.getElementById("editRoutingId").value = data.routingId;
    document.getElementById("editItemName").value = data.itemName;
    document.getElementById("editProcessStep").value = data.processStep;
    document.getElementById("editRemark").value = data.remark || "";
    document.getElementById("editEquipSelect").value = data.equipDetailCode;
    document.getElementById("editPreview").src = data.imgPath ? contextPath + data.imgPath : "";
  })
  .catch(e=>{
    alert("조회 실패");
    console.error(e);
  });
}

function saveAdd(){
  const form = document.getElementById("addForm");
  const fd = new FormData(form);
  fetch(contextPath + "/master/routing/add", {
    method:"POST",
    body:fd
  }).then(res=>res.text())
  .then(result=>{
    if(result==="success"){ alert("✅ 등록되었습니다."); location.reload(); }
    else{ alert("❌ 등록 실패"); }
  });
}

function saveEdit(){
  const form = document.getElementById("editForm");
  const fd = new FormData(form);
  fetch(contextPath + "/master/routing/edit", {
    method:"POST",
    body:fd
  }).then(res=>res.text())
  .then(result=>{
    if(result==="success"){ alert("✅ 수정되었습니다."); location.reload(); }
    else{ alert("❌ 수정 실패"); }
  });
}

function deleteRouting(){
  if(!confirm("정말 삭제하시겠습니까?")) return;
  const id = document.getElementById("editRoutingId").value;
  fetch(contextPath + "/master/routing/delete", {
    method:"POST",
    headers:{ "Content-Type":"application/x-www-form-urlencoded" },
    body:"routingId=" + id
  }).then(res=>res.text())
  .then(result=>{
    if(result==="success"){ alert("✅ 삭제되었습니다."); location.reload(); }
    else{ alert("❌ 삭제 실패"); }
  });
}
</script>
</body>
</html>
