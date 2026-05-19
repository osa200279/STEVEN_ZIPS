import { useState, useEffect } from 'react';
import { Button } from '../../../components/common/Button';
import { getSido, getSigungu, getEmd, getAptList, toSelectOptions, getAptDetail, getSubmitDocTypes } from '../../../util/api/annRegister/annRegister';
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

export default function AnnRegister() {
  // ─────────────────────────────────────────
  // STATE - 여기서만 관리하고 props로 내려줌
  // ─────────────────────────────────────────

  // 선택값
  const [sido, setsido] = useState('');
  const [sigungu, setsigungu] = useState('');
  const [emd, setemd] = useState('');
  const [aptCmplexNo, setAptCmplexNo] = useState('');
  const [addr, setAddr] = useState('');

  // 목록
  const [sidoOptions, setSidoOptions] = useState([]);
  const [sigunguOptions, setSigunguOptions] = useState([]);
  const [emdOptions, setemdOptions] = useState([]);
  const [aptOptions, setAptOptions] = useState([]);

  // 타입 테이블
  const [hoTyList, setHoTyList] = useState([]);

  // 제출서류
  const [submitDocOptions, setSubmitDocOptions] = useState([]);
  const [selectedDocs, setSelectedDocs] = useState([]);

  // ─────────────────────────────────────────
  // 1. 시도 목록 조회
  // 페이지 진입 시 한 번만 실행
  // getSido() 호출 → setSidoOptions
  // ─────────────────────────────────────────
  useEffect(() => {
    getSido()
      .then((data) => {
        console.log('시도 리스트:', data, '배열?', Array.isArray(data));
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
        console.log('시군구 리스트:', data);
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
        console.log('읍면동 데이터:', data);
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
        console.log('아파트 데이터터:', data);
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
      console.log("아파트 상세 테스트:", data);

      const docData = await getSubmitDocTypes(aptCmplexNo);
      console.log("제출서류 리스트:", docData);

      if (data.success) {
        setAddr(data.dorojuso);
        setHoTyList(data.hoTyNo);
      }
      if(docData.success){
        setSubmitDocOptions(docData.list.map(item => (
          {
            value:item.SBMSN_DOC_TY_CD,
            label:item.CODE_NAME
          }
        )))
      }
    }catch (e){
      console.log('에러', e)
    }
  };


  // ─────────────────────────────────────────
  // 6. 등록 버튼
  // formData 구성 후 insertAnnouncement(formData) 호출
  // 성공: alert('등록 완료')
  // 실패: alert(data.message)
  // ─────────────────────────────────────────
  const handleSubmit = () => {

  
  };

  // ─────────────────────────────────────────
  // 상위 선택 바뀌면 하위 초기화
  // ─────────────────────────────────────────
  const resetBelow = () => {
    setAptCmplexNo('');
    setAddr('');
    setHoTyList([]);
  };

  return (
    <>
      <style>{ANN_PAGE_CSS}</style>
      <div className="content-wrapper ann-register-full">
        <header className="page-header" style={{ alignItems: 'flex-start' }}>
          <h1 className="page-title">공고 등록</h1>
        </header>

        <div className="form-sections-stack">
          <BasicInfoSection />
          <AnnInfoSection />
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
            handleAptChange={handleAptChange}
            resetBelow={resetBelow}
          />
          <SubmitDocSection 
            submitDocOptions={submitDocOptions}
            selectedDocs={selectedDocs}
            setSelectedDocs={setSelectedDocs}
          />
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
          <Button type="button" className="btn-primary" onClick={handleSubmit}>
            등록
          </Button>
        </footer>
      </div>
    </>
  );
}
