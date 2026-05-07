<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>

<html lang="ko"><head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <script src="https://cdn.tailwindcss.com"></script>
  <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
  <script>
    tailwind.config = {
      theme: {
        extend: {
          colors: {
            "surface": "#fbf9f1",
            "primary": "#3f4c15",
            "secondary": "#5b614c",
            "secondary-container": "#dfe5cb",
            "primary-container": "#56642b",
            "on-primary-container": "#cfe09a",
            "surface-container-low": "#f6f4eb",
            "surface-container": "#f0eee6",
            "on-surface": "#1b1c17",
            "on-surface-variant": "#46483c",
            "outline": "#76786b",
            "outline-variant": "#c7c8b8",
          }
        }
      }
    }
  </script>
  <style>
    body { font-family: 'Manrope', sans-serif; background-color: #fbf9f1; }
    .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; }

    .form-card {
      background: #ffffff;
      border: 1px solid #e2e2e0;
      border-radius: 20px;
      padding: 32px;
    }

    .form-label {
      display: block;
      font-size: 13px;
      font-weight: 700;
      color: #46483c;
      margin-bottom: 8px;
    }

    .form-input {
      width: 100%;
      padding: 12px 16px;
      border: 1.5px solid #e2e2e0;
      border-radius: 12px;
      font-size: 14px;
      font-family: 'Manrope', sans-serif;
      background: #fbf9f1;
      color: #1b1c17;
      transition: border-color 0.2s, box-shadow 0.2s;
      outline: none;
    }
    .form-input:focus {
      border-color: #3f4c15;
      box-shadow: 0 0 0 3px rgba(63,76,21,0.1);
    }
    .form-input::placeholder { color: #b0b09e; }

    textarea.form-input {
      resize: vertical;
      min-height: 160px;
    }

    /* 파일 업로드 드래그존 */
    .upload-zone {
      border: 2px dashed #c7c8b8;
      border-radius: 14px;
      padding: 32px;
      text-align: center;
      cursor: pointer;
      transition: border-color 0.2s, background 0.2s;
      background: #fbf9f1;
    }
    .upload-zone:hover, .upload-zone.dragover {
      border-color: #3f4c15;
      background: #f0eee6;
    }

    /* 미리보기 이미지 */
    .preview-item {
      position: relative;
      width: 80px;
      height: 80px;
      border-radius: 10px;
      overflow: hidden;
      border: 1px solid #e2e2e0;
      flex-shrink: 0;
    }
    .preview-item img { width: 100%; height: 100%; object-fit: cover; }
    .preview-item .remove-btn {
      position: absolute;
      top: 3px;
      right: 3px;
      width: 18px;
      height: 18px;
      background: rgba(0,0,0,0.55);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      cursor: pointer;
      color: white;
      font-size: 12px;
      line-height: 1;
    }

    /* 카테고리 선택 칩 */
    .category-chip {
      padding: 8px 18px;
      border-radius: 9999px;
      font-size: 13px;
      font-weight: 600;
      border: 1.5px solid #e2e2e0;
      background: #fbf9f1;
      color: #76786b;
      cursor: pointer;
      transition: all 0.15s;
    }
    .category-chip:hover { border-color: #3f4c15; color: #3f4c15; }
    .category-chip.selected {
      background: #dfe5cb;
      border-color: #3f4c15;
      color: #3f4c15;
    }

    /* 공개/비공개 토글 */
    .toggle-wrap { display: flex; align-items: center; gap: 10px; cursor: pointer; }
    .toggle-bg {
      width: 44px;
      height: 24px;
      border-radius: 12px;
      background: #c7c8b8;
      position: relative;
      transition: background 0.2s;
    }
    .toggle-bg.on { background: #3f4c15; }
    .toggle-knob {
      width: 18px;
      height: 18px;
      background: white;
      border-radius: 50%;
      position: absolute;
      top: 3px;
      left: 3px;
      transition: transform 0.2s;
      box-shadow: 0 1px 3px rgba(0,0,0,0.2);
    }
    .toggle-bg.on .toggle-knob { transform: translateX(20px); }

    /* 버튼 */
    .btn-primary {
      background: #3f4c15;
      color: white;
      padding: 13px 32px;
      border-radius: 12px;
      font-weight: 700;
      font-size: 14px;
      transition: opacity 0.2s, transform 0.1s;
    }
    .btn-primary:hover { opacity: 0.88; }
    .btn-primary:active { transform: scale(0.97); }

    .btn-secondary {
      background: #f0eee6;
      color: #46483c;
      padding: 13px 28px;
      border-radius: 12px;
      font-weight: 700;
      font-size: 14px;
      transition: background 0.2s;
    }
    .btn-secondary:hover { background: #e4e3da; }

    /* 필수 표시 */
    .required::after {
      content: ' *';
      color: #ba1a1a;
    }

    /* 글자수 카운터 */
    .char-counter { font-size: 11px; color: #b0b09e; text-align: right; margin-top: 5px; }
    .char-counter.warn { color: #ba1a1a; }
  </style>
</head>

<body class="bg-surface text-on-surface min-h-screen">

<%@ include file="/WEB-INF/views/ztestview/header.jsp" %>
<%@ include file="/WEB-INF/views/ztestview/sidebar.jsp" %>
<%@ include file="/WEB-INF/views/ztestview/sidebarStyle.jsp" %>

<main class="ml-80 p-10 pt-28">

  <!-- 상단 타이틀 + 뒤로가기 -->
  <div class="flex items-center gap-3 mb-8">
    <button onclick="history.back()"
            class="w-9 h-9 flex items-center justify-center rounded-full hover:bg-surface-container transition-colors">
      <span class="material-symbols-outlined text-on-surface-variant">arrow_back</span>
    </button>
    <div>
      <h1 class="text-2xl font-bold text-gray-900">새 문의 작성</h1>
      <p class="text-sm text-gray-400 mt-0.5">담당자가 확인 후 신속하게 답변해 드립니다.</p>
    </div>
  </div>

  <form action="/member/qna/writeProc.do" method="post" enctype="multipart/form-data" id="inquiryForm">

    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">


    <div class="space-y-5">

      <!-- ① 카테고리 -->
      <div class="form-card">
        <label class="form-label required">문의 유형</label>
        <div class="flex flex-wrap gap-2" id="categoryGroup">
          <button type="button" class="category-chip selected" data-value="시설">시설 / 설비</button>
          <button type="button" class="category-chip" data-value="주차">주차 / 차량</button>
          <button type="button" class="category-chip" data-value="소음">소음 / 분쟁</button>
          <button type="button" class="category-chip" data-value="커뮤니티">커뮤니티 시설</button>
          <button type="button" class="category-chip" data-value="청소">청결 / 환경</button>
          <button type="button" class="category-chip" data-value="기타">기타</button>
        </div>
        <input type="hidden" name="cvplTyCd" id="categoryInput" value="시설"/>
      </div>

      <!-- ② 제목 -->
      <div class="form-card">
        <label class="form-label required" for="titleInput">제목</label>
        <input class="form-input"
               type="text"
               id="titleInput"
               name="cvplTtl"
               placeholder="문의 제목을 입력하세요 (최대 50자)"
               maxlength="50"/>
        <div class="char-counter"><span id="titleCount">0</span> / 50</div>
      </div>

      <!-- ③ 내용 -->
      <div class="form-card">
        <label class="form-label required" for="contentInput">문의 내용</label>
        <textarea class="form-input"
                  id="contentInput"
                  name="cvplCn"
                  placeholder="문의 내용을 상세히 작성해주세요.&#10;&#10;예) 위치, 발생 시간, 증상 등을 함께 적어주시면 더 빠른 처리가 가능합니다."
                  maxlength="1000"></textarea>
        <div class="char-counter"><span id="contentCount">0</span> / 1000</div>
      </div>

      <!-- ④ 사진 첨부 -->
      <div class="form-card">
        <label class="form-label">사진 첨부 <span class="font-normal text-gray-400">(최대 5장)</span></label>

        <div class="upload-zone" id="uploadZone" onclick="document.getElementById('fileInput').click()">
          <span class="material-symbols-outlined text-3xl text-gray-300 mb-2" style="font-size:36px">add_photo_alternate</span>
          <p class="text-sm text-gray-400 mt-1">클릭하거나 이미지를 드래그하여 업로드</p>
          <p class="text-xs text-gray-300 mt-1">JPG, PNG, GIF · 최대 10MB</p>
        </div>

        <input type="file" id="fileInput" name="files" multiple accept="image/*" class="hidden"/>

        <!-- 미리보기 -->
        <div class="flex gap-3 mt-4 flex-wrap" id="previewContainer"></div>
      </div>

      <!-- ⑤ 공개 여부 -->
      <div class="form-card">
        <label class="form-label">공개 설정</label>
        <div class="flex items-center justify-between">
          <div>
            <p class="text-sm text-gray-700 font-medium" id="toggleLabel">다른 입주민에게 공개</p>
            <p class="text-xs text-gray-400 mt-0.5">비공개 설정 시 관리자만 확인 가능합니다.</p>
          </div>
          <div class="toggle-wrap" onclick="togglePublic()">
            <div class="toggle-bg on" id="toggleBg">
              <div class="toggle-knob"></div>
            </div>
          </div>
        </div>
        <input type="hidden" name="isPublic" id="isPublicInput" value="Y"/>
      </div>

      <!-- ⑥ 동의 체크박스 -->


    </div>

    <!-- 하단 버튼 -->
    <div class="flex justify-end gap-3 mt-8">
      <button type="button" class="btn-secondary" onclick="history.back()">취소</button>
      <button type="submit" class="btn-primary" id="submitBtn">
        <span class="flex items-center gap-2">
          <span class="material-symbols-outlined" style="font-size:18px">send</span>
          문의 제출
        </span>
      </button>
    </div>

  </form>

</main>
</body>

<script>
  /* ── 카테고리 칩 선택 ── */
  document.querySelectorAll('.category-chip').forEach(chip => {
    chip.addEventListener('click', () => {
      document.querySelectorAll('.category-chip').forEach(c => c.classList.remove('selected'));
      chip.classList.add('selected');
      document.getElementById('categoryInput').value = chip.dataset.value;
    });
  });

  /* ── 글자수 카운터 ── */
  const titleInput   = document.getElementById('titleInput');
  const contentInput = document.getElementById('contentInput');
  const titleCount   = document.getElementById('titleCount');
  const contentCount = document.getElementById('contentCount');

  titleInput.addEventListener('input', () => {
    const len = titleInput.value.length;
    titleCount.textContent = len;
    titleCount.parentElement.classList.toggle('warn', len >= 45);
  });
  contentInput.addEventListener('input', () => {
    const len = contentInput.value.length;
    contentCount.textContent = len;
    contentCount.parentElement.classList.toggle('warn', len >= 900);
  });

  /* ── 파일 업로드 미리보기 ── */
  const fileInput       = document.getElementById('fileInput');
  const previewContainer = document.getElementById('previewContainer');
  const uploadZone      = document.getElementById('uploadZone');
  let selectedFiles = [];

  fileInput.addEventListener('change', () => handleFiles(fileInput.files));

  uploadZone.addEventListener('dragover', e => { e.preventDefault(); uploadZone.classList.add('dragover'); });
  uploadZone.addEventListener('dragleave', () => uploadZone.classList.remove('dragover'));
  uploadZone.addEventListener('drop', e => {
    e.preventDefault();
    uploadZone.classList.remove('dragover');
    handleFiles(e.dataTransfer.files);
  });

  function handleFiles(files) {
    Array.from(files).forEach(file => {
      if (selectedFiles.length >= 5) return;
      if (!file.type.startsWith('image/')) return;
      selectedFiles.push(file);

      const reader = new FileReader();
      reader.onload = e => {
        const item = document.createElement('div');
        item.className = 'preview-item';
        item.innerHTML = `
          <img src="${e.target.result}" alt="미리보기"/>
          <div class="remove-btn" onclick="removeFile(this, '${file.name}')">✕</div>`;
        previewContainer.appendChild(item);
      };
      reader.readAsDataURL(file);
    });
  }

  function removeFile(btn, name) {
    selectedFiles = selectedFiles.filter(f => f.name !== name);
    btn.closest('.preview-item').remove();
  }

  /* ── 공개/비공개 토글 ── */
  let isPublic = true;
  function togglePublic() {
    isPublic = !isPublic;
    const bg    = document.getElementById('toggleBg');
    const label = document.getElementById('toggleLabel');
    const input = document.getElementById('isPublicInput');
    bg.classList.toggle('on', isPublic);
    label.textContent = isPublic ? '다른 입주민에게 공개' : '비공개 (관리자만 열람)';
    input.value = isPublic ? 'Y' : 'N';
  }

  /* ── 제출 유효성 검사 ── */
  document.getElementById('inquiryForm').addEventListener('submit', function(e) {
    if (!titleInput.value.trim()) {
      e.preventDefault();
      titleInput.focus();
      alert('제목을 입력해주세요.');
      return;
    }
    if (!contentInput.value.trim()) {
      e.preventDefault();
      contentInput.focus();
      alert('문의 내용을 입력해주세요.');

    }

  });
</script>
</html>
