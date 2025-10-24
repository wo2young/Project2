<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>기준관리 - 제품</title>
<%@ include file="/WEB-INF/views/includes/header.jsp"%>
<%@ include file="/WEB-INF/views/includes/2header.jsp"%>

<style>
.search-bar {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin: 20px 0;
}

.search-bar input, .search-bar select {
	padding: 6px;
	font-size: 14px;
}


.btn:hover {
	background: #2563EB;
}

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

th {
	background: #f5f5f5;
}
/* 모달 */
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
	width: 400px;
	border-radius: 10px;
}

.modal-content label {
	display: block;
	margin-top: 10px;
	font-weight: bold;
}

.close {
	float: right;
	cursor: pointer;
	font-weight: bold;
}

#noCodeMsg {
	color: gray;
	font-size: 13px;
	margin-top: 5px;
	display: none;
}
</style>
</head>

<body>
	<h1>제품 관리</h1>

	<div class="search-bar">
		<form action="${pageContext.request.contextPath}/master/item"
			method="get">
			<input type="text" name="keyword" placeholder="제품명 또는 코드 검색"
				value="${param.keyword}"> <select name="typeFilter">
				<option value="">전체 코드</option>
				<c:forEach var="m" items="${masterCodes}">
					<option value="${m.codeId}"
						${param.typeFilter == m.codeId ? 'selected' : ''}>
						${m.codeId} (${m.codeName})</option>
				</c:forEach>
			</select>
			<button type="submit" class="btn">검색</button>
		</form>
		<button class="btn" id="btnAdd">제품 등록</button>
	</div>
	<!-- 동현이형 이게 메인디쉬~ -->
	<table>
		<thead>
			<tr>
				<th>ID</th>
				<th>제품명</th>
				<th>로트 Prefix</th>
				<th>제품유형</th>
				<th>상세코드</th>
				<th>단위</th>
				<th>유통기한</th>
				<th>작업</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="i" items="${list}">
				<tr>
					<td>${i.itemId}</td>
					<td>${i.itemName}</td>
					<td>${i.lotPrefix}</td>
					<td>${i.itemTypeCode}</td>
					<td>${i.detailCode}</td>
					<td>${i.unit}</td>
					<td>${i.expDate}</td>
					<td>
						<button class="btn btnEdit" data-id="${i.itemId}"
							data-name="${i.itemName}" data-prefix="${i.lotPrefix}"
							data-type="${i.itemTypeCode}" data-detail="${i.detailCode}"
							data-unit="${i.unit}" data-exp="${i.expDate}">수정/삭제</button>
					</td>
				</tr>
			</c:forEach>
			<c:if test="${empty list}">
				<tr>
					<td colspan="8">등록된 제품이 없습니다.</td>
				</tr>
			</c:if>
		</tbody>
	</table>

	<!-- 동현이형 이게 등록 모달 -->
	<div class="modal" id="modalAdd">
		<div class="modal-content">
			<span class="close" id="closeAdd">&times;</span>
			<h3>제품 등록</h3>
			<form action="${pageContext.request.contextPath}/master/item/add"
				method="post">
				<label>제품명</label> <input type="text" name="itemName" required>

				<label>로트 Prefix</label> <input type="text" name="lotPrefix"
					required> <label>제품유형</label> <select id="itemTypeSelect"
					name="itemTypeCode" required>
					<option value="">선택하세요</option>
					<c:forEach var="m" items="${masterCodes}">
						<option value="${m.codeId}">${m.codeName}</option>
					</c:forEach>
				</select> <label>상세코드</label> <select id="detailCodeSelect" name="detailCode"
					required>
					<option value="">제품 유형을 먼저 선택하세요</option>
				</select>
				<p id="noCodeMsg">등록된 코드가 없습니다.</p>

				<label>단위</label> <input type="text" name="unit"> <label>유통기한(일)</label>
				<input type="number" name="expDate">

				<button type="submit" class="btn" style="margin-top: 15px;">등록</button>
			</form>
		</div>
	</div>

	<!-- 동현이형 이건 수정/삭제 모달 -->
	<div class="modal" id="modalEdit">
		<div class="modal-content">
			<span class="close" id="closeEdit">&times;</span>
			<h3>제품 수정/삭제</h3>
			<form id="editForm" method="post">
				<input type="hidden" name="itemId" id="editItemId"> <label>제품명</label>
				<input type="text" name="itemName" id="editItemName" required>

				<label>로트 Prefix</label> <input type="text" name="lotPrefix"
					id="editLotPrefix" required> <label>제품유형</label> <input
					type="text" name="itemTypeCode" id="editType" readonly> <label>상세코드</label>
				<input type="text" name="detailCode" id="editDetail" readonly>

				<label>단위</label> <input type="text" name="unit" id="editUnit">

				<label>유통기한(일)</label> <input type="number" name="expDate"
					id="editExp">

				<button type="submit"
					formaction="${pageContext.request.contextPath}/master/item/update"
					class="btn" style="margin-top: 10px;">수정</button>
				<button type="submit"
					formaction="${pageContext.request.contextPath}/master/item/delete"
					class="btn" style="background: #EF4444; margin-top: 10px;">삭제</button>
			</form>
		</div>
	</div>

	<script>
const contextPath = '<c:out value="${pageContext.request.contextPath}" />';

const modalAdd = document.getElementById("modalAdd");
const modalEdit = document.getElementById("modalEdit");
document.getElementById("btnAdd").onclick = () => modalAdd.style.display = "flex";
document.getElementById("closeAdd").onclick = () => modalAdd.style.display = "none";
document.getElementById("closeEdit").onclick = () => modalEdit.style.display = "none";
window.onclick = e => {
	if (e.target === modalAdd) modalAdd.style.display = "none";
	if (e.target === modalEdit) modalEdit.style.display = "none";
};

document.querySelectorAll(".btnEdit").forEach(btn => {
	btn.addEventListener("click", () => {
		modalEdit.style.display = "flex";
		document.getElementById("editItemId").value = btn.dataset.id;
		document.getElementById("editItemName").value = btn.dataset.name;
		document.getElementById("editLotPrefix").value = btn.dataset.prefix;
		document.getElementById("editType").value = btn.dataset.type;
		document.getElementById("editDetail").value = btn.dataset.detail;
		document.getElementById("editUnit").value = btn.dataset.unit;
		document.getElementById("editExp").value = btn.dataset.exp;
	});
});

document.getElementById("itemTypeSelect").addEventListener("change", function() {
	const codeId = this.value;
	const detailSelect = document.getElementById("detailCodeSelect");
	const msg = document.getElementById("noCodeMsg");

	detailSelect.innerHTML = "";
	msg.style.display = "none";

	if (!codeId) {
		detailSelect.innerHTML = "<option value=''>제품 유형을 먼저 선택하세요</option>";
		return;
	}

	fetch(contextPath + "/master/item/detail-codes?codeId=" + encodeURIComponent(codeId) + "&t=" + Date.now())
		.then(res => res.json())
		.then(data => {
			if (data.length === 0) {
				msg.style.display = "block";
				msg.textContent = "등록 가능한 상세코드가 없습니다.";
				detailSelect.innerHTML = "<option value=''>선택 불가</option>";
			} else {
				data.forEach(d => {
					const opt = document.createElement("option");
					opt.value = d.detailCode;
					opt.textContent = d.detailCode + " (" + d.detailName + ")";
					detailSelect.appendChild(opt);
				});
			}
		})
		.catch(err => {
			console.error("상세 코드 조회 실패:", err);
			msg.style.display = "block";
			msg.textContent = "조회 중 오류가 발생했습니다.";
		});
});
</script>

</body>
</html>
