<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>방송 안내 관리</title>
    <sec:csrfMetaTags/>
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap"
          rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0"
          rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">
    <style>
        #broadcastPage {
            --bg: #f4f6fb;
            --card: #ffffff;
            --line: #e5e9f2;
            --text: #1f2a37;
            --muted: #6b7280;
            --primary: #2b6be3;
            --primary-dark: #1f56be;
            --danger: #dc2626;
        }

        #broadcastPage .tts-wrap {
            display: grid;
            gap: 16px;
        }

        #broadcastPage .page-title {
            display: flex;
            align-items: center;
            gap: 10px;
            padding-bottom: 14px;
            border-bottom: 1px solid var(--line);
        }

        #broadcastPage .page-title .icon-wrap {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 36px;
            height: 36px;
            border-radius: 10px;
            background: #eef3fd;
            color: var(--primary);
            flex-shrink: 0;
        }

        #broadcastPage .page-title h2 {
            margin: 0;
            font-size: 18px;
            font-weight: 700;
            color: var(--text);
        }

        #broadcastPage .page-title p {
            margin: 2px 0 0;
            font-size: 13px;
            color: var(--muted);
        }

        #broadcastPage .tts-grid {
            display: grid;
            grid-template-columns: minmax(0, 2fr) minmax(300px, 1fr);
            gap: 16px;
            align-items: start;
        }

        #broadcastPage .card {
            background: var(--card);
            border: 1px solid var(--line);
            border-radius: 14px;
            overflow: hidden;
        }

        #broadcastPage .card-header {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 14px 18px;
            border-bottom: 1px solid var(--line);
            font-size: 16px;
            font-weight: 700;
            color: var(--text);
        }

        #broadcastPage .card-body {
            padding: 18px;
        }

        #broadcastPage .field {
            display: grid;
            gap: 6px;
            margin-bottom: 14px;
        }

        #broadcastPage .field:last-child {
            margin-bottom: 0;
        }

        #broadcastPage .label {
            font-size: 13px;
            font-weight: 700;
            color: var(--text);
        }

        #broadcastPage .hint {
            font-size: 12px;
            color: var(--muted);
            line-height: 1.45;
        }

        #broadcastPage .input,
        #broadcastPage .select,
        #broadcastPage .textarea {
            width: 100%;
            border: 1px solid #d6dbe5;
            border-radius: 10px;
            background: #fff;
            color: var(--text);
            font-size: 14px;
            outline: none;
            transition: border-color .15s ease, box-shadow .15s ease;
        }

        #broadcastPage .input,
        #broadcastPage .select {
            height: 42px;
            padding: 0 12px;
        }

        #broadcastPage .textarea {
            min-height: 230px;
            resize: vertical;
            line-height: 1.6;
            padding: 12px;
        }

        #broadcastPage .input:focus,
        #broadcastPage .select:focus,
        #broadcastPage .textarea:focus {
            border-color: #8cb2f8;
            box-shadow: 0 0 0 3px rgba(43, 107, 227, 0.14);
        }

        #broadcastPage .actions {
            display: flex;
            justify-content: flex-end;
            gap: 8px;
            flex-wrap: wrap;
            margin-top: 14px;
        }

        #broadcastPage .btnx {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            height: 38px;
            padding: 0 14px;
            border-radius: 10px;
            border: 1px solid transparent;
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
            user-select: none;
        }

        #broadcastPage .btnx-secondary {
            border-color: #d6dbe5;
            background: #fff;
            color: #374151;
        }

        #broadcastPage .btnx-secondary:hover {
            background: #f7f9fc;
        }

        #broadcastPage .btnx-primary {
            background: var(--primary);
            color: #fff;
        }

        #broadcastPage .btnx-primary:hover {
            background: var(--primary-dark);
        }

        #broadcastPage .history-table {
            width: 100%;
            border-collapse: collapse;
        }

        #broadcastPage .history-table th,
        #broadcastPage .history-table td {
            padding: 12px 10px;
            border-bottom: 1px solid var(--line);
            font-size: 13px;
            vertical-align: middle;
            text-align: left;
        }

        #broadcastPage .history-table th {
            color: var(--muted);
            font-weight: 700;
            background: #f8faff;
        }

        #broadcastPage .badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 700;
            color: #0a5f8a;
            background: #dcf5ff;
            border: 1px solid #b8e7ff;
        }

        #broadcastPage .history-empty {
            padding: 30px 12px;
            text-align: center;
            color: var(--muted);
            font-size: 13px;
        }

        #broadcastPage .audio-wrap audio {
            width: 250px;
            max-width: 100%;
        }

        #broadcastPage .icon-btn {
            width: 34px;
            height: 34px;
            border: 1px solid #f2b4b4;
            background: #fff5f5;
            color: var(--danger);
            border-radius: 8px;
            cursor: pointer;
        }

        #broadcastPage .icon-btn:hover {
            background: #fee2e2;
        }

        @media (max-width: 980px) {
            #broadcastPage .tts-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>
    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>
        <main class="main-content">
            <div class="office-page" id="broadcastPage">
                <div class="tts-wrap">
                    <div class="page-title">
                        <div>
                            <h2 style="font-size: 20px">방송 안내 관리</h2>
                            <p>안내 문구를 입력하고 음성으로 변환합니다.</p>
                        </div>
                    </div>

                    <div class="tts-grid">
                        <section class="card" aria-label="text-input">
                            <div class="card-header">
                                <span class="material-symbols-rounded">edit_note</span>
                                텍스트 입력
                            </div>
                            <div class="card-body">
                                <div class="field">
                                    <label class="label" for="ttsText">변환할 텍스트</label>
                                    <textarea class="textarea" id="ttsText" placeholder="변환할 텍스트를 입력하세요."></textarea>
                                    <div class="hint">안내 문구를 그대로 붙여넣고 변환 버튼을 누르세요.</div>
                                </div>

                                <div class="actions">
                                    <button type="button" class="btnx btnx-secondary" id="clearBtn">
                                        <span class="material-symbols-rounded"
                                              style="font-size:17px;">restart_alt</span>
                                        초기화
                                    </button>
                                    <button type="button" class="btnx btnx-primary" id="convertBtn">
                                        <span class="material-symbols-rounded" style="font-size:17px;">graphic_eq</span>
                                        음성 변환하기
                                    </button>
                                </div>
                            </div>
                        </section>

                        <aside class="card" aria-label="options">
                            <div class="card-header">
                                <span class="material-symbols-rounded">tune</span>
                                옵션
                            </div>
                            <div class="card-body">
                                <div class="field">
                                    <label class="label" for="langSelect">언어 선택</label>
                                    <select class="select" id="langSelect">
                                        <option value="ko-KR" selected>한국어</option>
                                        <option value="en-US">영어</option>
                                        <option value="ja-JP">일본어</option>
                                    </select>
                                </div>

                                <div class="field">
                                    <label class="label" for="voiceSelect">음성 선택</label>
                                    <select class="select" id="voiceSelect">
                                        <option value="ko-KR-Standard-A" selected>한국어 여성 A (Standard)</option>
                                        <option value="ko-KR-Standard-B">한국어 남성 B (Standard)</option>
                                    </select>
                                </div>
                            </div>
                        </aside>
                    </div>

                    <section class="card" aria-label="history">
                        <div class="card-header">
                            <span class="material-symbols-rounded">history</span>
                            변환 이력
                        </div>
                        <div class="card-body">
                            <div id="historyEmpty" class="history-empty">변환 이력이 없습니다.</div>
                            <div style="overflow:auto;">
                                <table class="history-table" id="historyTable" style="display:none;">
                                    <thead>
                                    <tr>
                                        <th style="width:60px;">#</th>
                                        <th>입력 텍스트</th>
                                        <th style="width:90px;">언어</th>
                                        <th style="width:170px;">음성</th>
                                        <th style="width:170px;">변환 시각</th>
                                        <th style="width:280px;">재생</th>
                                        <th style="width:90px;">삭제</th>
                                    </tr>
                                    </thead>
                                    <tbody id="historyTbody"></tbody>
                                </table>
                            </div>
                        </div>
                    </section>
                </div>
            </div>
        </main>
    </div>
</div>

<script>
    const historyRows = [];

    function nowKST() {
        return new Date().toLocaleString('ko-KR');
    }

    function escapeHtml(str) {
        return (str ?? '')
            .toString()
            .replaceAll('&', '&amp;')
            .replaceAll('<', '&lt;')
            .replaceAll('>', '&gt;')
            .replaceAll('"', '&quot;')
            .replaceAll("'", '&#039;');
    }

    function getFormValues() {
        return {
            text: document.getElementById('ttsText').value.trim(),
            lang: document.getElementById('langSelect').value,
            voice: document.getElementById('voiceSelect').value,
        };
    }

    function setHistoryVisible(isVisible) {
        document.getElementById('historyEmpty').style.display = isVisible ? 'none' : 'block';
        document.getElementById('historyTable').style.display = isVisible ? 'table' : 'none';
    }

    function renderHistory() {
        const tbody = document.getElementById('historyTbody');
        if (historyRows.length === 0) {
            tbody.innerHTML = '';
            setHistoryVisible(false);
            return;
        }
        setHistoryVisible(true);
        tbody.innerHTML = historyRows.map((row, idx) => {
            const shortText = row.text.length > 40 ? row.text.slice(0, 40) + '…' : row.text;
            const audioHtml = row.audioUrl
                ? `<div class="audio-wrap"><audio controls preload="none" src="${escapeHtml(row.audioUrl)}"></audio></div>`
                : `<span class="help-text">오디오 준비중</span>`;
            return `
                <tr data-idx="${idx}">
                    <td>${idx + 1}</td>
                    <td title="${escapeHtml(row.text)}">${escapeHtml(shortText)}</td>
                    <td><span class="badge">${escapeHtml(row.lang)}</span></td>
                    <td>${escapeHtml(row.voice)}</td>
                    <td>${escapeHtml(row.createdAt)}</td>
                    <td>${audioHtml}</td>
                    <td>
                        <button type="button" class="icon-btn" data-action="remove">
                            <span class="material-symbols-rounded" style="font-size:18px;">delete</span>
                        </button>
                    </td>
                </tr>
            `;
        }).join('');
    }

    const convertTts = async () => {
        const {text, lang, voice} = getFormValues();
        if (text === '') {
            alert("변환할 텍스트를 입력해주세요.")
            return false;
        }
        try {
            const res = await fetch(`http://localhost:8060/tts/synthesize?text=${encodeURIComponent(text)}&languageCode=${encodeURIComponent(lang)}&voiceName=${encodeURIComponent(voice)}`);
            const blob = await res.blob();
            const audioUrl = URL.createObjectURL(blob);

            historyRows.unshift({
                text,
                lang,
                voice,
                createdAt: nowKST(),
                audioUrl: audioUrl,
            });
            renderHistory();
        } catch (e) {
            alert('TTS 서버 연결 실패. 도커 컨테이너 실행 중인지 확인해주세요.');
        }
    }


    document.getElementById('convertBtn').addEventListener('click', convertTts);

    document.getElementById('clearBtn').addEventListener('click', function () {
        document.getElementById('ttsText').value = '';
    });

    document.getElementById('historyTbody').addEventListener('click', function (e) {
        const btn = e.target.closest('button[data-action="remove"]');
        if (!btn) return;
        const tr = btn.closest('tr[data-idx]');
        if (!tr) return;
        const idx = Number(tr.getAttribute('data-idx'));
        if (!Number.isFinite(idx)) return;
        historyRows.splice(idx, 1);
        renderHistory();
    });

    renderHistory();
</script>
</body>
</html>
