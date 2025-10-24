<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>기준관리 - 공정관리</title>

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

.overlay {
  display: none;
  position: fixed;
  top: 0; left: 0;
  width: 100%; height: 100%;
  background: rgba(0,0,0,0.3);
  z-index: 900;
}

/* ✅ 알림 메세지 토스트 */
.toast {
  position: fixed;
  top: 20px;
  right: 20px;
  background: #333;
  color: #fff;
  padding: 10px 16px;
  border-radius: 6px;
  font-size: 14px;
  opacity: 0;
  pointer-events: none;
  transition: opacity 0.3s, transform 0.3s;
  transform: translateY(-20px);
  z-index: 2000;
}
.toast.show {
  opacity: 1;
  transform: translateY(0);
}
</style>
</head>
<body>

<section class="container">
  <h1>공정관리</h1>

  <form method="get" action="">
    <div class="search-bar">
      <select name="itemId" style="height:30px;">
        <option value="">전체</option>
        <c:forEach var="i" items="${itemOptions}">
          <option value="${i.itemId}" ${selectedItemId == i.itemId ? 'selected':''}>${i.itemName}</option>
        </c:forEach>
      </select>
      <button type="submit" class="btn">조회</button>
      <button type="button" class="btn" style="margin-left:auto;" onclick="openAddModal()">+ 추가</button>
    </div>
  </form>

  <!-- 이후 여기에 Routing 테이블 들어갈 자리 -->
</section>

<div class="overlay" id="overlay" onclick="closeModals()"></div>

<!-- ✅ 토스트 메세지 -->
<div id="toast" class="toast"></div>

<script>
function showToast(msg, color){
  const t = document.getElementById("toast");
  t.textContent = msg;
  t.style.background = color || "#333";
  t.classList.add("show");
  setTimeout(()=>t.classList.remove("show"),2000);
}

// 모달 제어
function openAddModal(){ document.getElementById("overlay").style.display="block"; /* document.getElementById("addModal").style.display="block"; */ }
function closeModals(){
  document.getElementById("overlay").style.display="none";
  const modals = document.querySelectorAll(".modal");
  modals.forEach(m=>m.style.display="none");
}
</script>

</body>
</html>
