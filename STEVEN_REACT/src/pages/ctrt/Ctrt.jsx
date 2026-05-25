import { Download, FilePlusCorner } from 'lucide-react';
import { useEffect, useState } from 'react';
import { useNavigate, useOutletContext } from 'react-router-dom';
import '../../styles/common.css';
import requestApi from '../../util/api/requestApi';
import { getNameByStatus, getNameOfJm } from '../../util/ctrt/ctrt';
import CtrtBoard from './CtrtBoard';

const Ctrt = () => {
  const navigate = useNavigate();

  const { admInfo } = useOutletContext() || {};
  const [list, setList] = useState([]);

  const [pagination, setPagination] = useState({
    curPage: 1,
    totalPage: 1,
    totalRecord: 0
  });

  // 필터 상태값 정의
  const [filterStatus, setFilterStatus] = useState('ALL');

  // 리스트 조회 API 호출
  useEffect(() => {
    const fetchContracts = async () => {
      try {
        const response = await requestApi.get(`/api/react/adm/ctrt?page=${pagination.curPage}`);

        if (response.data && Array.isArray(response.data.ctrtList)) {
          setList(response.data.ctrtList);
          setPagination(prev => ({
            ...prev,
            totalPage: response.data.totalPage,
            totalRecord: response.data.totalRecord
          }));
        } else {
          console.error("서버 응답이 배열 형식이 아닙니다: ", response.data);
          setList([]);
        }
      } catch (error) {
        console.error("데이터 로드 실패 : ", error);
        setList([]);
      }
    };
    fetchContracts();
  }, [pagination.curPage, filterStatus]);

  const paging = (newPage) => {
    if (newPage >= 1 && newPage <= pagination.totalPage) {
      setPagination(prev => ({ ...prev, curPage: newPage }));
    }
  };

  const openDetail = (RENT_CTRT_NO) => {
    if (!RENT_CTRT_NO) {
      alert("계약 정보가 없습니다.");
      return;
    }
    navigate(`/adm/ctrt/detail/${RENT_CTRT_NO}`);
  };


  return (
    <div className="content-wrapper" style={{ paddingTop: '0px' }}>
      {/* 타이틀 세션 */}
      <div className="page-header">
        <div>
          <h2 className="page-title">계약 관리</h2>
          <p className="page-subtitle">Contract management</p>
        </div>
        <div className="header-actions">
          <button className="btn-outline">
            <span className="material-symbols-outlined">.xls 다운로드</span><Download size={17} />
          </button>
          <button
            className="btn-primary"
            onClick={() => navigate('/apt/residentAssign')}
          >
            <span className="material-symbols-outlined">
              오프라인 계약 등록
            </span><FilePlusCorner size={17} />
          </button>
        </div>
      </div>

      {/* 대시보드 통계 그리드 컴포넌트 */}
      <CtrtBoard />

      {/* 필터 및 컨트롤 바 */}
      <div className="filter-bar">
        <div className="filter-badge">
          <span className="material-symbols-outlined select-icon">filter_list</span>
          <span>Status: All</span>
          <span className="material-symbols-outlined select-icon">expand_more</span>
        </div>
        <div className="filter-badge">
          <span>Department: Legal & HR</span>
          <span className="material-symbols-outlined select-icon">expand_more</span>
        </div>
        <div className="filter-badge">
          <span className="material-symbols-outlined select-icon">calendar_today</span>
          <span>Date Range: Q3 2024</span>
        </div>

        <div className="filter-right-group">
          <p className="table-info-text mr-4">Total {pagination.totalRecord}건</p>
          <div className="view-toggle-box">
            <button className="toggle-btn active"><span className="material-symbols-outlined">list</span></button>
            <button className="toggle-btn"><span className="material-symbols-outlined">grid_view</span></button>
          </div>
        </div>
      </div>

      {/* 데이터 테이블 컨테이너 */}
      <div className="table-wrapper shadow-sm">
        <div className="table-container">
          <table className="data-table">
            <thead>
              <tr>
                <th style={{ textAlign: 'left', marginRight: '0px', paddingRight: '0px' }}>계약 번호</th>
                <th>ID</th>
                <th>이름</th>
                <th>아파트</th>
                <th>승인일</th>
                <th>계약 기간</th>
                <th>전·월세</th>
                <th>임대료</th>{/* 전세면 보증금, 월세면 월 임대 금액 */}
                <th>상태</th>
                <th>담당자</th>
                <th>상세</th>
              </tr>
            </thead>
            <tbody>
              {list.length === 0 ? (
                <tr>
                  <td colSpan="9" className="text-center py-4" style={{ color: '#888' }}>배정된 계약 건이 없습니다.</td>
                </tr>
              ) : (
                list.map((item, i) => {
                  const statusBadge = getNameByStatus(item.CTRT_STTS_CD, item.MVIN_DT, item.MVOUT_DT);
                  const jm = getNameOfJm(item.RENT_TYPE_CD)
                  return (
                    <tr key={i}>
                      <td style={{ textAlign: 'left', marginRight: '0px', paddingRight: '0px' }}>  {/* 계약 번호 */}
                        <div>
                          <p className="cell-title" style={{ marginRight: '0px' }}>{item.RENT_CTRT_NO}</p>
                        </div>
                      </td>
                      <td> {/* ID */}
                        <div>
                          <p className="cell-title">{item.USER_ID}</p>
                        </div>
                      </td>
                      <td> {/* 이름 */}
                        <div>
                          <p className="cell-title">이름 : {item.USER_NM}</p>
                        </div>
                      </td>
                      <td> {/* 아파트 */}
                        <p className="cell-title">{item.APT_CMPLEX_NO}</p>
                        <p className="cell-sub">{item.APT_CMPLEX_NM}</p>
                      </td>
                      <td> {/* 계약 승인일 */}
                        <span className="cell-title">{item.CTRT_APRV_DT ? new Date(item.CTRT_APRV_DT).toLocaleDateString() : "승인대기"}</span>
                      </td>
                      <td> {/* 기간 */}
                        {item.MVIN_DT && item.MVOUT_DT ?
                          <span className="cell-title">
                            {new Date(item.MVIN_DT).toLocaleDateString().replace(/\.$/, '')} ~ {new Date(item.MVOUT_DT).toLocaleDateString().replace(/\.$/, '')}
                          </span>
                          : <span className='cell-title'>미정</span>}
                      </td>
                      <td> {/* 임대 타입 */}
                        <span className="cell-title">
                          {jm.text}
                        </span>
                      </td>
                      <td className='price'> {/* 임대료 */}
                        <span className='cell-title'>
                          {item.RENT_TYPE_CD === 'JS' ? `${item.DPST_AMT?.toLocaleString()}원` : `${item.MTHLY_RENT_AMT?.toLocaleString()}원`}
                        </span>
                      </td>
                      <td> {/* 상태 */}
                        <span className={`cell-title ${statusBadge.className}`}>
                          {statusBadge.text}
                        </span>
                      </td>
                      <td> {/* 담당자 */}
                        <div>
                          <p className="cell-title">{item.CTRT_MGR_USER_NM}</p>
                          <p className="cell-sub">관리자 번호 : {item.CTRT_MGR_USER_NO}</p>
                        </div>
                      </td>
                      <td> {/* 상세 버튼 */}
                        <button className='btn-cell' onClick={() => openDetail(item.RENT_CTRT_NO)}>상세보기</button>
                      </td>
                    </tr>
                  )
                })
              )}
            </tbody>
          </table>
        </div>

        {/* 하단 페이징 영역 */}
        <div className="table-pagination">
          <div className="pagination-right">
            <p className="table-info-text mr-4">Total {pagination.totalRecord}건</p>

            <div className="page-numbers">
              {/* 이전 버튼 */}
              <button className="btn-page-nav"
                disabled={pagination.curPage === 1}
                onClick={() => paging(pagination.curPage - 1)}
              >
                <span className="material-symbols-outlined">&lt;</span>
              </button>

              {/* 페이지 번호 동적 생성 */}
              {Array.from({ length: pagination.totalPage || 1 }, (_, i) => i + 1).map((pageNum) => (
                <button key={pageNum}
                  className={`btn-page-number ${pagination.curPage === pageNum ? 'active' : ''}`}
                  onClick={() => paging(pageNum)}>
                  {pageNum}
                </button>
              ))}

              {/* 다음 버튼 */}
              <button
                className='btn-page-nav'
                disabled={pagination.curPage === pagination.totalPage || pagination.totalPage === 0}
                onClick={() => paging(pagination.curPage + 1)}
              >
                <span className='material-symbols-outlined'>&gt;</span>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Ctrt;