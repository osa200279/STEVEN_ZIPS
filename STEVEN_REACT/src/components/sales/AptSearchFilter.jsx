import { useEffect, useState } from 'react';

import { Button } from '../common/Button';

import {
  getSidoList,
  getSigunguList,
  getDongList,
} from '../../util/api/sales/aptRegisterApi';

const AptSearchFilter = ({
  searchForm,
  setSearchForm,
  onSearch,
  loading,
}) => {

  const [sidoList, setSidoList] = useState([]);
  const [sigunguList, setSigunguList] = useState([]);
  const [dongList, setDongList] = useState([]);

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
    }
  };

  // =========================
  // 시군구 조회
  // =========================
  useEffect(() => {

    if (!searchForm.sidoCd) {

      setSigunguList([]);
      setDongList([]);

      return;
    }

    loadSigunguList();

  }, [searchForm.sidoCd]);

  const loadSigunguList = async () => {

    try {

      setSigunguList([]);
      setDongList([]);

      const res = await getSigunguList(
        searchForm.sidoCd
      );

      setSigunguList(res.data || []);

    } catch (e) {
      console.error(e);
    }
  };

  // =========================
  // 동 조회
  // =========================
  useEffect(() => {

    if (
      !searchForm.sidoCd ||
      !searchForm.sigunguCd
    ) {

      setDongList([]);

      return;
    }

    loadDongList();

  }, [searchForm.sigunguCd]);

  const loadDongList = async () => {

    try {

      setDongList([]);

      const res = await getDongList({
        sido: searchForm.sidoCd,
        sigungu: searchForm.sigunguCd,
      });

      setDongList(res.data || []);

    } catch (e) {
      console.error(e);
    }
  };

  // =========================
  // 검색
  // =========================
  const handleSearch = () => {

    onSearch({
      ...searchForm,
      keyword: searchForm.keyword.trim(),
    });
  };

  // =========================
  // 공통 변경
  // =========================
  const handleChange = (key, value) => {

    setSearchForm(prev => ({
      ...prev,
      [key]: value,
    }));
  };

  return (
    <div className="apt-search-filter">

      <div className="region-grid">

        {/* 시도 */}
        <select
          className="c-select"
          value={searchForm.sidoCd}
          onChange={(e) => {

            setSearchForm(prev => ({
              ...prev,
              sidoCd: e.target.value,
              sigunguCd: '',
              emdCd: '',
            }));
          }}
        >
          <option value="">
            시도 선택
          </option>

          {sidoList.map((sido) => (
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
          className="c-select"
          value={searchForm.sigunguCd}
          disabled={!searchForm.sidoCd}
          onChange={(e) => {

            setSearchForm(prev => ({
              ...prev,
              sigunguCd: e.target.value,
              emdCd: '',
            }));
          }}
        >
          <option value="">
            시군구 선택
          </option>

          {sigunguList.map((sigungu) => (
            <option
              key={sigungu}
              value={sigungu}
            >
              {sigungu}
            </option>
          ))}
        </select>

        {/* 읍면동 */}
        <select
          className="c-select"
          value={searchForm.emdCd}
          disabled={!searchForm.sigunguCd}
          onChange={(e) =>
            handleChange('emdCd', e.target.value)
          }
        >
          <option value="">
            읍면동 선택
          </option>

          {dongList.map((emd) => (
            <option
              key={emd}
              value={emd}
            >
              {emd}
            </option>
          ))}
        </select>

      </div>

      <div
        style={{
          display: 'flex',
          gap: '12px',
          marginTop: '16px',
        }}
      >

        <input
          type="text"
          className="c-input"
          placeholder="아파트명 검색"
          value={searchForm.keyword}
          onChange={(e) =>
            handleChange('keyword', e.target.value)
          }
          onKeyDown={(e) => {
            if (e.key === 'Enter') {
              handleSearch();
            }
          }}
          style={{ flex: 1 }}
        />

        <Button
          onClick={handleSearch}
          disabled={loading}
        >
          {loading ? '검색중...' : '검색'}
        </Button>

      </div>

    </div>
  );
};

export default AptSearchFilter;