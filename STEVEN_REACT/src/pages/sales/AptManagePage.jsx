import { useState } from 'react';

import { Card } from '../../components/common/Card';
import { Button } from '../../components/common/Button';
import AptSearchFilter from '../../components/sales/AptSearchFilter';
import AptList from '../../components/sales/AptList';
import { getApartmentList } from '../../util/api/sales/aptRegisterApi';

const AptManagePage = () => {

    // 검색 조건
    const [searchForm, setSearchForm] = useState({
        sidoCd: '',
        sigunguCd: '',
        emdCd: '',
        keyword: '',
    });

    // 검색 결과 리스트
    const [aptList, setAptList] = useState([]);

    // 선택된 아파트
    const [selectedApt, setSelectedApt] = useState(null);

    // 로딩
    const [loading, setLoading] = useState(false);

    /**
     * 아파트 검색
     */
    const handleSearch = async (condition) => {

        try {

            setLoading(true);

            const res = await getApartmentList({
                sido: condition.sidoCd,
                sigungu: condition.sigunguCd,
                emd: condition.emdCd,
            });

            setAptList(res.data || []);

        } catch (e) {
            console.error(e);
        } finally {
            setLoading(false);
        }
    };

    /**
     * 리스트 선택
     */
    const handleSelectApt = (apt) => {
        setSelectedApt(apt);
    };

    return (
        <div className="content-wrapper">

            {/* 헤더 */}
            <div className="page-header">
                <div>
                    <h1 className="page-title">
                        아파트 관리
                    </h1>

                    <p className="page-subtitle">
                        공동주택 정보를 조회하고 관리합니다.
                    </p>
                </div>
            </div>

            {/* 검색 영역 */}
            <Card
                title="아파트 검색"
                subtitle="지역 및 아파트명을 기준으로 검색할 수 있습니다."
            >
                <AptSearchFilter
                    searchForm={searchForm}
                    setSearchForm={setSearchForm}
                    onSearch={handleSearch}
                    loading={loading}
                />
            </Card>

            {/* 결과 영역 */}
            <div
                style={{
                    display: 'grid',
                    gridTemplateColumns: '380px 1fr',
                    gap: '24px',
                    alignItems: 'start',
                }}
            >

                {/* 리스트 */}
                <Card
                    title="검색 결과"
                    subtitle={`${aptList.length}건`}
                >
                    <AptList
                        aptList={aptList}
                        selectedApt={selectedApt}
                        onSelect={handleSelectApt}
                        loading={loading}
                    />
                </Card>

                {/* 상세 */}
                <Card
                    title="상세 정보"
                    subtitle={
                        selectedApt
                            ? selectedApt.kaptName
                            : '아파트를 선택해주세요.'
                    }
                >
                    {/*           <AptDetail
            selectedApt={selectedApt}
          /> */}
                </Card>

            </div>
        </div>
    );
};

export default AptManagePage;