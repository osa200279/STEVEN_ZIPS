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
    var PREVIEW_BTN_HTML = '<span class="material-symbols-rounded">hearing</span>미리듣기';

    var VOICE_OPTIONS = {
        'ko-KR-Standard-A': '여성 A',
        'ko-KR-Standard-B': '여성 B',
        'ko-KR-Standard-C': '남성 A',
        'ko-KR-Standard-D': '남성 B'
    };

    var historyRows = [];
    var selectedSourceId = '';
    var previewActive = false;
    var previewFetchAbort = null;
    var previewToken = 0;
    var broadcastActive = false;
    var currentPlayerRow = null;
    var $ = function (id) { return document.getElementById(id); };

    var SOURCE_NOTES = {
        check: '점검 건을 클릭하면 좌측에 방송 초안이 채워집니다.',
        complaint: '민원 건을 클릭하면 익명·일반화된 안내 초안이 채워집니다.'
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
                    draft: intro + '\n오늘 오후 2시부터 4시까지 1호기 엘리베이터 정기점검이 있습니다.\n이용에 불편을 드려 죄송합니다.\n감사합니다.'
                },
                {
                    id: 'chk-2',
                    title: '지하 주차장 환기시설 점검',
                    meta: '2026-05-30 · 예정',
                    badge: '점검 예정',
                    areas: ['전체'],
                    draft: intro + '\n내일 오전 10시부터 12시까지 지하 주차장 환기시설 점검이 있습니다.\n해당 시간에는 소음이 있을 수 있으므로 이용에 참고해 주시기 바랍니다.\n감사합니다.'
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
                    draft: intro + '\n층간소음으로 불편하신 이웃이 계셔 안내드립니다.\n심야 시간대에는 발소리와 TV 음량에 조금만 신경 써 주시기 바랍니다.\n이웃을 배려해 주셔서 감사합니다.'
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

    function buildTtsFetchHeaders(contentType) {
        var headers = { 'X-Requested-With': 'XMLHttpRequest' };
        if (contentType) {
            headers['Content-Type'] = contentType;
        }
        var csrfHeader = document.querySelector('meta[name="_csrf_header"]');
        var csrfToken = document.querySelector('meta[name="_csrf"]');
        if (csrfHeader && csrfToken) {
            headers[csrfHeader.getAttribute('content')] = csrfToken.getAttribute('content');
        }
        return headers;
    }

    function isLikelyMp3Blob(blob) {
        if (!blob || blob.size < 128) {
            return Promise.resolve(false);
        }
        return blob.slice(0, 4).arrayBuffer().then(function (buf) {
            var b = new Uint8Array(buf);
            if (b[0] === 0xFF && (b[1] & 0xE0) === 0xE0) return true;
            return b[0] === 0x49 && b[1] === 0x44 && b[2] === 0x33;
        });
    }

    function ensureAudioBlob(blob) {
        var mime = blob && blob.type ? blob.type : 'audio/mpeg';
        if (mime.indexOf('audio/') !== 0) {
            mime = 'audio/mpeg';
        }
        if (!blob.type || blob.type !== mime) {
            return new Blob([blob], { type: mime });
        }
        return blob;
    }

    function blobToDataUrl(blob) {
        return new Promise(function (resolve, reject) {
            var reader = new FileReader();
            reader.onloadend = function () { resolve(reader.result); };
            reader.onerror = reject;
            reader.readAsDataURL(blob);
        });
    }

    function dataUrlToBlobUrl(dataUrl) {
        if (!dataUrl || dataUrl.indexOf('data:') !== 0) return null;
        var m = dataUrl.match(/^data:([^;]+);base64,(.+)$/);
        if (!m) return null;
        var binary = atob(m[2]);
        var len = binary.length;
        var bytes = new Uint8Array(len);
        for (var i = 0; i < len; i++) bytes[i] = binary.charCodeAt(i);
        return URL.createObjectURL(new Blob([bytes], { type: m[1] || 'audio/mpeg' }));
    }

    function buildAudioFileName(row) {
        var base = 'broadcast';
        if (row && row.text) {
            base = row.text.replace(/\s+/g, ' ').trim().slice(0, 24);
            base = base.replace(/[\\/:*?"<>|]/g, '').replace(/\s+/g, '_');
        }
        if (!base) base = 'broadcast';
        var stamp = '';
        if (row && row.createdAt) {
            stamp = String(row.createdAt).replace(/[^\d]/g, '').slice(0, 12);
        }
        if (!stamp) {
            var d = new Date();
            stamp = String(d.getFullYear())
                + String(d.getMonth() + 1).padStart(2, '0')
                + String(d.getDate()).padStart(2, '0')
                + String(d.getHours()).padStart(2, '0')
                + String(d.getMinutes()).padStart(2, '0');
        }
        return base + '_' + stamp + '.mp3';
    }

    function triggerAudioDownload(audioUrl, fileName) {
        if (!audioUrl) return false;
        var a = document.createElement('a');
        a.href = audioUrl;
        a.download = fileName || 'broadcast.mp3';
        a.style.display = 'none';
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        return true;
    }

    function downloadRowAudio(row) {
        if (!row || !row.audioUrl) {
            toast({ title: '다운로드', message: '음성 데이터가 없습니다.', type: 'error' });
            return;
        }
        if (triggerAudioDownload(row.audioUrl, buildAudioFileName(row))) {
            toast({
                title: '다운로드',
                message: '음성 파일을 저장했습니다.',
                type: 'success',
                duration: 2400
            });
        }
    }

    function revokePlayerObjectUrl(audio) {
        if (audio && audio._bcObjectUrl) {
            URL.revokeObjectURL(audio._bcObjectUrl);
            audio._bcObjectUrl = null;
        }
    }

    function setPlayerAudioSource(audio, audioUrl, playbackBlob) {
        clearAudioTimingWatch(audio);
        revokePlayerObjectUrl(audio);
        audio.pause();
        audio.currentTime = 0;
        if (playbackBlob && typeof playbackBlob.size === 'number' && playbackBlob.size > 0) {
            var typedBlob = ensureAudioBlob(playbackBlob);
            audio._bcObjectUrl = URL.createObjectURL(typedBlob);
            audio.src = audio._bcObjectUrl;
        } else if (audioUrl && audioUrl.indexOf('data:') === 0) {
            audio._bcObjectUrl = dataUrlToBlobUrl(audioUrl);
            audio.src = audio._bcObjectUrl || audioUrl;
        } else {
            audio.src = audioUrl || '';
        }
    }

    function startPlayerPlayback(audio, opts) {
        if (!audio || !audio.src) return Promise.resolve();
        opts = opts || {};
        return audio.play().then(function () {
            updatePlayerToggle(true);
        }).catch(function (err) {
            console.warn('audio play failed', err);
            updatePlayerToggle(false);
            if (opts.notifyBlocked) {
                toast({
                    title: '재생',
                    message: '자동 재생이 제한되었습니다. 재생 버튼을 눌러 주세요.',
                    type: 'info',
                    duration: 4000
                });
            }
        });
    }

    function formatAudioTime(sec) {
        if (!isFinite(sec) || sec < 0) return '0:00';
        var s = Math.floor(sec);
        var m = Math.floor(s / 60);
        return m + ':' + String(s % 60).padStart(2, '0');
    }

    function formatTimeRange(audio) {
        if (!audio) return '0:00 / --:--';
        var cur = formatAudioTime(audio.currentTime);
        var dur = isFinite(audio.duration) && audio.duration > 0
            ? formatAudioTime(audio.duration)
            : '--:--';
        return cur + ' / ' + dur;
    }

    function updatePlayerTimeDisplay() {
        var audio = $('playerAudio');
        var el = $('playerTime');
        if (!audio || !el) return;
        el.textContent = formatTimeRange(audio);
    }

    function clearAudioTimingWatch(audio) {
        if (!audio) return;
        if (audio._bcWatchers) {
            audio._bcWatchers.forEach(function (w) {
                audio.removeEventListener(w.ev, w.fn);
            });
            audio._bcWatchers = null;
        }
        if (audio._bcDurTimer) {
            clearTimeout(audio._bcDurTimer);
            audio._bcDurTimer = null;
        }
    }

    function watchAudioTiming(audio, onUpdate) {
        clearAudioTimingWatch(audio);
        if (!audio || typeof onUpdate !== 'function') return;

        audio._bcWatchers = [];
        function add(ev, fn) {
            audio.addEventListener(ev, fn);
            audio._bcWatchers.push({ ev: ev, fn: fn });
        }

        function refresh() {
            onUpdate();
            if (!isFinite(audio.duration) || audio.duration <= 0) {
                if (!audio._bcDurTimer) {
                    audio._bcDurTimer = setTimeout(refresh, 120);
                }
            } else if (audio._bcDurTimer) {
                clearTimeout(audio._bcDurTimer);
                audio._bcDurTimer = null;
            }
        }

        add('loadedmetadata', refresh);
        add('durationchange', refresh);
        add('canplay', refresh);
        add('canplaythrough', refresh);
        add('timeupdate', onUpdate);
        refresh();
        if (audio.readyState < 1) {
            audio.load();
        }
    }

    function revokeHistoryObjectUrl(audio) {
        if (audio && audio._bcHistUrl) {
            URL.revokeObjectURL(audio._bcHistUrl);
            audio._bcHistUrl = null;
        }
    }

    function setHistoryAudioSource(audio, audioUrl) {
        revokeHistoryObjectUrl(audio);
        if (audioUrl && audioUrl.indexOf('data:') === 0) {
            audio._bcHistUrl = dataUrlToBlobUrl(audioUrl);
            audio.src = audio._bcHistUrl || audioUrl;
        } else {
            audio.src = audioUrl || '';
        }
    }

    function updateHistoryItemTime(itemEl) {
        var audio = itemEl ? itemEl.querySelector('.history-audio') : null;
        var el = itemEl ? itemEl.querySelector('[data-role="hist-time"]') : null;
        if (!audio || !el) return;
        el.textContent = formatTimeRange(audio);
    }

    function updateHistoryPlayToggle(itemEl, isPlaying) {
        var icon = itemEl.querySelector('[data-role="hist-play-icon"]');
        var btn = itemEl.querySelector('[data-action="hist-play"]');
        if (icon) icon.textContent = isPlaying ? 'pause' : 'play_arrow';
        if (btn) btn.setAttribute('aria-label', isPlaying ? '일시정지' : '재생');
        itemEl.classList.toggle('is-playing', !!isPlaying);
    }

    function resetHistoryPlayback(itemEl) {
        var audio = itemEl.querySelector('.history-audio');
        if (!audio || !audio.src) return;
        audio.pause();
        try {
            audio.currentTime = 0;
        } catch (ignore) { /* seek */ }
        updateHistoryPlayToggle(itemEl, false);
        updateHistoryItemTime(itemEl);
    }

    function toggleHistoryPlayback(itemEl) {
        var audio = itemEl.querySelector('.history-audio');
        if (!audio || !audio.src) return;
        if (audio.paused) {
            pauseAllBroadcastAudio(audio);
            var eq = $('eqBars');
            if (eq) eq.classList.remove('playing');
            updatePlayerToggle(false);
            var playPromise = audio.play();
            if (playPromise && typeof playPromise.catch === 'function') {
                playPromise.catch(function (err) {
                    console.warn('history audio play failed', err);
                    updateHistoryPlayToggle(itemEl, false);
                });
            }
        } else {
            audio.pause();
        }
    }

    function initHistoryItemPlayer(itemEl, row) {
        var audio = itemEl.querySelector('.history-audio');
        if (!audio || !row) return;

        clearAudioTimingWatch(audio);
        audio.pause();
        audio.preload = 'auto';
        setHistoryAudioSource(audio, row.audioUrl);
        updateHistoryItemTime(itemEl);
        updateHistoryPlayToggle(itemEl, false);

        watchAudioTiming(audio, function () {
            updateHistoryItemTime(itemEl);
        });

        audio.addEventListener('play', function () {
            pauseAllBroadcastAudio(audio);
            var eq = $('eqBars');
            if (eq) eq.classList.remove('playing');
            updatePlayerToggle(false);
            document.querySelectorAll('#historyList .history-item').forEach(function (el) {
                if (el !== itemEl) updateHistoryPlayToggle(el, false);
            });
            updateHistoryPlayToggle(itemEl, true);
        });
        audio.addEventListener('pause', function () {
            updateHistoryPlayToggle(itemEl, false);
        });
        audio.addEventListener('ended', function () {
            try {
                audio.currentTime = 0;
            } catch (ignore) { /* ended */ }
            updateHistoryPlayToggle(itemEl, false);
            updateHistoryItemTime(itemEl);
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
            toast({
                title: '이력 저장 실패',
                message: '브라우저 저장 공간이 부족합니다. 이력을 줄이거나 짧은 문구로 변환해 주세요.',
                type: 'warning',
                duration: 5000
            });
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

    function getTtsErrorMessage(e) {
        if (e && e.name === 'AbortError') return '';
        var msg = 'TTS 서버 연결에 실패했습니다. 서버 실행 상태를 확인해주세요.';
        if (e && e.status === 403) {
            msg = '요청이 차단되었습니다(403). 페이지를 새로고침한 뒤 다시 시도해주세요.';
        } else if (String(e && e.message || '').indexOf('not audio') !== -1) {
            msg = '서버가 음성이 아닌 응답을 반환했습니다. 로그인·권한(CSRF) 또는 TTS 설정을 확인해주세요.';
        } else if (String(e && e.message || '').indexOf('invalid mp3') !== -1) {
            msg = '음성 데이터 형식이 올바르지 않습니다. Google TTS 키·서버 로그를 확인해주세요.';
        } else if (String(e && e.message || '').indexOf('TTS failed: 500') !== -1) {
            msg = 'TTS 변환 중 서버 오류가 발생했습니다. IntelliJ 로그의 "TTS 변환 실패"를 확인해주세요.';
        }
        return msg;
    }

    function synthesizeTtsRequest(v, signal) {
        var formBody = new URLSearchParams();
        formBody.set('text', v.text);
        formBody.set('languageCode', v.lang);
        formBody.set('voiceName', v.voice);
        return fetch(cfg.contextPath + '/tts/synthesize/' + cfg.mgmtOfcNo, {
            method: 'POST',
            credentials: 'same-origin',
            headers: buildTtsFetchHeaders('application/x-www-form-urlencoded;charset=UTF-8'),
            body: formBody.toString(),
            signal: signal
        })
            .then(function (res) {
                var ct = (res.headers.get('content-type') || '').toLowerCase();
                if (!res.ok) {
                    var err = new Error('TTS failed: ' + res.status + (ct ? ' (' + ct + ')' : ''));
                    err.status = res.status;
                    throw err;
                }
                if (ct.indexOf('audio/') === -1) {
                    throw new Error('not audio response: ' + (ct || 'unknown'));
                }
                return res.blob();
            })
            .then(function (blob) {
                if (!blob || blob.size < 128) {
                    throw new Error('empty audio blob');
                }
                return isLikelyMp3Blob(blob).then(function (ok) {
                    if (!ok) {
                        throw new Error('invalid mp3 payload');
                    }
                    var audioBlob = ensureAudioBlob(blob);
                    return blobToDataUrl(audioBlob).then(function (dataUrl) {
                        return { blob: audioBlob, dataUrl: dataUrl };
                    });
                });
            });
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
        if (!btn) return;
        previewActive = !!on;
        if (on) {
            btn.classList.add('listening');
            btn.disabled = false;
            btn.setAttribute('aria-label', '정지');
            btn.innerHTML = '<span class="material-symbols-rounded">stop</span>정지';
        } else {
            btn.classList.remove('listening');
            btn.setAttribute('aria-label', '미리듣기');
            btn.innerHTML = PREVIEW_BTN_HTML;
        }
    }

    function setPreviewLoading(on) {
        var btn = $('previewBtn');
        if (!btn) return;
        if (on) {
            btn.disabled = true;
            btn.classList.remove('listening');
            btn.setAttribute('aria-label', '변환 중');
            btn.innerHTML = '<span class="material-symbols-rounded">hourglass_empty</span>변환중';
        } else if (!previewActive) {
            btn.disabled = false;
            btn.setAttribute('aria-label', '미리듣기');
            btn.innerHTML = PREVIEW_BTN_HTML;
        }
    }

    function stopPreview() {
        previewToken += 1;
        previewActive = false;
        if (previewFetchAbort) {
            previewFetchAbort.abort();
            previewFetchAbort = null;
        }
        setPreviewState(false);
        var audio = $('previewAudio');
        if (audio) {
            clearAudioTimingWatch(audio);
            audio.pause();
            revokePlayerObjectUrl(audio);
            audio.removeAttribute('src');
            audio.load();
        }
    }

    function startPreviewPlayback(blob, dataUrl) {
        var audio = $('previewAudio');
        if (!audio) return;
        pauseAllBroadcastAudio(audio);
        setPlayerAudioSource(audio, dataUrl, blob);
        audio.preload = 'auto';

        function onPreviewEnd() {
            stopPreview();
        }

        audio.addEventListener('ended', onPreviewEnd, { once: true });
        audio.addEventListener('error', function () {
            stopPreview();
            toast({
                title: '미리듣기 실패',
                message: '음성을 재생할 수 없습니다.',
                type: 'error'
            });
        }, { once: true });

        var playPromise = audio.play();
        if (playPromise && typeof playPromise.then === 'function') {
            playPromise.then(function () {
                setPreviewState(true);
            }).catch(function (err) {
                console.warn('preview play failed', err);
                stopPreview();
                toast({
                    title: '미리듣기',
                    message: '자동 재생이 제한되었습니다. 다시 시도해 주세요.',
                    type: 'info',
                    duration: 4000
                });
            });
        } else {
            setPreviewState(true);
        }
    }

    function togglePreview() {
        if (previewActive) {
            stopPreview();
            return;
        }

        var v = getFormValues();
        if (!v.text) {
            toast({ title: '입력 필요', message: '미리 들을 문구를 입력해주세요.', type: 'warning' });
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

        stopPreview();
        var ac = new AbortController();
        previewFetchAbort = ac;
        var token = previewToken;
        setPreviewLoading(true);

        synthesizeTtsRequest(v, ac.signal)
            .then(function (result) {
                if (token !== previewToken) return;
                startPreviewPlayback(result.blob, result.dataUrl);
            })
            .catch(function (e) {
                if (e && e.name === 'AbortError') return;
                console.error(e);
                var msg = getTtsErrorMessage(e);
                if (msg) {
                    toast({ title: '미리듣기 실패', message: msg, type: 'error', duration: 5000 });
                }
            })
            .finally(function () {
                previewFetchAbort = null;
                setPreviewLoading(false);
            });
    }

    function setPlayerControlsEnabled(enabled) {
        var playBtn = $('playerToggleBtn');
        var resetBtn = $('playerResetBtn');
        var downloadBtn = $('playerDownloadBtn');
        var broadcastBtn = $('broadcastBtn');
        if (playBtn) playBtn.disabled = !enabled;
        if (resetBtn) resetBtn.disabled = !enabled;
        if (downloadBtn) downloadBtn.disabled = !enabled;
        if (broadcastBtn && !broadcastActive) broadcastBtn.disabled = !enabled;
    }

    function setBroadcastButtonState(disabled, broadcasting) {
        var btn = $('broadcastBtn');
        if (!btn) return;
        btn.disabled = !!disabled;
        btn.classList.toggle('is-broadcasting', !!broadcasting);
    }

    function finishBroadcastSession(showCompleteToast) {
        if (!broadcastActive && !showCompleteToast) return;
        broadcastActive = false;
        var audio = $('playerAudio');
        var hasAudio = !!(audio && audio.src);
        setBroadcastButtonState(!hasAudio, false);
        if (showCompleteToast) {
            toast({
                title: '방송 완료',
                message: '방송 완료',
                type: 'success',
                duration: 2800
            });
        }
    }

    function startBroadcast() {
        var audio = $('playerAudio');
        if (!audio || !audio.src || broadcastActive) return;

        stopPreview();
        pauseAllBroadcastAudio(audio);
        broadcastActive = true;
        setBroadcastButtonState(true, true);
        toast({
            title: '방송중',
            message: '방송 송출 중...',
            type: 'info',
            duration: 3500
        });

        try {
            audio.currentTime = 0;
        } catch (ignore) { /* seek */ }

        audio.addEventListener('ended', function () {
            finishBroadcastSession(true);
        }, { once: true });

        var playPromise = audio.play();
        if (playPromise && typeof playPromise.then === 'function') {
            playPromise.catch(function (err) {
                console.warn('broadcast play failed', err);
                finishBroadcastSession(false);
                toast({
                    title: '방송 실패',
                    message: '음성을 재생할 수 없습니다.',
                    type: 'error',
                    duration: 4000
                });
            });
        }
    }

    function resetPlayerPlayback() {
        var audio = $('playerAudio');
        if (!audio || !audio.src) return;
        audio.pause();
        try {
            audio.currentTime = 0;
        } catch (ignore) { /* 일부 브라우저 */ }
        var eq = $('eqBars');
        if (eq) eq.classList.remove('playing');
        updatePlayerToggle(false);
        updatePlayerTimeDisplay();
    }

    function hidePlayer() {
        finishBroadcastSession(false);
        currentPlayerRow = null;
        var audio = $('playerAudio');
        if (audio) {
            clearAudioTimingWatch(audio);
            audio.pause();
            revokePlayerObjectUrl(audio);
            audio.removeAttribute('src');
            audio.load();
        }
        updatePlayerToggle(false);
        updatePlayerTimeDisplay();
        setPlayerControlsEnabled(false);
        $('eqBars').classList.remove('playing');
        $('playerCard').style.display = 'none';
    }

    function pauseAllBroadcastAudio(exceptEl) {
        var main = $('playerAudio');
        if (main && main !== exceptEl && !main.paused) {
            main.pause();
            updatePlayerToggle(false);
        }
        var preview = $('previewAudio');
        if (preview && preview !== exceptEl && !preview.paused) {
            preview.pause();
            if (previewActive) stopPreview();
        }
        document.querySelectorAll('#historyList .history-item').forEach(function (itemEl) {
            var a = itemEl.querySelector('.history-audio');
            if (!a || a === exceptEl) return;
            if (!a.paused) a.pause();
            updateHistoryPlayToggle(itemEl, false);
        });
    }

    function updatePlayerToggle(isPlaying) {
        var icon = $('playerToggleIcon');
        var btn = $('playerToggleBtn');
        if (!icon || !btn) return;
        icon.textContent = isPlaying ? 'pause' : 'play_arrow';
        btn.setAttribute('aria-label', isPlaying ? '일시정지' : '재생');
    }

    function showPlayer(row, label, playbackBlob) {
        var audio = $('playerAudio');
        if (!audio) return;
        currentPlayerRow = row || null;
        $('playerLabel').textContent = label || '최근 변환 음성';
        $('playerText').textContent = row.text;
        pauseAllBroadcastAudio();
        setPlayerAudioSource(audio, row.audioUrl, playbackBlob);
        $('playerCard').style.display = 'block';
        updatePlayerToggle(false);
        updatePlayerTimeDisplay();

        if (!audio.src) {
            setPlayerControlsEnabled(false);
            toast({ title: '재생 불가', message: '음성 데이터가 없습니다.', type: 'error' });
            return;
        }
        setPlayerControlsEnabled(true);
        audio.preload = 'auto';
        watchAudioTiming(audio, updatePlayerTimeDisplay);

        audio.addEventListener('error', function () {
            updatePlayerToggle(false);
            setPlayerControlsEnabled(false);
            var code = audio.error ? audio.error.code : 0;
            console.warn('playerAudio error', code, audio.src);
            toast({
                title: '재생 불가',
                message: '음성 파일을 불러오지 못했습니다. 변환을 다시 시도해 주세요.',
                type: 'error'
            });
        }, { once: true });
    }

    function bindPlayerControls() {
        var audio = $('playerAudio');
        var toggle = $('playerToggleBtn');
        var resetBtn = $('playerResetBtn');
        var eq = $('eqBars');
        if (!audio || !toggle) return;

        if (resetBtn) {
            resetBtn.addEventListener('click', function (e) {
                e.preventDefault();
                e.stopPropagation();
                resetPlayerPlayback();
            });
        }

        var broadcastBtn = $('broadcastBtn');
        if (broadcastBtn) {
            broadcastBtn.addEventListener('click', function (e) {
                e.preventDefault();
                e.stopPropagation();
                if (broadcastBtn.disabled || broadcastActive) return;
                startBroadcast();
            });
        }

        var downloadBtn = $('playerDownloadBtn');
        if (downloadBtn) {
            downloadBtn.addEventListener('click', function (e) {
                e.preventDefault();
                e.stopPropagation();
                if (downloadBtn.disabled) return;
                downloadRowAudio(currentPlayerRow);
            });
        }

        toggle.addEventListener('click', function (e) {
            e.preventDefault();
            e.stopPropagation();
            if (!audio.src) return;
            if (audio.paused) {
                pauseAllBroadcastAudio(audio);
                if (audio.readyState < 2) {
                    audio.addEventListener('canplay', function () {
                        startPlayerPlayback(audio);
                    }, { once: true });
                    if (!audio.src) return;
                    audio.load();
                } else {
                    startPlayerPlayback(audio);
                }
            } else {
                audio.pause();
            }
        });

        audio.addEventListener('play', function () {
            pauseAllBroadcastAudio(audio);
            document.querySelectorAll('#historyList .history-item').forEach(function (el) {
                updateHistoryPlayToggle(el, false);
            });
            if (eq) eq.classList.add('playing');
            updatePlayerToggle(true);
        });
        audio.addEventListener('pause', function () {
            if (eq) eq.classList.remove('playing');
            updatePlayerToggle(false);
            if (broadcastActive) {
                finishBroadcastSession(false);
            }
        });
        audio.addEventListener('ended', function () {
            if (eq) eq.classList.remove('playing');
            updatePlayerToggle(false);
            try {
                audio.currentTime = 0;
            } catch (ignore) { /* ended 후 seek */ }
            updatePlayerTimeDisplay();
        });

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
        if (note) {
            if (tab === 'history') {
                note.hidden = true;
                note.textContent = '';
            } else {
                note.hidden = false;
                note.textContent = SOURCE_NOTES[tab] || '';
            }
        }
    }

    function renderDummyPanel(type, items) {
        var panel = $('panel' + (type === 'check' ? 'Check' : 'Complaint'));
        if (!panel) return;
        panel.innerHTML = '<div class="source-list">' + items.map(function (item) {
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
        list.querySelectorAll('.history-audio').forEach(function (a) {
            clearAudioTimingWatch(a);
            revokeHistoryObjectUrl(a);
        });
        list.innerHTML = historyRows.map(function (row, idx) {
            var title = row.text.length > 40 ? row.text.slice(0, 40) + '...' : row.text;
            return '<div class="history-item" data-idx="' + idx + '">'
                + '<div class="h-text"><div class="h-title">' + escapeHtml(title) + '</div>'
                + '<div class="h-meta">' + escapeHtml(row.area) + ' · ' + escapeHtml(row.createdAt) + '</div></div>'
                + '<div class="history-item-foot">'
                + '<div class="history-playback">'
                + '<div class="player-sq-btns history-sq-btns" role="group" aria-label="이력 음성 재생">'
                + '<button type="button" class="bc-sq-btn bc-sq-btn--light" data-action="hist-play" title="재생" aria-label="재생">'
                + '<span class="material-symbols-rounded" data-role="hist-play-icon">play_arrow</span></button>'
                + '<button type="button" class="bc-sq-btn bc-sq-btn--light bc-sq-btn-reset" data-action="hist-reset" title="재생 초기화" aria-label="재생 초기화">'
                + '<span class="bc-stop-mark" aria-hidden="true"></span></button>'
                + '</div>'
                + '<span class="history-time" data-role="hist-time">0:00 / --:--</span>'
                + '<audio class="history-audio" preload="metadata"></audio>'
                + '</div>'
                + '<div class="h-actions">'
                + '<button type="button" class="btnx btnx-ghost btnx-sm" data-action="download" title="다운로드">'
                + '<span class="material-symbols-rounded">download</span></button>'
                + '<button type="button" class="btnx btnx-ghost btnx-sm" data-action="reuse">불러오기</button>'
                + '<button type="button" class="btnx btnx-ghost btnx-sm h-btn-remove" data-action="remove">삭제</button>'
                + '</div></div></div>';
        }).join('');

        list.querySelectorAll('.history-item').forEach(function (itemEl) {
            var idx = Number(itemEl.getAttribute('data-idx'));
            if (Number.isFinite(idx) && historyRows[idx]) {
                initHistoryItemPlayer(itemEl, historyRows[idx]);
            }
        });
    }

    function loadHistoryToComposer(row) {
        if (!row) return;
        stopPreview();
        $('ttsText').value = row.text || '';
        selectAreas(row.areas && row.areas.length ? row.areas : [row.area]);
        selectVoice(row.voice, row.voiceLabel);
        updateMeta();
        showPlayer(row, '이력에서 불러온 음성');
        $('ttsText').focus();
    }

    function resetComposer() {
        stopPreview();
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

        stopPreview();
        setComposeLoading(true);
        synthesizeTtsRequest(v)
            .then(function (result) {
                historyRows.unshift({
                    text: v.text,
                    voice: v.voice,
                    areas: v.areas,
                    area: v.area,
                    voiceLabel: v.voiceLabel,
                    createdAt: nowKST(),
                    audioUrl: result.dataUrl
                });
                if (historyRows.length > HISTORY_MAX) historyRows.length = HISTORY_MAX;
                saveHistory();
                renderHistory();
                showPlayer(historyRows[0], undefined, result.blob);
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
                var msg = getTtsErrorMessage(e);
                if (msg) {
                    toast({
                        title: '변환 실패',
                        message: msg,
                        type: 'error',
                        duration: 5000
                    });
                }
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
            if (btn.getAttribute('data-action') === 'hist-play') {
                toggleHistoryPlayback(item);
                return;
            }
            if (btn.getAttribute('data-action') === 'hist-reset') {
                resetHistoryPlayback(item);
                return;
            }
            if (btn.getAttribute('data-action') === 'download') {
                downloadRowAudio(historyRows[idx]);
                return;
            }
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
