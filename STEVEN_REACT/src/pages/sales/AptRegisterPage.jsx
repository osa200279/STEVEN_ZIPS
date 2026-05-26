import { useEffect, useMemo, useState } from 'react';
import { Button } from '../../components/common/Button';
import { Card } from '../../components/common/Card';

import {
    getApartmentList,
    getDongList,
    getSidoList,
    getSigunguList,
    registerApartment
} from '../../util/api/sales/aptRegisterApi';

const AptRegisterPage = () => {

  // 지역 선택
  const [sidoList, setSidoList] = useState([]);
  const [sigunguList, setSigunguList] = useState([]);
  const [dongList, setDongList] = useState([]);

  const [selectedSido, setSelectedSido] = useState('');
  const [selectedSigungu, setSelectedSigungu] = useState('');
  const [selectedDong, setSelectedDong] = useState('');

  // 아파트 목록
  const [aptList, setAptList] = useState([]);

  // 검색어
  const [keyword, setKeyword] = useState('');

  // 로딩
  const [loading, setLoading] = useState(false);

  // 등록중
  const [registeringCode, setRegisteringCode] = useState(null);

  // =========================
  // 시도 조회
  // =========================
  useEffect(() => {
    loadSidoList();
  }, []);

  const loadSidoList = async () => {
    try {
      const res = await getSidoList();
      setSidoList(res.data || []);
    } catch (e) {
      console.error(e);
      alert('시도 목록 조회 실패');
    }
  };

  // =========================
  // 시군구 조회
  // =========================
  useEffect(() => {
    if (!selectedSido) return;

    loadSigunguList();
  }, [selectedSido]);

  const loadSigunguList = async () => {
    try {

      setSelectedSigungu('');
      setSelectedDong('');
      setDongList([]);
      setAptList([]);

      const res = await getSigunguList(selectedSido);

      setSigunguList(res.data || []);

    } catch (e) {
      console.error(e);
      alert('시군구 조회 실패');
    }
  };

  // =========================
  // 동 조회
  // =========================
  useEffect(() => {
    if (!selectedSido || !selectedSigungu) return;

    loadDongList();
  }, [selectedSigungu]);

  const loadDongList = async () => {
    try {

      setSelectedDong('');
      setAptList([]);

      const res = await getDongList({
        sido: selectedSido,
        sigungu: selectedSigungu
      });

      setDongList(res.data || []);

    } catch (e) {
      console.error(e);
      alert('동 조회 실패');
    }
  };

  // =========================
  // 아파트 조회
  // =========================
  useEffect(() => {
    if (!selectedDong) return;

    loadApartmentList();
  }, [selectedDong]);

  const loadApartmentList = async () => {

    try {

      setLoading(true);

      const res = await getApartmentList({
        sido: selectedSido,
        sigungu: selectedSigungu,
        dong: selectedDong
      });

      setAptList(res.data || []);

    } catch (e) {
      console.error(e);
      alert('아파트 목록 조회 실패');
    } finally {
      setLoading(false);
    }
  };

  // =========================
  // 검색 필터
  // =========================
  const filteredList = useMemo(() => {

    if (!keyword.trim()) {
      return aptList;
    }

    return aptList.filter(item =>
      item.aptName?.includes(keyword)
    );

  }, [keyword, aptList]);

  // =========================
  // 등록
  // =========================
  const handleRegister = async (apt) => {

    try {

      setRegisteringCode(apt.kaptCode);

      await registerApartment({
        kaptCode: apt.kaptCode
      });

      alert('등록 완료');

    } catch (e) {
      console.error(e);
      alert('등록 실패');
    } finally {
      setRegisteringCode(null);
    }
  };

  return (
    <div className="apt-register-page">

      <Card
        title="아파트 등록"
        subtitle="행정구역 선택 후 아파트를 등록하세요."
      >

        {/* 검색 영역 */}
        <div className="search-section">

          <input
            type="text"
            placeholder="아파트 이름 검색"
            value={keyword}
            onChange={(e) => setKeyword(e.target.value)}
            className="c-input"
          />

          <div className="region-grid">

            {/* 시도 */}
            <select
              value={selectedSido}
              onChange={(e) => setSelectedSido(e.target.value)}
              className="c-select"
            >
              <option value="">시도 선택</option>

              {sidoList.map(sido => (
                <option
                  key={sido}
                  value={sido}
                >
                  {sido}
                </option>
              ))}
            </select>

            {/* 시군구 */}
            <select
              value={selectedSigungu}
              onChange={(e) => setSelectedSigungu(e.target.value)}
              className="c-select"
              disabled={!selectedSido}
            >
              <option value="">시군구 선택</option>

              {sigunguList.map(sigungu => (
                <option
                  key={sigungu}
                  value={sigungu}
                >
                  {sigungu}
                </option>
              ))}
            </select>

            {/* 동 */}
            <select
              value={selectedDong}
              onChange={(e) => setSelectedDong(e.target.value)}
              className="c-select"
              disabled={!selectedSigungu}
            >
              <option value="">법정동 선택</option>

              {dongList.map(dong => (
                <option
                  key={dong}
                  value={dong}
                >
                  {dong}
                </option>
              ))}
            </select>

          </div>

        </div>

      </Card>

      {/* 목록 */}
      <div className="apt-list-section">

        {loading && (
          <Card>
            <div className="empty-text">
              아파트 목록 조회중...
            </div>
          </Card>
        )}

        {!loading && filteredList.length === 0 && (
          <Card>
            <div className="empty-text">
              조회된 아파트가 없습니다.
            </div>
          </Card>
        )}

        {!loading && filteredList.map((apt) => (

          <Card
            key={apt.kaptCode}
            divide
            title={apt.aptName}
            subtitle={apt.roadAddr}
            actions={
              <Button
                onClick={() => handleRegister(apt)}
                disabled={registeringCode === apt.kaptCode}
              >
                {registeringCode === apt.kaptCode
                  ? '등록중...'
                  : '등록'}
              </Button>
            }
          >

            <div className="apt-info-grid">

              <div>
                <strong>단지코드</strong>
                <div>{apt.kaptCode}</div>
              </div>

              <div>
                <strong>세대수</strong>
                <div>{apt.householdCount || '-'}</div>
              </div>

              <div>
                <strong>준공년도</strong>
                <div>{apt.buildYear || '-'}</div>
              </div>

            </div>

          </Card>

        ))}

      </div>

    </div>
  );
};

export default AptRegisterPage;