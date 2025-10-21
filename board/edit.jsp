<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>글 수정</title>
  <style>
    :root{
      --bg:#0a0f1a; --panel:#0f1626; --line:#1f2b45;
      --text:#e6ebff; --muted:#a7b0c5; --input:#1a202c;
      --accent:#f59e0b; --accent-hover:#d97706;
      --blue:#1e3a8a; --blue-hover:#2563eb; --hover:#111a2b;
      --header-h: 64px;
    }
    *{box-sizing:border-box}
    html, body{margin:0; padding:0; background:var(--bg); color:var(--text);
      font-family:system-ui,Segoe UI,Arial,'Noto Sans KR','Apple SD Gothic Neo',sans-serif;
      min-height:100dvh;}
    main.wrap{max-width:760px; margin:0 auto; padding:calc(var(--header-h) + 16px) 16px 24px;}
    h2{text-align:center; font-size:22px; margin:0 0 20px; font-weight:800}
    .editor{background:var(--panel); border:1px solid var(--line); border-radius:12px; padding:20px;}
    label{display:block; margin:12px 0 6px; font-weight:600; color:var(--muted);}
    input[type=text], textarea, select{
      width:100%; padding:10px; border:1px solid var(--line); border-radius:8px;
      background:var(--input); color:var(--text); font-size:14px;
    }
    textarea{resize:vertical}
    input:focus, textarea:focus, select:focus{
      outline:none; border-color:var(--accent);
      box-shadow:0 0 0 2px rgba(245,158,11,.2);
    }
    .inline{display:flex; align-items:center; gap:6px; color:var(--text); margin-top:12px; font-weight:600;}
    .inline input[type=checkbox]{ transform:scale(1.1);}
    .btn{display:inline-block; padding:8px 14px; border:1px solid var(--line); border-radius:10px;
      text-decoration:none; color:var(--text); background:var(--panel); transition:.15s;
      min-width:90px; text-align:center; font-weight:700; cursor:pointer;}
    .btn:hover{background:var(--hover); transform:translateY(-1px);}
    .btn-primary{background:var(--accent); border-color:var(--accent); color:#111827;}
    .btn-primary:hover{background:var(--accent-hover); border-color:var(--accent-hover);}
    .btn-cancel{background:var(--blue); border-color:var(--blue); color:#e6ebff;}
    .btn-cancel:hover{background:var(--blue-hover); border-color:var(--blue-hover);}
    .actions{margin-top:18px; display:flex; gap:10px; justify-content:flex-end;}
  </style>
</head>
<body>

  <jsp:include page="/WEB-INF/views/includes/header.jsp"></jsp:include>

  <main class="wrap">
    <h2>글 수정</h2>

    <c:set var="ctx" value="${pageContext.request.contextPath}" />
    <c:set var="p" value="${post}" />

    <form class="editor" 
          method="post" 
          action="${ctx}/board/edit" 
          enctype="multipart/form-data"
          onsubmit="return v();">

      <input type="hidden" name="postId" value="${p.postId}" />

      <label>카테고리</label>
      <select name="categoryId" required>
        <c:forEach var="c" items="${categories}">
          <option value="${c.categoryId}" ${c.categoryId == p.categoryId ? 'selected' : ''}>
            <c:out value="${c.categoryName}"/>
          </option>
        </c:forEach>
      </select>

      <label>제목</label>
      <input type="text" name="title" value="${p.title}" placeholder="제목을 입력하세요" required />

      <label>내용</label>
      <textarea name="content" rows="10" placeholder="내용을 입력하세요" required>${p.content}</textarea>

      <!-- 첨부 파일 수정 섹션 -->
      <label>첨부파일</label>
      <input type="file" name="file" accept="*/*" />

      <!-- 기존 링크가 있을 경우 자동 표시 -->
      <label>첨부파일 링크</label>
      <input type="text" name="fileUrl"
             placeholder="Google Drive 또는 MyBox 링크 입력"
             value="${p.fileUrl != null ? p.fileUrl : ''}" />

      <label class="inline">
        <input type="checkbox" name="isNotice" value="Y" ${p.isNotice == 'Y' ? 'checked' : ''}/>
        공지글
      </label>

      <div class="actions">
        <button class="btn btn-primary" type="submit">저장</button>
        <a class="btn btn-cancel" href="${ctx}/board/view?id=${p.postId}">취소</a>
      </div>
    </form>
  </main>

  <script>
    function v(){
      const f=document.forms[0];
      if(!f.title.value.trim()){
        alert('제목을 입력하세요');
        f.title.focus();
        return false;
      }
      if(!f.content.value.trim()){
        alert('내용을 입력하세요');
        f.content.focus();
        return false;
      }
      return true;
    }
  </script>

</body>
</html>
