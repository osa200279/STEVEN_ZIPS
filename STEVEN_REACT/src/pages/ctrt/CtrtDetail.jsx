import React from 'react';
import '../../styles/common.css';
import { useParams } from 'react-router-dom';

const CtrtDetail = () => {

  const { RENT_CTRT_NO } = useParams();
  console.log(RENT_CTRT_NO);

  return (
    <div className="content-wrapper" style={{ paddingTop: '20px' }}>
      <div className="form-max-container" style={{ maxWidth: '1440px', width: '100%' }}>

        {/* 타이틀 영역 */}
        <div className="page-header" style={{ marginBottom: '20px' }}>
          <div>
            <h2 className="page-title" style={{ fontSize: '24px' }}>계약 상세 정보</h2>
            <p className="page-subtitle" style={{ fontSize: '13px' }}>Contract Detail</p>
          </div>
          <div className="header-actions">
            <button className="btn-outline" style={{ padding: '6px 12px', fontSize: '13px' }}>목록으로</button>
            <button className="btn-primary" style={{ padding: '6px 12px', fontSize: '13px' }}>수정하기</button>
          </div>
        </div>

        {/* 2단 메인 그리드 */}
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: '16px' }}>

          {/* 1. 계약 기본 정보 (상단 전체 너비) */}
          <div className="compact-card" style={{ gridColumn: '1 / -1' }}>
            <h3 className="compact-card-title">
              계약 기본 정보
            </h3>
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(6, 1fr)', gap: '12px' }}>
              <div className="compact-input-group">
                <label>계약 번호</label>
                <input type="text" value="CTRT-2024-001" readOnly />
              </div>
              <div className="compact-input-group">
                <label>계약 상태</label>
                <input type="text" value="계약완료(2026.05.15)" readOnly className="font-bold text-primary-color" />
              </div>
              <div className="compact-input-group">
                <label>임대매물번호</label>
                <input type="text" value="LSTG-9923" readOnly />
              </div>
              <div className="compact-input-group">
                <label>임대모집유형</label>
                <input type="text" value="R-TYPE-A" readOnly />
              </div>
              <div className="compact-input-group">
                <label>담당자 (배정일)</label>
                <input type="text" value="김담당 (24.08.01)" readOnly />
              </div>
            </div>
          </div>

          {/* 좌측 영역 (매물/임차인 + 특약/서류) */}
          <div style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>

            <div className="compact-card">
              <h3 className="compact-card-title">
                <span className="material-symbols-outlined">person</span>
                매물 및 임차인 정보
              </h3>
              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: '12px' }}>
                <div className="compact-input-group" style={{ gridColumn: '1 / -1' }}>
                  <label>아파트 정보</label>
                  <input type="text" value="[APT-01] 래미안 센트럴 101동 1201호" readOnly />
                </div>
                <div className="compact-input-group">
                  <label>임차인 이름</label>
                  <input type="text" value="홍길동" readOnly />
                </div>
                <div className="compact-input-group">
                  <label>임차인 ID (번호)</label>
                  <input type="text" value="user123 (U-8821)" readOnly />
                </div>
              </div>
            </div>

            <div className="compact-card" style={{ flex: 1 }}>
              <h3 className="compact-card-title">
                <span className="material-symbols-outlined">fact_check</span>
                특약 및 서류
              </h3>
              <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
                <div className="compact-input-group">
                  <label>특약 사항</label>
                  <textarea
                    readOnly
                    style={{ resize: 'none', height: '60px' }}
                    value="1. 반려동물 사육 금지&#13;&#10;2. 퇴거 시 기본 청소비 10만원 공제"
                  />
                </div>
                <div className="compact-input-group">
                  <label>제출 서류</label>
                  <div className="upload-dropzone" style={{ padding: '12px', borderRadius: '8px', minHeight: 'auto' }}>
                    <p className="upload-main-text" style={{ fontSize: '13px', margin: '0 0 2px 0' }}>첨부 서류 2건</p>
                    <p className="upload-sub-text" style={{ fontSize: '11px' }}>신분증_사본.pdf, 가족관계증명서.png</p>
                  </div>
                </div>
              </div>
            </div>
          </div>

          {/* 우측 영역 (금액 + 일정/관계자) */}
          <div style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>

            <div className="compact-card">
              <h3 className="compact-card-title">
                <span className="material-symbols-outlined">payments</span>
                금액 정보
              </h3>
              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: '12px' }}>
                <div className="compact-input-group" style={{ gridColumn: '1 / -1' }}>
                  <label>임대 유형</label>
                  <input type="text" value="월세" readOnly />
                </div>
                <div className="compact-input-group">
                  <label>보증금</label>
                  <input type="text" value="50,000,000 원" readOnly className="text-right" />
                </div>
                <div className="compact-input-group">
                  <label>계약금</label>
                  <input type="text" value="5,000,000 원" readOnly className="text-right" />
                </div>
                <div className="compact-input-group">
                  <label>중도금</label>
                  <input type="text" value="20,000,000 원" readOnly className="text-right" />
                </div>
                <div className="compact-input-group">
                  <label>잔금</label>
                  <input type="text" value="25,000,000 원" readOnly className="text-right" />
                </div>
                <div className="compact-input-group" style={{ gridColumn: '1 / -1' }}>
                  <label>월세</label>
                  <input type="text" value="1,200,000 원" readOnly className="text-right font-bold text-primary-color" />
                </div>
              </div>
            </div>

            <div className="compact-card" style={{ flex: 1 }}>
              <h3 className="compact-card-title">
                <span className="material-symbols-outlined">calendar_month</span>
                일정 및 관계자 정보
              </h3>
              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: '12px' }}>
                <div className="compact-input-group">
                  <label>입주 예정일</label>
                  <input type="text" value="2024.09.01" readOnly />
                </div>
                <div className="compact-input-group">
                  <label>퇴거일 (완료일)</label>
                  <input type="text" value="2026.08.31 (-)" readOnly />
                </div>
                <div className="compact-input-group">
                  <label>임대인</label>
                  <input type="text" value="이건물 (010-1111-2222)" readOnly />
                </div>
                <div className="compact-input-group">
                  <label>대리인</label>
                  <input type="text" value="박대리 (010-3333-4444)" readOnly />
                </div>
              </div>
            </div>

          </div>
        </div>
      </div>
    </div>
  );
};

export default CtrtDetail;