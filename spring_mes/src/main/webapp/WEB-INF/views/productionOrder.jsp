<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>생산지시 관리</title>

<%@ include file="/WEB-INF/views/includes/header.jsp"%>

<style>
body{color:#fff;background:#111;font-family:"Pretendard",sans-serif}
section.container{padding:20px}
table{width:100%;border-collapse:collapse;margin-top:10px}
th,td{border:1px solid #444;padding:10px;text-align:center}
th{background:#333;color:#eee}
.btn{padding:6px 10px;border:none;border-radius:6px;cursor:pointer;background:#3B82F6;color:#fff}
.btn:hover{background:#2563EB}
.btn.red{background:#EF4444}.btn.red:hover{background:#DC2626}
.btn.gray{background:#6B7280}
.modal{display:none;position:fixed;z-index:1000;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,.6);justify-content:center;align-items:center}
.modal-content{background:#1e1e1e;padding:20px;width:720px;border-radius:10px;color:#fff;max-height:80vh;overflow:auto}
.modal-content h3{margin-bottom:10px;border-bottom:1px solid #444;padding-bottom:5px}
.modal-content label{display:block;margin-top:10px}
.modal-content select,.modal-content input{width:100%;padding:6px;border:none;border-radius:4px;margin-top:4px}
.close{float:right;cursor:pointer;color:#bbb;font-weight:bold}
.right{display:flex;gap:8px;justify-content:flex-end}
.badge{padding:2px 8px;border-radius:9999px;background:#374151;font-size:12px}
</style>
</head>

<body>
<section class="container">

  <h1>📦 생산목표별 지시 관리</h1>

  <!-- 목표 리스트 -->
  <table>
    <thead>
      <tr><th>ID</th><th>제품명</th><th>목표수량</th><th>기간</th><th>관리</th></tr>
    </thead>
    <tbody>
      <c:forEach var="t" items="${targetList}">
        <tr>
          <td>${t.targetId}</td>
          <td>${t.itemName}</td>
          <td>${t.targetQty}</td>
          <td>
            <fmt:formatDate value="${t.targetStartDate}" pattern="yyyy-MM-dd"/> ~
            <fmt:formatDate value="${t.targetEndDate}" pattern="yyyy-MM-dd"/>
          </td>
          <td class="right">
            <button class="btn" onclick="openAddModal(${t.targetId}, '${t.itemName}', ${t.itemId})">지시생성</button>
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table>

  <hr style="margin:30px 0;border-color:#444">

  <!-- 생산지시 리스트 -->
  <h2>🧾 생산지시 목록</h2>
  <table>
    <thead>
      <tr><th>지시ID</th><th>목표ID</th><th>제품명</th><th>설비명</th><th>수량</th><th>납기일</th><th>상태</th><th>관리</th></tr>
    </thead>
    <tbody>
      <c:choose>
        <c:when test="${not empty orderList}">
          <c:forEach var="o" items="${orderList}">
            <tr>
              <td>${o.orderId}</td>
              <td>${o.targetId}</td>
              <td>${o.itemName}</td>
              <td>${o.equipName}</td>
              <td>${o.orderQty}</td>
              <td><fmt:formatDate value="${o.dueDate}" pattern="yyyy-MM-dd"/></td>
              <td><span class="badge">${o.status}</span></td>
              <td class="right">
                <button class="btn gray" onclick="openRoutingModal(${o.itemId}, '${o.itemName}')">라우팅</button>
                <button class="btn gray" onclick="openBomModal(${o.itemId}, '${o.itemName}')">BOM</button>
                <c:choose>
                  <c:when test="${o.status eq 'PLANNED'}">
                    <button class="btn" onclick="changeStatus(${o.orderId}, ${o.equipId}, 'IN_PROGRESS')">시작</button>
                  </c:when>
                  <c:when test="${o.status eq 'IN_PROGRESS'}">
                    <button class="btn red" onclick="changeStatus(${o.orderId}, ${o.equipId}, 'DONE')">완료</button>
                  </c:when>
                </c:choose>
              </td>
            </tr>
          </c:forEach>
        </c:when>
        <c:otherwise><tr><td colspan="8">등록된 지시가 없습니다.</td></tr></c:otherwise>
      </c:choose>
    </tbody>
  </table>
</section>

<!-- 생산지시 추가 모달 -->
<div class="modal" id="addModal">
  <div class="modal-content">
    <span class="close" onclick="closeModals()">&times;</span>
    <h3>생산지시 생성</h3>

    <form id="addForm">
      <input type="hidden" name="targetId" id="targetId">

      <label>제품 선택</label>
      <select name="itemId" id="itemSelect" required>
        <option value="">선택하세요</option>
      </select>

      <label>설비 선택</label>
      <select name="equipId" id="equipSelect" required>
        <option value="">선택하세요</option>
        <c:forEach var="e" items="${equipList}">
          <option value="${e.equipId}">${e.equipName} (${e.equipStatus})</option>
        </c:forEach>
      </select>

      <label>지시 수량</label>
      <input type="number" name="orderQty" min="1" required>

      <label>납기일</label>
      <input type="date" name="dueDate" required>

      <button type="button" class="btn" style="margin-top:15px;" onclick="saveOrder()">등록</button>
    </form>
  </div>
</div>


<!-- 라우팅 모달 -->
<div class="modal" id="routingModal">
  <div class="modal-content">
    <span class="close" onclick="closeModals()">&times;</span>
    <h3>라우팅 <span id="routingTitle" class="badge"></span></h3>
    <table>
      <thead><tr><th>공정순서</th><th>설명</th><th>이미지</th></tr></thead>
      <tbody id="routingBody"><tr><td colspan="3">불러오는 중...</td></tr></tbody>
    </table>
  </div>
</div>

<!-- BOM 모달 -->
<div class="modal" id="bomModal">
  <div class="modal-content">
    <span class="close" onclick="closeModals()">&times;</span>
    <h3>BOM <span id="bomTitle" class="badge"></span></h3>
    <table>
      <thead><tr><th>BOM ID</th><th>자재코드</th><th>자재명</th><th>소요량</th><th>단위</th></tr></thead>
      <tbody id="bomBody"><tr><td colspan="5">불러오는 중...</td></tr></tbody>
    </table>
  </div>
</div>

<script>
const ctx = "${pageContext.request.contextPath}"; 

function openAddModal(targetId, itemName, itemId){
	  const modal = document.getElementById('addModal');
	  modal.style.display = 'flex';
	  document.getElementById('targetId').value = targetId;

	  // 제품 목록 초기화
	  const itemSelect = document.getElementById('itemSelect');
	  itemSelect.innerHTML = "<option value=''>불러오는 중...</option>";

	  // AJAX 호출: 완제품 + 반제품 목록 불러오기
	  fetch(ctx + "/order/items?itemId=" + itemId)
	    .then(r => r.json())
	    .then(list => {
	      itemSelect.innerHTML = "<option value=''>선택하세요</option>";
	      list.forEach(i => {
	        const opt = document.createElement('option');
	        opt.value = i.itemId;
	        opt.textContent = `${i.itemName} (${i.itemTypeCode})`;
	        itemSelect.appendChild(opt);
	      });
	    })
	    .catch(err => {
	      console.error("제품 목록 로드 실패:", err);
	      itemSelect.innerHTML = "<option value=''>로드 실패</option>";
	    });
	}

function closeModals(){document.querySelectorAll(".modal").forEach(m=>m.style.display="none");}

function saveOrder(){
  const data=Object.fromEntries(new FormData(document.getElementById("addForm")).entries());
  fetch(ctx+"/order/insert",{method:"POST",headers:{"Content-Type":"application/json"},body:JSON.stringify(data)})
    .then(r=>r.text()).then(t=>{
      if(t==="OK"){alert("✅ 등록 완료");location.reload();}
      else alert("⚠ 등록 실패");
    });
}

function changeStatus(orderId,equipId,status){
  if(status==='DONE'&&!confirm("생산 완료로 변경하시겠습니까?"))return;
  fetch(ctx+"/order/updateStatus",{method:"POST",headers:{"Content-Type":"application/json"},body:JSON.stringify({orderId,equipId,status})})
    .then(r=>r.text()).then(t=>{
      if(t==="OK"){alert("✅ 상태 변경: "+status);location.reload();}
      else alert("⚠ 상태 변경 실패");
    });
}

// ✅ 라우팅 모달
function openRoutingModal(itemId, itemName) {
  const modal = document.getElementById('routingModal');
  const body = document.getElementById('routingBody');
  modal.style.display = 'flex';
  document.getElementById('routingTitle').innerText = itemName;
  body.innerHTML = "<tr><td colspan='3'>불러오는 중...</td></tr>";

  fetch(ctx + "/order/routing?itemId=" + itemId)
    .then(res => res.json())
    .then(list => {
      console.log("라우팅 데이터:", list);
      if (!Array.isArray(list) || list.length === 0) {
        body.innerHTML = "<tr><td colspan='3'>라우팅 데이터가 없습니다.</td></tr>";
        return;
      }

      // ✅ 렌더링 확실히 되도록 fragment 사용
      const frag = document.createDocumentFragment();
      list.forEach(r => {
        const tr = document.createElement('tr');

        const td1 = document.createElement('td');
        td1.textContent = r.processStep ?? '-';

        const td2 = document.createElement('td');
        td2.textContent = r.routingRemark ?? '-';

        const td3 = document.createElement('td');
        if (r.routingImgPath) {
          const img = document.createElement('img');
          img.src = ctx + r.routingImgPath;
          img.style.maxWidth = '120px';
          img.style.maxHeight = '80px';
          td3.appendChild(img);
        } else {
          td3.textContent = '-';
        }

        tr.append(td1, td2, td3);
        frag.appendChild(tr);
      });

      // 기존 내용 제거 후 새로 append
      body.innerHTML = '';
      body.appendChild(frag);
    })
    .catch(err => {
      console.error("라우팅 로드 실패:", err);
      body.innerHTML = "<tr><td colspan='3'>로드 실패</td></tr>";
    });
}


// ✅ BOM 모달
// ✅ BOM 모달 (Fragment 버전)
function openBomModal(itemId, itemName) {
  const modal = document.getElementById('bomModal');
  const body = document.getElementById('bomBody');
  modal.style.display = 'flex';
  document.getElementById('bomTitle').innerText = itemName;
  body.innerHTML = "<tr><td colspan='5'>불러오는 중...</td></tr>";

  fetch(ctx + "/order/bom?itemId=" + itemId)
    .then(res => res.json())
    .then(list => {
      console.log("BOM 데이터:", list);
      if (!Array.isArray(list) || list.length === 0) {
        body.innerHTML = "<tr><td colspan='5'>BOM 데이터가 없습니다.</td></tr>";
        return;
      }

      // ✅ 안전 렌더링 (DocumentFragment)
      const frag = document.createDocumentFragment();
      list.forEach(b => {
        const tr = document.createElement('tr');

        const td1 = document.createElement('td');
        td1.textContent = b.bomId ?? '-';

        const td2 = document.createElement('td');
        td2.textContent = b.childItem ?? '-';

        const td3 = document.createElement('td');
        td3.textContent = b.childItemName ?? '-';

        const td4 = document.createElement('td');
        td4.textContent = b.requiredQty ?? '-';

        const td5 = document.createElement('td');
        td5.textContent = b.childUnit ?? '-';

        tr.append(td1, td2, td3, td4, td5);
        frag.appendChild(tr);
      });

      body.innerHTML = '';
      body.appendChild(frag);
    })
    .catch(err => {
      console.error("BOM 로드 실패:", err);
      body.innerHTML = "<tr><td colspan='5'>로드 실패</td></tr>";
    });
}

</script>
</body>
</html>
