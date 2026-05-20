import { useState, useEffect } from 'react';
import { Button } from '../../../components/common/Button';
import { getSido, getSigungu, getEmd, getAptList, toSelectOptions, getAptDetail, getSubmitDocTypes, insertAnn } from '../../../util/api/annRegister/annRegister';
import BasicInfoSection from './BasicInfoSection';
import AnnInfoSection from './AnnInfoSection';
import SupplyInfoSection from './SupplyInfoSection';
import SubmitDocSection from './SubmitDocSection';

/** 페이지 전용 레이아웃·표 (common.css 미수정) */
const ANN_PAGE_CSS = `
.content-wrapper.ann-register-full {
  max-width: none;
  width: 100%;
  min-height: calc(100vh - 120px);
}
.content-wrapper.ann-register-full .form-sections-stack {
  flex: 1 1 auto;
}
.ann-supply-table tbody tr {
  transition: none;
}
.ann-supply-table tbody tr:hover {
  background-color: transparent;
}
`;

/** insertAnn API 필드명과 동일 (ttl, cn, pblanc*, rcrt*) — mvinPrdDt는 전송 시 rcrtEndDt로 채움 */
const INITIAL_ANN_FORM = {
  ttl: '',
  cn: '',
  pblancBgngDt: '',
  pblancEndDt: '',
  rcrtBgngDt: '',
  rcrtEndDt: '',
};

/** YYYY-MM-DD 문자열 비교 (동일 포맷 전제) */
function assertDateOrder(pubS, pubE, rcS, rcE) {
  if (pubS > pubE) return '게시 시작일은 게시 종료일보다 앞서야 합니다.';
  if (rcS > rcE) return '모집 시작일은 모집 종료일보다 앞서야 합니다.';
  return null;
}

export default function AnnRegister() {
  // ── 폼 입력 (BasicInfoSection · AnnInfoSection — 필드명 = insertAnn body) ──
  const [annForm, setAnnForm] = useState(INITIAL_ANN_FORM);
  const setAnnField = (name, value) =>
    setAnnForm((prev) => ({ ...prev, [name]: value }));

  // ── 공급 정보: 지역·단지 cascade (SupplyInfoSection) ──
  const [sido, setsido] = useState('');
  const [sigungu, setsigungu] = useState('');
  const [emd, setemd] = useState('');
  const [aptCmplexNo, setAptCmplexNo] = useState('');
  const [addr, setAddr] = useState(''); // 단지 선택 시 aptDetail API로 채움 (읽기 전용)

  // ── 공급 정보: select option 목록 (useEffect로 API 조회) ──
  const [sidoOptions, setSidoOptions] = useState([]);
  const [sigunguOptions, setSigunguOptions] = useState([]);
  const [emdOptions, setemdOptions] = useState([]);
  const [aptOptions, setAptOptions] = useState([]);

  // ── 공급 정보: 단지 상세 (aptDetail API → 호 타입 표) ──
  const [hoTyList, setHoTyList] = useState([]);

  // ── 제출 서류 (sbmsnDocList API · 조회 후 등록 시 sbmsnDoc 문자열로 저장) ──
  const [submitDocOptions, setSubmitDocOptions] = useState([]); // { value, label }[]

  const [submitting, setSubmitting] = useState(false);

  const resetEntireForm = () => {
    setAnnForm({ ...INITIAL_ANN_FORM });
    setsido('');
    setsigungu('');
    setemd('');
    setAptCmplexNo('');
    setAddr('');
    setHoTyList([]);
    setSubmitDocOptions([]);
  };

  // ─────────────────────────────────────────
  // 1. 시도 목록 조회
  // 페이지 진입 시 한 번만 실행
  // getSido() 호출 → setSidoOptions
  // ─────────────────────────────────────────
  useEffect(() => {
    getSido()
      .then((data) => {
        setSidoOptions(toSelectOptions(data));
      })
      .catch((e) => console.error('시도 조회 오류', e));
  }, []);

  // ─────────────────────────────────────────
  // 2. 시군구 목록 조회
  // sido 바뀔 때마다 실행
  // sido 없으면 setSigunguOptions([]) 초기화 후 return
  // getSigungu(sido) 호출 → setSigunguOptions
  // ─────────────────────────────────────────
  useEffect(() => {
    if (!sido) {
      setSigunguOptions([]);
      return;
    }
    getSigungu(sido)
      .then((data) => {
        setSigunguOptions(toSelectOptions(data));
      })
      .catch((e) => console.error('시군구 조회 오류', e));
  }, [sido]);

  // ─────────────────────────────────────────
  // 3. 읍면동 목록 조회
  // sigungu 바뀔 때마다 실행
  // sigungu 없으면 setemdOptions([]) 초기화 후 return
  // getEmd(sido, sigungu) 호출 → setemdOptions
  // ─────────────────────────────────────────
  useEffect(() => {
    if (!sigungu) {
      setemdOptions([]);
      return;
    }
    getEmd(sido, sigungu)
      .then((data) => {
        setemdOptions(toSelectOptions(data));
      })
      .catch((e) => console.error('읍면동 조회 오류', e));
  }, [sigungu, sido]);

  // ─────────────────────────────────────────
  // 4. 단지 목록 조회
  // sido, sigungu, emd 중 하나라도 바뀌면 실행
  // sido 없으면 setAptOptions([]) 초기화 후 return
  // getAptList(sido, sigungu || null, emd || null) 호출 → setAptOptions
  // sigungu, emd는 없어도 되는 값이라 null로 처리
  // ─────────────────────────────────────────

  useEffect(() => {
    if (!sido) {
      setAptOptions([]);
      return;
    }
    getAptList(sido, sigungu, emd)
      .then((data) => {
        setAptOptions(toSelectOptions(data));
      })
      .catch((e) => console.error('단지 조회 오류', e));
  }, [sido, sigungu, emd]);

  // ─────────────────────────────────────────
  // 5. 단지 선택 시 주소 + 타입 자동완성 + 제출서류 조회
  // e.target.value → aptCmplexNo 저장
  // 없으면 addr, hoTyList 초기화 후 return
  // getAptDetail(aptCmplexNo) 호출
  // → setAddr(data.dorojuso)
  // → setHoTyList(data.hoTyList)
  // ─────────────────────────────────────────
  const handleAptChange = async (e) => {
    const aptCmplexNo = e.target.value;
    setAptCmplexNo(aptCmplexNo);

    if(!aptCmplexNo){
      setAddr('');
      setAptCmplexNo('');
      setHoTyList([]);
      setSubmitDocOptions([]);
      return;
    }

    try{
      const data = await getAptDetail(aptCmplexNo);

      const docData = await getSubmitDocTypes(aptCmplexNo);

      if (data.success) {
        setAddr(data.dorojuso);
        setHoTyList(data.hoTyNo);
      }
      if (docData.success && Array.isArray(docData.list)) {
        setSubmitDocOptions(
          docData.list.map((item) => ({
            value: String(item.SBMSN_DOC_TY_CD ?? item.sbmsn_doc_ty_cd ?? ''),
            label: String(item.CODE_NAME ?? item.code_name ?? ''),
          })).filter((o) => o.value && o.label)
        );
      } else {
        setSubmitDocOptions([]);
      }
    }catch (e){
      console.error('단지 상세·제출서류 조회 오류', e);
    }
  };


  /** 사용자 공고 상세 JSP: sbmsn_doc를 쉼표 구분 문자열로 저장 */
  const buildSbmsnDoc = () =>
    submitDocOptions.map((o) => o.label).join(', ');

  /** DB insert용: 입주 예정일 컬럼은 모집 종료일과 동일하게 전달 */
  const getInsertPayload = () => ({
    ...annForm,
    ttl: annForm.ttl.trim(),
    cn: annForm.cn.trim(),
    aptCmplexNo,
    sbmsnDoc: buildSbmsnDoc(),
    mvinPrdDt: annForm.rcrtEndDt,
  });

  // ── 등록: insertAnn(getInsertPayload()) ──
  const handleSubmit = async () => {
    if (submitting) return;
    if (!annForm.ttl.trim()) return alert('공고 제목을 입력하세요');
    if (!annForm.cn.trim()) return alert('공고 내용을 입력하세요');
    if (!aptCmplexNo) return alert('아파트 단지를 선택하세요');
    const { pblancBgngDt, pblancEndDt, rcrtBgngDt, rcrtEndDt } = annForm;
    if (!pblancBgngDt || !pblancEndDt || !rcrtBgngDt || !rcrtEndDt) {
      return alert('게시·모집 기간을 모두 입력하세요');
    }
    const dateErr = assertDateOrder(pblancBgngDt, pblancEndDt, rcrtBgngDt, rcrtEndDt);
    if (dateErr) return alert(dateErr);

    setSubmitting(true);
    try {
      const data = await insertAnn(getInsertPayload());
      if (data.success) {
        alert('등록 완료');
        resetEntireForm();
      } else {
        alert(data.message ?? data.messeage ?? '등록 실패');
      }
    } catch (e) {
      console.error(e);
      alert('등록 중 오류가 발생했습니다.');
    } finally {
      setSubmitting(false);
    }
  };

  // ─────────────────────────────────────────
  // 상위 선택 바뀌면 하위 초기화
  // ─────────────────────────────────────────
  const resetBelow = () => {
    setAptCmplexNo('');
    setAddr('');
    setHoTyList([]);
    setSubmitDocOptions([]);
  };

  return (
    <>
      <style>{ANN_PAGE_CSS}</style>
      <div className="content-wrapper ann-register-full">
        <header className="page-header" style={{ alignItems: 'flex-start' }}>
          <h1 className="page-title">공고 등록</h1>
        </header>

        <div className="form-sections-stack">
          <BasicInfoSection annForm={annForm} onFieldChange={setAnnField} />
          <AnnInfoSection annForm={annForm} onFieldChange={setAnnField} />
          <SupplyInfoSection
            sido={sido}
            setsido={setsido}
            sigungu={sigungu}
            setsigungu={setsigungu}
            emd={emd}
            setemd={setemd}
            aptCmplexNo={aptCmplexNo}
            setAptCmplexNo={setAptCmplexNo}
            setAddr={setAddr}
            addr={addr}
            sidoOptions={sidoOptions}
            sigunguOptions={sigunguOptions}
            emdOptions={emdOptions}
            aptOptions={aptOptions}
            setHoTyList={setHoTyList}
            hoTyList={hoTyList}
            setSubmitDocOptions={setSubmitDocOptions}
            handleAptChange={handleAptChange}
            resetBelow={resetBelow}
          />
          <SubmitDocSection submitDocOptions={submitDocOptions} />
        </div>

        <footer
          style={{
            display: 'flex',
            justifyContent: 'flex-end',
            gap: 12,
            paddingTop: 20,
            marginTop: 'auto',
            borderTop: '1px solid var(--outline-variant)',
          }}
        >
          <Button
            type="button"
            className="btn-primary"
            onClick={handleSubmit}
            disabled={submitting}
          >
            {submitting ? '등록 중…' : '등록'}
          </Button>
        </footer>
      </div>
    </>
  );
}
