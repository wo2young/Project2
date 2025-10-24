<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>기준관리 - 코드</title>

<%@ include file="/WEB-INF/views/includes/header.jsp"%>
<%@ include file="/WEB-INF/views/includes/2header.jsp"%>

<style>
h1, h2 {
	margin-top: 20px;
}

/* 버튼 */
button {
	padding: 6px 10px;
	background: #3B82F6;
	color: white;
	border: none;
	border-radius: 5px;
	cursor: pointer;
}

button:hover {
	background: #2563EB;
}

/* 테이블 */
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

/* 🔵 모달 통일 스타일 (item.jsp 기준) */
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
	color: white;
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
	color: white;
}
</style>
</head>

<body>
	<h1>코드 관리</h1>

	<!-- ==================== 마스터 영역 ==================== -->
	<div
		style="display: flex; justify-content: space-between; align-items: center;">
		<h2>마스터 코드</h2>
		<button id="btnMasterAdd">추가</button>
	</div>

	<table>
		<thead>
			<tr>
				<th>코드 ID</th>
				<th>코드 이름</th>
				<th>관리</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="m" items="${masterList}">
				<tr>
					<td>${m.codeId}</td>
					<td>${m.codeName}</td>
					<td>
						<button class="btnMasterManage" data-id="${m.codeId}"
							data-name="${m.codeName}">수정/삭제</button>
					</td>
				</tr>
			</c:forEach>
			<c:if test="${empty masterList}">
				<tr>
					<td colspan="3">데이터가 없습니다.</td>
				</tr>
			</c:if>
		</tbody>
	</table>

	<!-- 🔵 마스터 등록 모달 -->
	<div class="modal" id="masterAddModal">
		<div class="modal-content">
			<span class="close" id="closeMasterAdd">&times;</span>
			<h3>마스터 코드 등록</h3>
			<form
				action="${pageContext.request.contextPath}/master/code/master/insert"
				method="post">
				<label>코드 ID</label> <input type="text" name="codeId" required>
				<label>코드 이름</label> <input type="text" name="codeName" required>
				<button type="submit" style="margin-top: 10px;">등록</button>
			</form>
		</div>
	</div>

	<!-- 🔵 마스터 수정/삭제 모달 -->
	<div class="modal" id="masterManageModal">
		<div class="modal-content">
			<span class="close" id="closeMasterEdit">&times;</span>
			<h3>마스터 코드 수정 / 삭제</h3>
			<form id="masterManageForm" method="post">
				<input type="hidden" name="codeId" id="editCodeId"> <label>코드
					이름</label> <input type="text" name="codeName" id="editCodeName" required>
				<button type="submit" id="btnMasterUpdate" style="margin-top: 10px;">수정</button>
				<button type="button" id="btnMasterDelete"
					style="background: #EF4444; margin-top: 10px;">삭제</button>
			</form>
		</div>
	</div>

	<hr>

	<!-- ==================== 디테일 영역 ==================== -->
	<div
		style="display: flex; justify-content: space-between; align-items: center;">
		<h2>디테일 코드</h2>
		<button id="btnDetailAdd">추가</button>
	</div>

	<form action="${pageContext.request.contextPath}/master/code"
		method="get" style="margin-top: 10px;">
		<select name="codeId" id="detailMasterSelect">
			<option value="">-- 마스터 선택 --</option>
			<c:forEach var="m" items="${masterList}">
				<option value="${m.codeId}" ${m.codeId == codeId ? 'selected' : ''}>${m.codeId}
					(${m.codeName})</option>
			</c:forEach>
		</select> <input type="text" name="keyword" placeholder="상세코드 또는 이름 검색"
			value="${keyword}">
		<button type="submit">검색</button>
	</form>

	<table>
		<thead>
			<tr>
				<th>상세코드</th>
				<th>상세명</th>
				<th>활성여부</th>
				<th>관리</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="d" items="${detailList}">
				<tr>
					<td>${d.detailCode}</td>
					<td>${d.detailName}</td>
					<td>${d.detailUseYn}</td>
					<td>
						<button class="btnDetailManage" data-code="${d.detailCode}"
							data-name="${d.detailName}" data-use="${d.detailUseYn}">수정/삭제</button>
					</td>
				</tr>
			</c:forEach>
			<c:if test="${empty detailList}">
				<tr>
					<td colspan="4">데이터가 없습니다.</td>
				</tr>
			</c:if>
		</tbody>
	</table>

	<!-- 🔵 디테일 등록 모달 -->
	<div class="modal" id="detailAddModal">
		<div class="modal-content">
			<span class="close" id="closeDetailAdd">&times;</span>
			<h3>디테일 코드 등록</h3>
			<form
				action="${pageContext.request.contextPath}/master/code/detail/insert"
				method="post">
				<label>마스터 코드</label> <select name="codeId" required>
					<c:forEach var="m" items="${masterList}">
						<option value="${m.codeId}">${m.codeId}(${m.codeName})</option>
					</c:forEach>
				</select> <label>상세 코드</label> <input type="text" name="detailCode" required>
				<label>상세 이름</label> <input type="text" name="detailName" required>
				<label>사용 여부</label> <select name="detailUseYn">
					<option value="Y">Y</option>
					<option value="N">N</option>
				</select>
				<button type="submit" style="margin-top: 10px;">등록</button>
			</form>
		</div>
	</div>

	<!-- 🔵 디테일 수정/삭제 모달 -->
	<div class="modal" id="detailManageModal">
		<div class="modal-content">
			<span class="close" id="closeDetailEdit">&times;</span>
			<h3>디테일 코드 수정 / 삭제</h3>
			<form id="detailManageForm" method="post">
				<input type="hidden" name="detailCode" id="editDetailCode">
				<label>상세 이름</label> <input type="text" name="detailName"
					id="editDetailName" required> <label>사용 여부</label> <select
					name="detailUseYn" id="editDetailUseYn">
					<option value="Y">Y</option>
					<option value="N">N</option>
				</select>
				<button type="submit" id="btnDetailUpdate" style="margin-top: 10px;">수정</button>
				<button type="button" id="btnDetailDelete"
					style="background: #EF4444; margin-top: 10px;">삭제</button>
			</form>
		</div>
	</div>

	<script>
const contextPath = '${pageContext.request.contextPath}';

// ==================== 공통 모달 닫기 ====================
document.querySelectorAll('.close').forEach(btn =>
  btn.addEventListener('click', () => btn.closest('.modal').style.display = 'none')
);
window.onclick = e => {
  document.querySelectorAll('.modal').forEach(modal => {
    if (e.target === modal) modal.style.display = 'none';
  });
};

// ==================== 마스터 ====================
document.getElementById('btnMasterAdd').onclick = () =>
  document.getElementById('masterAddModal').style.display = 'flex';

document.querySelectorAll('.btnMasterManage').forEach(btn => {
  btn.addEventListener('click', () => {
    document.getElementById('editCodeId').value = btn.dataset.id;
    document.getElementById('editCodeName').value = btn.dataset.name;
    document.getElementById('masterManageModal').style.display = 'flex';
  });
});

document.getElementById('btnMasterUpdate').onclick = e => {
  e.preventDefault();
  const form = document.getElementById('masterManageForm');
  form.action = contextPath + '/master/code/master/update';
  form.submit();
};
document.getElementById('btnMasterDelete').onclick = e => {
  e.preventDefault();
  const id = document.getElementById('editCodeId').value;
  const name = document.getElementById('editCodeName').value;
  if (confirm(`'${id} (${name})' 코드를 삭제하시겠습니까?`)) {
    const form = document.getElementById('masterManageForm');
    form.action = contextPath + '/master/code/master/delete';
    form.submit();
  }
};

// ==================== 디테일 ====================
document.getElementById('btnDetailAdd').onclick = () =>
  document.getElementById('detailAddModal').style.display = 'flex';

document.querySelectorAll('.btnDetailManage').forEach(btn => {
  btn.addEventListener('click', () => {
    document.getElementById('editDetailCode').value = btn.dataset.code;
    document.getElementById('editDetailName').value = btn.dataset.name;
    document.getElementById('editDetailUseYn').value = btn.dataset.use;
    document.getElementById('detailManageModal').style.display = 'flex';
  });
});

document.getElementById('btnDetailUpdate').onclick = e => {
  e.preventDefault();
  const form = document.getElementById('detailManageForm');
  form.action = contextPath + '/master/code/detail/update';
  form.submit();
};

document.getElementById('btnDetailDelete').onclick = async e => {
  e.preventDefault();
  const code = document.getElementById('editDetailCode').value;
  const name = document.getElementById('editDetailName').value;

  try {
    const res = await fetch(contextPath + '/master/code/detail/checkRefAll?detailCode=' + encodeURIComponent(code));
    const refCount = await res.json();
    if (refCount > 0) {
      alert(`삭제 불가: '${name}' 코드는 다른 기준 테이블에서 참조 중입니다.`);
      return;
    }
    if (confirm(`코드를 삭제하시겠습니까?`)) {
      const form = document.getElementById('detailManageForm');
      form.action = contextPath + '/master/code/detail/delete';
      form.submit();
    }
  } catch (err) {
    console.error(err);
    alert('삭제 중 오류가 발생했습니다.');
  }
};
</script>

</body>
</html>
