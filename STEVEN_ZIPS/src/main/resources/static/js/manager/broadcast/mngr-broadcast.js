/**
 * 방송 안내 작성 · TTS 변환 · sessionStorage 이력
 */
(function () {
    'use strict';

    var cfg = window.BC_PAGE;
    if (!cfg || !cfg.mgmtOfcNo) return;

    var LANG = 'ko-KR';
    var CHAR_RECOMMEND = 300;
    var CHAR_MAX = 500;
    var HISTORY_MAX = 20;
    var DEFAULT_RESET_VOICE = 'ko-KR-Standard-C';
    var CONVERT_BTN_HTML = '<span class="material-symbols-rounded">graphic_eq</span>음성 변환하기';

    var VOICE_OPTIONS = {
        'ko-KR-Standard-A': '여성 A',
        'ko-KR-Standard-B': '여성 B',
        'ko-KR-Standard-C': '남성 A',
        'ko-KR-Standard-D': '남성 B'
    };

    var historyRows = [];
    var selectedSourceId = '';
    var synth = window.speechSynthesis;
    var $ = function (id) { return document.getElementById(id); };

    var SOURCE_NOTES = {
        check: '점검 건을 클릭하면 좌측에 방송 초안이 채워집니다.',
        complaint: '민원 건을 클릭하면 익명·일반화된 안내 초안이 채워집니다.',
        history: '변환한 음성 이력입니다. 항목을 눌러 다시 불러올 수 있습니다.'
    };

    function getVoiceLabel(voice) {
        return VOICE_OPTIONS[voice] || '남성 A';
    }

    function voiceFromLabel(label) {
        if (label === '남성 B') return 'ko-KR-Standard-D';
        if (label === '남성 A') return 'ko-KR-Standard-C';
        if (label === '여성 B') return 'ko-KR-Standard-B';
        return 'ko-KR-Standard-A';
    }

    function getIntro() {
        var page = document.getElementById('broadcastPage');
        return (page && page.getAttribute('data-broadcast-intro')) || '안녕하세요. 본 단지 관리사무소입니다.';
    }

    function getDummySources() {
        var intro = getIntro();
        return {
            check: [
                {
                    id: 'chk-1',
                    title: '1호기 승강기 정기 점검',
                    meta: '2026-05-29 · 이용 제한',
                    badge: '제한중',
                    badgeClass: 'warn',
                    areas: ['1동'],
                    draft: intro + '\n오늘 오후 2시부터 4시까지 1호기 엘리베이터 정기점검이 있습니다.\n이용에 불편을 드려 죄송합니다. 2호기는 정상 운행됩니다.\n감사합니다.'
                },
                {
                    id: 'chk-2',
                    title: '지하 주차장 환기시설 점검',
                    meta: '2026-05-30 · 예정',
                    badge: '점검 예정',
                    areas: ['전체'],
                    draft: intro + '\n내일 오전 10시부터 12시까지 지하 주차장 환기시설 점검이 있습니다.\n해당 시간에는 소음이 있을 수 있습니다.\n이용에 참고해 주세요.\n감사합니다.'
                }
            ],
            complaint: [
                {
                    id: 'cvpl-1',
                    title: '주차 단속 관련 협조 요청',
                    meta: '처리중 · 공용구역',
                    badge: '주차',
                    areas: ['전체'],
                    draft: intro + '\n소방 통로와 출입구 주변에 주차된 차량이 있어 안내드립니다.\n30분 이내에 차량을 옮겨 주시면 감사하겠습니다.\n감사합니다.'
                },
                {
                    id: 'cvpl-2',
                    title: '층간소음 관련 협조 안내',
                    meta: '접수 · 102동',
                    badge: '생활소음',
                    areas: ['102동'],
                    draft: intro + '\n층간소음으로 불편하신 이웃이 계셔 안내드립니다.\n심야 시간대에는 발소리와 TV 음량에 조금만 신경 써 주세요.\n이웃을 배려해 주셔서 감사합니다.'
                }
            ]
        };
    }

    function storageKey() {
        return 'broadcast_history_' + cfg.mgmtOfcNo;
    }

    function nowKST() {
        return new Date().toLocaleString('ko-KR');
    }

    function escapeHtml(str) {
        return (str == null ? '' : String(str))
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#039;');
    }

    function toast(opts) {
        if (typeof showToast === 'function') {
            showToast(opts);
        }
    }

    function blobToDataUrl(blob) {
        return new Promise(function (resolve, reject) {
            var reader = new FileReader();
            reader.onloadend = function () { resolve(reader.result); };
            reader.onerror = reject;
            reader.readAsDataURL(blob);
        });
    }

    function saveHistory() {
        try {
            if (!historyRows.length) {
                sessionStorage.removeItem(storageKey());
                return;
            }
            sessionStorage.setItem(storageKey(), JSON.stringify(historyRows.map(function (r) {
                return {
                    text: r.text,
                    voice: r.voice,
                    areas: r.areas,
                    area: r.area,
                    voiceLabel: r.voiceLabel,
                    createdAt: r.createdAt,
                    audioUrl: r.audioUrl
                };
            })));
        } catch (e) {
            console.warn('방송 이력 저장 실패:', e);
            if (historyRows.length > 1) {
                historyRows.pop();
                saveHistory();
            }
        }
    }

    function loadHistory() {
        try {
            var raw = sessionStorage.getItem(storageKey());
            historyRows = raw ? JSON.parse(raw) : [];
            if (!Array.isArray(historyRows)) historyRows = [];
        } catch (e) {
            historyRows = [];
        }
    }

    function getSelected(attr) {
        var el = document.querySelector('[' + attr + '].active');
        return el ? el.getAttribute(attr) : '';
    }

    function getAreaCheckboxes() {
        return document.querySelectorAll('#areaSelectPanel input[name="areaOpt"]');
    }

    function getAllAreaCheckbox() {
        return document.querySelector('#areaSelectPanel input[data-area-all]');
    }

    function isAreaAllCheckbox(cb) {
        return cb && cb.hasAttribute('data-area-all');
    }

    function updateAreaLabel() {
        var label = $('areaSelectLabel');
        if (label) label.textContent = formatAreaDisplay(getSelectedAreas());
    }

    function closeAreaPanel() {
        var panel = $('areaSelectPanel');
        var trigger = $('areaSelectTrigger');
        if (panel) {
            panel.hidden = true;
            panel.classList.remove('is-drop-up');
        }
        if (trigger) {
            trigger.classList.remove('open');
            trigger.setAttribute('aria-expanded', 'false');
        }
    }

    function closeSelectPanels() {
        closeAreaPanel();
        closeVoicePanel();
    }

    function closeVoicePanel() {
        var panel = $('voiceSelectPanel');
        var trigger = $('voiceSelectTrigger');
        if (panel) {
            panel.hidden = true;
            panel.classList.remove('is-drop-up');
        }
        if (trigger) {
            trigger.classList.remove('open');
            trigger.setAttribute('aria-expanded', 'false');
        }
    }

    function positionSelectPanel(panelId, triggerId) {
        var panel = $(panelId);
        var trigger = $(triggerId);
        if (!panel || !trigger || panel.hidden) return;

        panel.classList.remove('is-drop-up');
        var rect = trigger.getBoundingClientRect();
        var panelHeight = panel.offsetHeight;
        var spaceBelow = window.innerHeight - rect.bottom - 12;
        var spaceAbove = rect.top - 12;

        if (panelHeight > spaceBelow && spaceAbove > spaceBelow) {
            panel.classList.add('is-drop-up');
        }
    }

    function positionAreaPanel() {
        positionSelectPanel('areaSelectPanel', 'areaSelectTrigger');
    }

    function positionVoicePanel() {
        positionSelectPanel('voiceSelectPanel', 'voiceSelectTrigger');
    }

    function updateVoiceLabel() {
        var label = $('voiceSelectLabel');
        var select = $('voiceSelect');
        if (label && select) label.textContent = getVoiceLabel(select.value);
    }

    function selectVoice(voice, voiceLabel) {
        var v = voice || voiceFromLabel(voiceLabel);
        if (!VOICE_OPTIONS[v]) {
            v = DEFAULT_RESET_VOICE;
        }
        var select = $('voiceSelect');
        if (select) select.value = v;
        document.querySelectorAll('#voiceSelectPanel [data-voice]').forEach(function (opt) {
            var on = opt.getAttribute('data-voice') === v;
            opt.classList.toggle('active', on);
            opt.setAttribute('aria-selected', on ? 'true' : 'false');
        });
        updateVoiceLabel();
    }

    function bindVoiceSelect() {
        var trigger = $('voiceSelectTrigger');
        var panel = $('voiceSelectPanel');
        if (!trigger || !panel) return;

        trigger.addEventListener('click', function (e) {
            e.stopPropagation();
            var willOpen = panel.hidden;
            closeSelectPanels();
            if (willOpen) {
                panel.hidden = false;
                trigger.classList.add('open');
                trigger.setAttribute('aria-expanded', 'true');
                positionVoicePanel();
            }
        });

        panel.addEventListener('click', function (e) {
            e.stopPropagation();
            var opt = e.target.closest('[data-voice]');
            if (!opt) return;
            selectVoice(opt.getAttribute('data-voice'));
            closeVoicePanel();
        });
    }

    function getSelectedAreas() {
        var allCb = getAllAreaCheckbox();
        if (allCb && allCb.checked) return ['전체'];
        var areas = [];
        getAreaCheckboxes().forEach(function (cb) {
            if (!isAreaAllCheckbox(cb) && cb.checked) areas.push(cb.value);
        });
        return areas.length ? areas : ['전체'];
    }

    function formatAreaDisplay(areas) {
        if (!areas || !areas.length || areas.indexOf('전체') >= 0) return '전체';
        if (areas.length <= 2) return areas.join(', ');
        return areas[0] + ' 외 ' + (areas.length - 1) + '개 동';
    }

    function resetAreas() {
        getAreaCheckboxes().forEach(function (cb) {
            cb.checked = isAreaAllCheckbox(cb);
        });
        updateAreaLabel();
    }

    function selectAreas(areas) {
        var list = areas && areas.length ? areas : ['전체'];
        var allCb = getAllAreaCheckbox();
        if (list.indexOf('전체') >= 0) {
            resetAreas();
            return;
        }
        if (allCb) allCb.checked = false;
        getAreaCheckboxes().forEach(function (cb) {
            if (isAreaAllCheckbox(cb)) return;
            cb.checked = list.indexOf(cb.value) >= 0;
        });
        if (!document.querySelector('#areaSelectPanel input[name="areaOpt"]:not([data-area-all]):checked')) {
            resetAreas();
            return;
        }
        updateAreaLabel();
    }

    function bindAreaSelect() {
        var trigger = $('areaSelectTrigger');
        var panel = $('areaSelectPanel');
        if (!trigger || !panel) return;

        trigger.addEventListener('click', function (e) {
            e.stopPropagation();
            var willOpen = panel.hidden;
            closeSelectPanels();
            if (willOpen) {
                panel.hidden = false;
                trigger.classList.add('open');
                trigger.setAttribute('aria-expanded', 'true');
                positionAreaPanel();
            }
        });

        document.addEventListener('click', closeSelectPanels);
        panel.addEventListener('click', function (e) { e.stopPropagation(); });

        getAreaCheckboxes().forEach(function (cb) {
            cb.addEventListener('change', function () {
                var allCb = getAllAreaCheckbox();
                if (isAreaAllCheckbox(cb)) {
                    if (cb.checked) {
                        getAreaCheckboxes().forEach(function (c) {
                            if (!isAreaAllCheckbox(c)) c.checked = false;
                        });
                    } else if (!document.querySelector('#areaSelectPanel input[name="areaOpt"]:not([data-area-all]):checked')) {
                        cb.checked = true;
                    }
                } else {
                    if (cb.checked && allCb) allCb.checked = false;
                    if (!document.querySelector('#areaSelectPanel input[name="areaOpt"]:not([data-area-all]):checked') && allCb) {
                        allCb.checked = true;
                    }
                }
                updateAreaLabel();
            });
        });
    }

    function getFormValues() {
        var areas = getSelectedAreas();
        return {
            text: $('ttsText').value.trim(),
            lang: LANG,
            voice: $('voiceSelect').value,
            voiceLabel: getVoiceLabel($('voiceSelect').value),
            areas: areas,
            area: formatAreaDisplay(areas)
        };
    }

    function formatDuration(len) {
        var sec = Math.max(0, Math.round(len / 5));
        return sec >= 60 ? (Math.floor(sec / 60) + '분 ' + (sec % 60) + '초') : (sec + '초');
    }

    function updateMeta() {
        var len = $('ttsText').value.length;
        $('charCount').textContent = len;
        $('estDuration').textContent = formatDuration(len);
        var meta = $('editorMeta');
        meta.classList.remove('warn', 'over');
        if (len > CHAR_MAX) meta.classList.add('over');
        else if (len > CHAR_RECOMMEND) meta.classList.add('warn');
    }

    function setComposeLoading(on) {
        $('composeLoading').hidden = !on;
        $('convertBtn').disabled = on;
        $('previewBtn').disabled = on;
        $('clearBtn').disabled = on;
        document.querySelectorAll('#broadcastPage [data-template], #areaSelectTrigger, #areaSelectPanel input, #voiceSelectTrigger, #voiceSelectPanel [data-voice]')
            .forEach(function (el) { el.disabled = on; });
        if (on) closeSelectPanels();
    }

    function setPreviewState(on) {
        var btn = $('previewBtn');
        if (on) {
            btn.classList.add('listening');
            btn.innerHTML = '<span class="material-symbols-rounded">stop</span>미리듣기 정지';
        } else {
            btn.classList.remove('listening');
            btn.innerHTML = '<span class="material-symbols-rounded">hearing</span>미리듣기';
        }
    }

    function togglePreview() {
        if (!synth) {
            toast({ title: '미리듣기 불가', message: '이 브라우저는 미리듣기를 지원하지 않습니다.', type: 'warning' });
            return;
        }
        if (synth.speaking) {
            synth.cancel();
            setPreviewState(false);
            return;
        }
        var text = $('ttsText').value.trim();
        if (!text) {
            toast({ title: '입력 필요', message: '미리 들을 문구를 입력해주세요.', type: 'warning' });
            return;
        }
        var u = new SpeechSynthesisUtterance(text);
        u.lang = LANG;
        u.onend = u.onerror = function () { setPreviewState(false); };
        synth.speak(u);
        setPreviewState(true);
    }

    function hidePlayer() {
        var audio = $('playerAudio');
        if (audio) {
            audio.pause();
            audio.removeAttribute('src');
            audio.load();
        }
        updatePlayerToggle(false);
        $('eqBars').classList.remove('playing');
        $('playerCard').style.display = 'none';
    }

    function pauseAllBroadcastAudio(exceptEl) {
        var main = $('playerAudio');
        if (main && main !== exceptEl && !main.paused) {
            main.pause();
        }
        document.querySelectorAll('#historyList audio').forEach(function (a) {
            if (a !== exceptEl && !a.paused) a.pause();
        });
    }

    function updatePlayerToggle(isPlaying) {
        var icon = $('playerToggleIcon');
        var btn = $('playerToggleBtn');
        if (!icon || !btn) return;
        icon.textContent = isPlaying ? 'pause' : 'play_arrow';
        btn.setAttribute('aria-label', isPlaying ? '일시정지' : '재생');
    }

    function showPlayer(row, label) {
        var audio = $('playerAudio');
        if (!audio) return;
        $('playerLabel').textContent = label || '최근 변환 음성';
        $('playerText').textContent = row.text;
        pauseAllBroadcastAudio();
        audio.pause();
        audio.src = row.audioUrl;
        audio.load();
        $('playerCard').style.display = 'block';
        var playWhenReady = function () {
            audio.removeEventListener('canplay', playWhenReady);
            audio.play().catch(function () {
                updatePlayerToggle(false);
            });
        };
        if (audio.readyState >= 2) {
            audio.play().catch(function () {
                updatePlayerToggle(false);
            });
        } else {
            audio.addEventListener('canplay', playWhenReady);
        }
    }

    function bindPlayerControls() {
        var audio = $('playerAudio');
        var toggle = $('playerToggleBtn');
        var eq = $('eqBars');
        if (!audio || !toggle) return;

        toggle.addEventListener('click', function () {
            if (!audio.src) return;
            if (audio.paused) {
                pauseAllBroadcastAudio(audio);
                audio.play().catch(function () {});
            } else {
                audio.pause();
            }
        });

        audio.addEventListener('play', function () {
            pauseAllBroadcastAudio(audio);
            if (eq) eq.classList.add('playing');
            updatePlayerToggle(true);
        });
        audio.addEventListener('pause', function () {
            if (eq) eq.classList.remove('playing');
            updatePlayerToggle(false);
        });
        audio.addEventListener('ended', function () {
            if (eq) eq.classList.remove('playing');
            updatePlayerToggle(false);
        });

        $('historyList').addEventListener('play', function (e) {
            if (e.target && e.target.tagName === 'AUDIO') {
                pauseAllBroadcastAudio(e.target);
                if (eq) eq.classList.remove('playing');
                updatePlayerToggle(false);
            }
        }, true);
    }

    function switchSourceTab(tab) {
        document.querySelectorAll('#broadcastPage .source-tab').forEach(function (btn) {
            var on = btn.getAttribute('data-source-tab') === tab;
            btn.classList.toggle('active', on);
            btn.setAttribute('aria-selected', on ? 'true' : 'false');
        });
        document.querySelectorAll('#broadcastPage .source-panel').forEach(function (panel) {
            panel.classList.toggle('active', panel.getAttribute('data-panel') === tab);
        });
        var note = $('sourceNote');
        if (note) note.textContent = SOURCE_NOTES[tab] || '';
    }

    function renderDummyPanel(type, items) {
        var panel = $('panel' + (type === 'check' ? 'Check' : 'Complaint'));
        if (!panel) return;
        panel.innerHTML = '<p class="source-dummy-tag">시나리오 테스트용 더미 데이터</p>'
            + '<div class="source-list">' + items.map(function (item) {
                return '<button type="button" class="source-item" data-source-type="' + type + '" data-source-id="' + item.id + '">'
                    + '<div class="source-item-title">' + escapeHtml(item.title) + '</div>'
                    + '<div class="source-item-meta">' + escapeHtml(item.meta) + '</div>'
                    + '<span class="source-item-badge' + (item.badgeClass ? ' ' + item.badgeClass : '') + '">'
                    + escapeHtml(item.badge) + '</span></button>';
            }).join('') + '</div>';
    }

    function applySourceDraft(type, id) {
        var dummies = getDummySources();
        var list = dummies[type] || [];
        var item = list.filter(function (r) { return r.id === id; })[0];
        if (!item) return;

        selectedSourceId = type + ':' + id;
        document.querySelectorAll('#broadcastPage .source-item[data-source-type]').forEach(function (el) {
            el.classList.toggle('selected', el.getAttribute('data-source-id') === id
                && el.getAttribute('data-source-type') === type);
        });

        $('ttsText').value = item.draft;
        selectAreas(item.areas);
        updateMeta();
        $('ttsText').focus();
    }

    function initDummySources() {
        var dummies = getDummySources();
        renderDummyPanel('check', dummies.check);
        renderDummyPanel('complaint', dummies.complaint);
    }

    function renderHistory() {
        var list = $('historyList');
        var empty = $('historyEmpty');
        if (!historyRows.length) {
            list.innerHTML = '';
            list.style.display = 'none';
            empty.style.display = 'block';
            return;
        }
        empty.style.display = 'none';
        list.style.display = 'grid';
        list.innerHTML = historyRows.map(function (row, idx) {
            var title = row.text.length > 40 ? row.text.slice(0, 40) + '...' : row.text;
            return '<div class="history-item" data-idx="' + idx + '">'
                + '<div class="h-text"><div class="h-title">' + escapeHtml(title) + '</div>'
                + '<div class="h-meta">' + escapeHtml(row.area) + ' · ' + escapeHtml(row.createdAt) + '</div></div>'
                + '<audio controls preload="none" src="' + escapeHtml(row.audioUrl) + '"></audio>'
                + '<div class="h-actions">'
                + '<button type="button" class="icon-btn icon-btn-neutral" data-action="reuse" title="불러오기">'
                + '<span class="material-symbols-rounded" style="font-size:17px;">edit_note</span></button>'
                + '<button type="button" class="icon-btn" data-action="remove" title="삭제">'
                + '<span class="material-symbols-rounded" style="font-size:17px;">delete</span></button>'
                + '</div></div>';
        }).join('');
    }

    function loadHistoryToComposer(row) {
        if (!row) return;
        $('ttsText').value = row.text || '';
        selectAreas(row.areas && row.areas.length ? row.areas : [row.area]);
        selectVoice(row.voice, row.voiceLabel);
        updateMeta();
        showPlayer(row, '이력에서 불러온 음성');
        $('ttsText').focus();
    }

    function resetComposer() {
        if (synth && synth.speaking) {
            synth.cancel();
            setPreviewState(false);
        }
        selectedSourceId = '';
        document.querySelectorAll('#broadcastPage .source-item.selected').forEach(function (el) {
            el.classList.remove('selected');
        });
        $('ttsText').value = '';
        resetAreas();
        selectVoice(DEFAULT_RESET_VOICE);
        updateMeta();
        $('ttsText').focus();
    }

    function onClearClick() {
        if ($('ttsText').value.trim() && !confirm('작성 중인 문구를 초기화할까요?')) return;
        resetComposer();
    }

    function convertTts() {
        var v = getFormValues();
        if (!v.text) {
            toast({ title: '입력 필요', message: '변환할 문구를 입력해주세요.', type: 'warning' });
            return;
        }
        if (v.text.length > CHAR_MAX) {
            toast({
                title: '문구가 너무 깁니다',
                message: '방송 문구는 ' + CHAR_MAX + '자 이하로 작성해주세요.',
                type: 'warning',
                duration: 4500
            });
            return;
        }

        setComposeLoading(true);
        fetch(cfg.contextPath + '/tts/synthesize/' + cfg.mgmtOfcNo
            + '?text=' + encodeURIComponent(v.text)
            + '&languageCode=' + encodeURIComponent(v.lang)
            + '&voiceName=' + encodeURIComponent(v.voice))
            .then(function (res) {
                if (!res.ok) throw new Error('TTS failed: ' + res.status);
                return res.blob();
            })
            .then(blobToDataUrl)
            .then(function (dataUrl) {
                historyRows.unshift({
                    text: v.text,
                    voice: v.voice,
                    areas: v.areas,
                    area: v.area,
                    voiceLabel: v.voiceLabel,
                    createdAt: nowKST(),
                    audioUrl: dataUrl
                });
                if (historyRows.length > HISTORY_MAX) historyRows.length = HISTORY_MAX;
                saveHistory();
                renderHistory();
                showPlayer(historyRows[0]);
                switchSourceTab('history');
                toast({
                    title: '변환 완료',
                    message: '음성이 생성되었습니다. 변환 이력 탭에서 확인할 수 있습니다.',
                    type: 'success',
                    duration: 3200
                });
            })
            .catch(function (e) {
                console.error(e);
                toast({
                    title: '변환 실패',
                    message: 'TTS 서버 연결에 실패했습니다. 서버 실행 상태를 확인해주세요.',
                    type: 'error',
                    duration: 5000
                });
            })
            .finally(function () {
                setComposeLoading(false);
                $('convertBtn').innerHTML = CONVERT_BTN_HTML;
            });
    }

    function bindEvents() {
        $('convertBtn').addEventListener('click', convertTts);
        $('clearBtn').addEventListener('click', onClearClick);
        $('previewBtn').addEventListener('click', togglePreview);
        $('ttsText').addEventListener('input', updateMeta);

        $('clearHistoryBtn').addEventListener('click', function () {
            if (!historyRows.length) return;
            if (!confirm('저장된 변환 이력을 모두 비울까요?')) return;
            historyRows = [];
            saveHistory();
            renderHistory();
            hidePlayer();
        });

        document.querySelectorAll('#broadcastPage .source-tab').forEach(function (btn) {
            btn.addEventListener('click', function () {
                switchSourceTab(btn.getAttribute('data-source-tab'));
            });
        });

        document.getElementById('broadcastPage').addEventListener('click', function (e) {
            var sourceBtn = e.target.closest('.source-item[data-source-type]');
            if (sourceBtn) {
                applySourceDraft(
                    sourceBtn.getAttribute('data-source-type'),
                    sourceBtn.getAttribute('data-source-id')
                );
                return;
            }
            var tplBtn = e.target.closest('[data-template]');
            if (tplBtn) {
                selectedSourceId = '';
                document.querySelectorAll('#broadcastPage .source-item.selected').forEach(function (el) {
                    el.classList.remove('selected');
                });
                $('ttsText').value = tplBtn.getAttribute('data-template') || '';
                $('ttsText').focus();
                updateMeta();
            }
        });

        $('historyList').addEventListener('click', function (e) {
            var btn = e.target.closest('button[data-action]');
            if (!btn) return;
            var item = btn.closest('[data-idx]');
            if (!item) return;
            var idx = Number(item.getAttribute('data-idx'));
            if (!Number.isFinite(idx)) return;
            if (btn.getAttribute('data-action') === 'reuse') {
                loadHistoryToComposer(historyRows[idx]);
                return;
            }
            if (btn.getAttribute('data-action') === 'remove') {
                historyRows.splice(idx, 1);
                saveHistory();
                renderHistory();
                if (!historyRows.length) hidePlayer();
            }
        });

        bindPlayerControls();
    }

    function init() {
        loadHistory();
        initDummySources();
        bindAreaSelect();
        bindVoiceSelect();
        switchSourceTab('check');
        bindEvents();
        updateMeta();
        updateAreaLabel();
        renderHistory();
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
