import React, { useEffect, useState } from 'react';
import '../../styles/common.css';
import { Navigate, useNavigate, useParams } from 'react-router-dom';
import requestApi from '../../util/api/requestApi';

const CtrtDetail = () => {
  const { RENT_CTRT_NO } = useParams();
  const [detail, setDetail] = useState(null);
  const navigate = useNavigate();

  const isEditable = detail?.CTRT_STTS_CD === 'PENDING';

  const handleChange = (e) => {
    const { name, value } = e.target;
    setDetail(prev => ({ ...prev, [name]: value }));
  };

  useEffect(() => {
    const fetchCtrtDetails = async () => {
      try {
        const response = await requestApi.get(`/api/react/adm/ctrt/detail/${RENT_CTRT_NO}`);
        if (response.data && response.data.ctrtDetail) {
          setDetail(response.data.ctrtDetail);
        } else {
          console.error("서버 응답이 배열 형식이 아닙니다: ", response.data);
          setDetail(null);
        }
      } catch (error) {
        console.error("데이터 로드 실패 : ", error);
        setDetail(null);
      }
    };

    fetchCtrtDetails();
  }, [])

  const getCtrtSttsName = (code) => {
    // 코드와 한글 이름을 연결한 맵(Map) 객체
    const statusMap = {
      'PENDING': '승인대기',
      'APPROVED': '승인',
      'CANCEL': '취소',
      'REJECT': '반려',
      'TERMINATED': '중도해지',
      'EXPIRED': '계약만료'
    };

    return statusMap[code] || '상태없음';
  };

  if (!detail) return <div className="content-wrapper">로딩 중...</div>;

  let docs = detail.docList;

  return (
    <div className="content-wrapper" >
      <div className="form-max-container" style={{ maxWidth: '1440px', width: '100%' }}>

        {/* 타이틀 영역 */}
        <div className="page-header" style={{ marginBottom: '10px' }}>
          <div style={{ marginBottom: '0px' }}>
            <h2 className="page-title" style={{ fontSize: '24px', marginBottom: '0px' }}>계약 상세 정보</h2>
            <p className="page-subtitle" style={{ fontSize: '13px', margin: '0px' }}>Contract Detail</p>
          </div>
          <div className="header-actions">
            <button className="btn-outline" onClick={() => navigate('/adm/ctrt')}
              style={{ padding: '6px 12px', fontSize: '13px' }}>
              목록으로
            </button>
            <button className="btn-primary" style={{ padding: '6px 12px', fontSize: '13px' }}>수정하기</button>
          </div>
        </div>

        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: '16px' }}>

          {/* 1. 계약 기본 정보 (상단 전체 너비) */}
          <div className="compact-card" style={{ gridColumn: '1 / -1' }}>
            <h3 className="compact-card-title">
              계약 기본 정보
            </h3>
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: '12px' }}>
              <div className="compact-input-group">
                <label>계약 번호</label>
                <input type="text" value={detail.RENT_CTRT_NO} className="bg-gray-disabled" readOnly />
              </div>
              <div className="compact-input-group">
                <label>계약 상태</label>
                <input
                  type="text"
                  value={getCtrtSttsName(detail.CTRT_STTS_CD)}
                  readOnly={!isEditable}
                  className={`font-bold text-primary-color ${isEditable ? 'bg-white-force' : 'bg-gray-force'}`}
                />
              </div>
              <div className="compact-input-group">
                <label>임대매물번호</label>
                <input type="text" value={detail.RENT_LSTG_NO} className="bg-gray-disabled" readOnly />
              </div>
              <div className="compact-input-group">
                <label>담당자 (배정일)</label>
                <input type="text"
                  value={`${detail.CTRT_MGR_USER_NM} (${new Date(detail.MGR_ASGN_DT).toLocaleDateString('ko-KR', {
                    year: '2-digit', month: '2-digit', day: '2-digit'
                  })})`} readOnly={!isEditable} className={`font-bold text-primary-color ${isEditable ? 'bg-white-force' : 'bg-gray-force'}`} />
              </div>
            </div>
          </div>

          {/* 좌측 영역 (매물/임차인 + 특약/서류) */}
          <div style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
            <div className="compact-card">
              <h3 className="compact-card-title">
                매물 및 임차인 정보
              </h3>
              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: '12px' }}>
                <div className="compact-input-group" style={{ gridColumn: '2 / 1' }}>
                  <label>아파트 정보</label>
                  <input type="text" value={detail.APT_CMPLEX_NM} className="bg-gray-disabled" readOnly />
                </div>
                <div className="compact-input-group" style={{ gridColumn: '2 / -1' }}>
                  <label>타입</label>
                  <input type="text" value={`${detail.TY_NM} ${detail.EXCLUSIVE_SIZE}㎡`} className="bg-gray-disabled" readOnly />
                </div>
                <div className="compact-input-group">
                  <label>임차인 이름</label>
                  <input type="text" value={detail.USER_NM} className="bg-gray-disabled" readOnly />
                </div>
                <div className="compact-input-group">
                  <label>임차인 ID (번호)</label>
                  <input type="text" value={`${detail.USER_ID} (${detail.USER_NO})`} className="bg-gray-disabled" readOnly />
                </div>
              </div>
            </div>

            <div className="compact-card" style={{ flex: 1 }}>
              <h3 className="compact-card-title">
                특약 및 서류
              </h3>
              <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
                <div className="compact-input-group">
                  <label>특약 사항</label>

                  {detail.SPCL_STPLTN_CN ?
                    <textarea
                      style={{ resize: 'none', height: '60px' }}
                      value={detail.SPCL_STPLTN_CN}
                      readOnly={!isEditable} className={`font-bold text-primary-color ${isEditable ? 'bg-white-force' : 'bg-gray-force'}`}
                    />
                    : <input type="text" value="없음" readOnly={!isEditable} className={`font-bold text-primary-color ${isEditable ? 'bg-white-force' : 'bg-gray-force'}`} />
                  }
                </div>
                <div className="compact-input-group">
                  <p className="upload-main-text" style={{ fontSize: '13px', margin: '0 0 2px 0' }}>첨부 서류 {docs?.length || 0}건</p>
                  {
                    docs.map((doc, idx) => {
                      return (
                        <div key={idx}>
                          <span className='text-small'>{idx + 1}.&nbsp;</span>
                          <a href={`http://localhost:8080/file/download/${doc.googleId}`} rel='noopener noreferrer'>
                            <span className='text-small'>{doc.fileOgName}</span>
                          </a>
                          <br />
                        </div>
                      )
                    })
                  }
                </div>
              </div>
            </div>
          </div>

          {/* 우측 영역 (금액 + 일정/관계자) */}
          <div style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>

            <div className="compact-card">
              <h3 className="compact-card-title">
                계약 금액 정보
              </h3>
              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: '12px' }}>
                <div className="compact-input-group" >
                  <label>임대 유형</label>
                  <input type="text" value={(detail.RENT_TYPE_CD === 'JS' ? '전세' : '월세')} className="bg-gray-disabled" readOnly />
                </div>
                <div className="compact-input-group">
                  <label>보증금</label>
                  <input type="text" value={detail.DPST_AMT != null ? `${detail.DPST_AMT.toLocaleString()} 원` : "-"} readOnly={!isEditable} className={`font-bold text-primary-color ${isEditable ? 'bg-white-force' : 'bg-gray-force'}`} />
                </div>
                <div className="compact-input-group">
                  <label>계약금</label>
                  <input type="text" value={detail.CTRT_AMT != null ? `${detail.CTRT_AMT.toLocaleString()} 원` : "-"} readOnly={!isEditable} className={`font-bold text-primary-color ${isEditable ? 'bg-white-force' : 'bg-gray-force'}`} />
                </div>
                <div className="compact-input-group">
                  <label>중도금</label>
                  <input type="text" value={detail.MID_PAY_AMT != null ? `${detail.MID_PAY_AMT.toLocaleString()} 원` : "-"} className={`font-bold text-primary-color ${isEditable ? 'bg-white-force' : 'bg-gray-force'}`} />
                </div>
                <div className="compact-input-group">
                  <label>잔금</label>
                  <input type="text" value={detail.BAL_AMT != null ? `${detail.BAL_AMT.toLocaleString()} 원` : "-"} className={`font-bold text-primary-color ${isEditable ? 'bg-white-force' : 'bg-gray-force'}`} />
                </div>
                <div className="compact-input-group">
                  <label>월세</label>
                  <input type="text" value={detail.MTHLY_RENT_AMT != null ? `${detail.MTHLY_RENT_AMT.toLocaleString()} 원` : "-"} className={`font-bold text-primary-color ${isEditable ? 'bg-white-force' : 'bg-gray-force'}`} />
                </div>
              </div>
            </div>

            <div className="compact-card" style={{ flex: 1 }}>
              <h3 className="compact-card-title">
                일정 및 관계자 정보
              </h3>
              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: '12px' }}>
                <div className="compact-input-group">
                  <label>입주 예정일</label>
                  <input type="text" value={`${new Date(detail.MVIN_DT).toLocaleDateString('ko-KR', {
                    year: '2-digit', month: '2-digit', day: '2-digit'
                  })}`} className={`font-bold text-primary-color ${isEditable ? 'bg-white-force' : 'bg-gray-force'}`} />
                </div>
                <div className="compact-input-group">
                  <label>퇴거일 (완료일)</label>
                  <input type="text" value={detail.MVOUT_DT ? `${new Date(detail.MVOUT_DT).toLocaleDateString('ko-KR', {
                    year: '2-digit', month: '2-digit', day: '2-digit'
                  })}` : '-'} className={`font-bold text-primary-color ${isEditable ? 'bg-white-force' : 'bg-gray-force'}`} />
                </div>
                <div className="compact-input-group">
                  <label>임대인</label>
                  <input type="text" value={detail.RENTOR_NM
                    ? `${detail.RENTRO_NM}${detail.RENTOR_TELNO ? ` (${detail.RENTOR_TELNO})` : ''}`
                    : '-'} className={`font-bold text-primary-color ${isEditable ? 'bg-white-force' : 'bg-gray-force'}`} />
                </div>
                <div className="compact-input-group">
                  <label>대리인</label>
                  <input type="text" value={detail.AGNT_NM
                    ? `${detail.AGNT_NM}${detail.AGNT_TELNO ? ` (${detail.AGNT_TELNO})` : ''}`
                    : '-'} className={`font-bold text-primary-color ${isEditable ? 'bg-white-force' : 'bg-gray-force'}`} />
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