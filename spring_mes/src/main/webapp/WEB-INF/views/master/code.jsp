<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>기준관리-코드</title>

<%@ include file="/WEB-INF/views/includes/header.jsp" %>
<%@ include file="/WEB-INF/views/includes/2header.jsp" %>
</head>

<body>

<div style="display:flex; justify-content:space-between; align-items:center;">
  <h2>코드 마스터 관리</h2>
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
          <button type="button" class="btnMasterManage"
                  data-id="${m.codeId}" data-name="${m.codeName}">
            수정/삭제
          </button>
        </td>
      </tr>
    </c:forEach>
    <c:if test="${empty masterList}">
      <tr><td colspan="3">데이터가 없습니다.</td></tr>
    </c:if>
  </tbody>
</table>

<!--동현이형-->
<div id="masterAddModal" class="modal" style="display:none;">
  <form action="${pageContext.request.contextPath}/master/code/master/insert" method="post">
    <h3>마스터 코드 등록</h3>
    <label>코드 ID:</label><br>
    <input type="text" name="codeId" required><br>
    <label>코드 이름:</label><br>
    <input type="text" name="codeName" required><br>
    <button type="submit">등록</button>
    <button type="button" class="btnClose">닫기</button>
  </form>
</div>

<!--동현이형-->
<div id="masterManageModal" class="modal" style="display:none;">
  <form id="masterManageForm" method="post">
    <h3>마스터 코드 수정 / 삭제</h3>
    <input type="hidden" name="codeId" id="editCodeId">
    <label>코드 이름:</label><br>
    <input type="text" name="codeName" id="editCodeName" required><br><br>
    <button type="submit" id="btnMasterUpdate">수정</button>
    <button type="button" id="btnMasterDelete">삭제</button>
    <button type="button" class="btnClose">닫기</button>
  </form>
</div>

<hr>

<div style="display:flex; justify-content:space-between; align-items:center;">
  <h2>코드 디테일 관리</h2>
  <button id="btnDetailAdd">추가</button>
</div>

<div id="search-box">
  <form action="${pageContext.request.contextPath}/master/code" method="get">
    <select name="codeId" id="detailMasterSelect">
      <option value="">-- 마스터 선택 --</option>
      <c:forEach var="m" items="${masterList}">
        <option value="${m.codeId}" ${m.codeId == codeId ? 'selected' : ''}>
          ${m.codeId} (${m.codeName})
        </option>
      </c:forEach>
    </select>
    <input type="text" name="keyword" placeholder="상세코드 또는 이름 검색" value="${keyword}">
    <button type="submit">검색</button>
  </form>
</div>

<!--동현이형 디테일 테이블-->
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
          <button type="button" class="btnDetailManage"
                  data-code="${d.detailCode}"
                  data-name="${d.detailName}"
                  data-use="${d.detailUseYn}">
            수정/삭제
          </button>
        </td>
      </tr>
    </c:forEach>
    <c:if test="${empty detailList}">
      <tr><td colspan="4">데이터가 없습니다.</td></tr>
    </c:if>
  </tbody>
</table>

<!-- 동현이형 디테일 -->
<div id="detailAddModal" class="modal" style="display:none;">
  <form action="${pageContext.request.contextPath}/master/code/detail/insert" method="post">
    <h3>디테일 코드 등록</h3>
    <label>마스터 코드:</label><br>
    <select name="codeId" required>
      <c:forEach var="m" items="${masterList}">
        <option value="${m.codeId}">${m.codeId} (${m.codeName})</option>
      </c:forEach>
    </select><br>
    <label>상세 코드:</label><br>
    <input type="text" name="detailCode" required><br>
    <label>상세 이름:</label><br>
    <input type="text" name="detailName" required><br>
    <label>사용 여부:</label><br>
    <select name="detailUseYn">
      <option value="Y">Y</option>
      <option value="N">N</option>
    </select><br>
    <button type="submit">등록</button>
    <button type="button" class="btnClose">닫기</button>
  </form>
</div>

<!-- 동현이형 수정/삭제 모달  -->
<div id="detailManageModal" class="modal" style="display:none;">
  <form id="detailManageForm" method="post">
    <h3>디테일 코드 수정 / 삭제</h3>
    <input type="hidden" name="detailCode" id="editDetailCode">
    <label>상세 이름:</label><br>
    <input type="text" name="detailName" id="editDetailName" required><br>
    <label>사용 여부:</label><br>
    <select name="detailUseYn" id="editDetailUseYn">
      <option value="Y">Y</option>
      <option value="N">N</option>
    </select><br><br>
    <button type="submit" id="btnDetailUpdate">수정</button>
    <button type="button" id="btnDetailDelete">삭제</button>
    <button type="button" class="btnClose">닫기</button>
  </form>
</div>

<script>
const contextPath = '${pageContext.request.contextPath}';

// 공통 닫기
document.querySelectorAll('.btnClose').forEach(btn =>
  btn.addEventListener('click', () => btn.closest('.modal').style.display = 'none')
);

// 마스터 추가 버튼
document.getElementById('btnMasterAdd').addEventListener('click', () => {
  document.getElementById('masterAddModal').style.display = 'block';
});

// 마스터 행 수정/삭제 버튼
document.querySelectorAll('.btnMasterManage').forEach(btn => {
  btn.addEventListener('click', () => {
    document.getElementById('editCodeId').value = btn.dataset.id;
    document.getElementById('editCodeName').value = btn.dataset.name;
    document.getElementById('masterManageModal').style.display = 'block';
  });
});

// 마스터 수정
document.getElementById('btnMasterUpdate').addEventListener('click', e => {
  e.preventDefault();
  const form = document.getElementById('masterManageForm');
  form.action = contextPath + '/master/code/master/update';
  form.submit();
});

// 마스터 삭제
document.getElementById('btnMasterDelete').addEventListener('click', e => {
  e.preventDefault();
  const id = document.getElementById('editCodeId').value;
  const name = document.getElementById('editCodeName').value;
  if (confirm(`'${id} (${name})' 코드를 삭제하시겠습니까?`)) {
    const form = document.getElementById('masterManageForm');
    form.action = contextPath + '/master/code/master/delete';
    form.submit();
  }
});

// 디테일 추가 버튼
document.getElementById('btnDetailAdd').addEventListener('click', () => {
  document.getElementById('detailAddModal').style.display = 'block';
});

// 디테일 행 수정/삭제 버튼
document.querySelectorAll('.btnDetailManage').forEach(btn => {
  btn.addEventListener('click', () => {
    document.getElementById('editDetailCode').value = btn.dataset.code;
    document.getElementById('editDetailName').value = btn.dataset.name;
    document.getElementById('editDetailUseYn').value = btn.dataset.use;
    document.getElementById('detailManageModal').style.display = 'block';
  });
});

// 디테일 수정
document.getElementById('btnDetailUpdate').addEventListener('click', e => {
  e.preventDefault();
  const form = document.getElementById('detailManageForm');
  form.action = contextPath + '/master/code/detail/update';
  form.submit();
});

// 디테일 삭제
document.getElementById('btnDetailDelete').addEventListener('click', async e => {
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
});
</script>

</body>
</html>
