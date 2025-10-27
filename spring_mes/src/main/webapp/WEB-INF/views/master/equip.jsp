<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>기준관리 - 설비</title>

<%@ include file="/WEB-INF/views/includes/header.jsp"%>
<%@ include file="/WEB-INF/views/includes/2header.jsp"%>

<style>
section.container {
	padding: 20px;
	color: white;
}

h1 {
	margin-bottom: 20px;
}

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

th {
	background: #f5f5f5;
	color: black;
}

.btn {
	padding: 6px 10px;
	margin: 2px;
	cursor: pointer;
	border: none;
	border-radius: 5px;
	background: #3B82F6;
	color: white;
}

.btn:hover {
	background: #2563EB;
}

.search-bar {
	display: flex;
	align-items: center;
	gap: 8px;
	margin-bottom: 10px;
}

.modal {
	display: none;
	position: fixed;
	z-index: 999;
	left: 0;
	top: 0;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, 0.5);
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

.modal-content select, .modal-content input {
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
</style>
</head>

<body>
	<section class="container">
		<h1>설비 기준관리</h1>

		<!-- 🔍 검색 영역 -->
		<form method="get" action="">
			<div class="search-bar">
				<select name="detailCode" style="height: 30px;">
					<option value="">전체</option>
					<c:forEach var="d" items="${detailList}">
						<option value="${d.detailCode}"
							${detailCode == d.detailCode ? 'selected' : ''}>
							[${d.codeId}] ${d.detailName}</option>
					</c:forEach>
				</select> <input type="text" name="keyword" value="${keyword}"
					placeholder="설비명 검색" style="height: 28px;">
				<button type="submit" class="btn">검색</button>
				<button type="button" class="btn" style="margin-left: auto;"
					onclick="openAddModal()">+ 추가</button>
			</div>
		</form>

		<!-- 📋 테이블 -->
		<table>
			<thead>
				<tr>
					<th>ID</th>
					<th>설비코드</th>
					<th>설비명</th>
					<th>시간당 생산량</th>
					<th>정비시간</th>
					<th>하루 가동시간</th>
					<th>제품군</th>
					<th>활성여부</th>
					<th>제품군</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="e" items="${equipList}">
					<tr>
						<td>${e.equipId}</td>
						<td>${e.equipCode}</td>
						<td>${e.equipName}</td>
						<td>${e.stdCapacity}</td>
						<td>${e.maintenanceHr}</td>
						<td>${e.dailyCapacity}</td>
						<td>${e.detailName}</td>
						<td>${e.activeYn eq 'Y' ? '활성' : '비활성'}</td>
						<td>
							<button class="btn"
								onclick="openEditModal(${e.equipId}, '${e.equipCode}', '${e.equipName}', ${e.stdCapacity}, ${e.maintenanceHr}, ${e.dailyCapacity}, '${e.detailCode}', '${e.activeYn}')">
								수정/삭제</button>
						</td>
					</tr>
				</c:forEach>
				<c:if test="${empty equipList}">
					<tr>
						<td colspan="9">등록된 설비가 없습니다.</td>
					</tr>
				</c:if>
			</tbody>
		</table>
	</section>

	<!-- ================= 모달 영역 ================= -->

	<div class="modal" id="addModal">
		<div class="modal-content">
			<span class="close" onclick="closeModals()">&times;</span>
			<h3>설비 등록</h3>
			<form id="addForm">
				<label>설비 코드</label> <input type="text" name="equipCode" required
					placeholder="예: EQP-001"> <label>설비명</label> <input
					type="text" name="equipName" required placeholder="설비명 입력">

				<label>시간당 생산량(/hr)</label> <input type="number" name="stdCapacity"
					step="0.01" required> <label>정비시간 (hr)</label> <input
					type="number" name="maintenanceHr" step="0.01"> <label>일일 가동시간(hr)
					</label> <input type="number" name="dailyCapacity" step="0.01">

				<label>제품군</label> <select name="detailCode" required>
					<option value="">선택</option>
					<c:forEach var="g" items="${productGroupList}">
						<option value="${g.detailCode}">${g.detailName}
						</option>
					</c:forEach>
				</select> <label>활성여부</label> <select name="activeYn">
					<option value="Y">Y</option>
					<option value="N">N</option>
				</select>

				<button type="button" class="btn" style="margin-top: 15px;"
					onclick="saveAdd()">등록</button>
			</form>
		</div>
	</div>

	<!-- 🔵 설비 수정/삭제 -->
	<div class="modal" id="editModal">
		<div class="modal-content">
			<span class="close" onclick="closeModals()">&times;</span>
			<h3>설비 수정 / 삭제</h3>
			<form id="editForm">
				<input type="hidden" name="equipId" id="editEquipId"> <label>설비
					코드</label> <input type="text" name="equipCode" id="editEquipCode" required>

				<label>설비명</label> <input type="text" name="equipName"
					id="editEquipName" required> <label>시간당 생산량(/hr)</label> <input
					type="number" name="stdCapacity" id="editStdCapacity" step="0.01">

				<label>정비시간 (hr)</label> <input type="number" name="maintenanceHr"
					id="editMaintenanceHr" step="0.01"> <label>일일 가동시간(hr)</label> <input
					type="number" name="dailyCapacity" id="editDailyCapacity"
					step="0.01"> <label>제품군</label> <select name="detailCode"
					required>
					<option value="">선택</option>
					<c:forEach var="g" items="${productGroupList}">
						<option value="${g.detailCode}">${g.detailName}</option>
					</c:forEach>
				</select> <label>활성여부</label> <select name="activeYn" id="editActiveYn">
					<option value="Y">Y</option>
					<option value="N">N</option>
				</select>

				<button type="button" class="btn" style="margin-top: 10px;"
					onclick="saveEdit()">수정</button>
				<button type="button" class="btn"
					style="background: #EF4444; margin-top: 10px;"
					onclick="deleteEdit()">삭제</button>
			</form>
		</div>
	</div>

	<script>
function openAddModal(){ document.getElementById("addModal").style.display="flex"; }
function openEditModal(id, code, name, std, maint, daily, detail, active){
  document.getElementById("editModal").style.display="flex";
  document.getElementById("editEquipId").value = id;
  document.getElementById("editEquipCode").value = code;
  document.getElementById("editEquipName").value = name;
  document.getElementById("editStdCapacity").value = std;
  document.getElementById("editMaintenanceHr").value = maint;
  document.getElementById("editDailyCapacity").value = daily;
  document.getElementById("editDetailCode").value = detail;
  document.getElementById("editActiveYn").value = active;
}
function closeModals(){
  document.querySelectorAll(".modal").forEach(m => m.style.display="none");
}
window.onclick = e => {
  document.querySelectorAll('.modal').forEach(m=>{ if(e.target === m) m.style.display="none"; });
};

// 🔹 등록
function saveAdd(){
  const form = document.getElementById("addForm");
  const data = new URLSearchParams(new FormData(form)).toString();
  fetch("${pageContext.request.contextPath}/master/equip/add", {
    method:"POST",
    headers:{"Content-Type":"application/x-www-form-urlencoded"},
    body:data
  }).then(res=>res.text()).then(result=>{
    if(result.includes("dupError") || result.includes("중복")){ alert("⚠ 중복된 설비코드입니다."); return; }
    if(!result.includes("redirect")){ alert("✅ 등록되었습니다."); location.reload(); }
  });
}

// 🔹 수정
function saveEdit(){
  const form = document.getElementById("editForm");
  const data = new URLSearchParams(new FormData(form)).toString();
  fetch("${pageContext.request.contextPath}/master/equip/edit", {
    method:"POST",
    headers:{"Content-Type":"application/x-www-form-urlencoded"},
    body:data
  }).then(res=>res.text()).then(result=>{
    if(result!=="redirect"){ alert("✅ 수정되었습니다."); location.reload(); }
  });
}

// 🔹 삭제
function deleteEdit(){
  const id = document.getElementById("editEquipId").value;
  if(!confirm("정말 삭제하시겠습니까?")) return;
  fetch("${pageContext.request.contextPath}/master/equip/delete", {
    method:"POST",
    headers:{"Content-Type":"application/x-www-form-urlencoded"},
    body:"equipId="+id
  }).then(res=>res.text()).then(result=>{
    alert("✅ 삭제되었습니다."); location.reload();
  });
}
</script>

</body>
</html>
