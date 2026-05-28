import { useState } from 'react';

import AptSearchFilter from '../../components/sales/AptSearchFilter';
import AptList from '../../components/sales/AptList';
import AptDetailPanel from '../../components/sales/AptDetailPanel';

import {getApartmentList} from '../../util/api/sales/aptRegisterApi';

import '../../styles/sales/AptManagePage.css';

const AptManagePage = () => {

    // 검색 조건
    const [searchForm, setSearchForm] = useState({
        sidoCd: '',
        sigunguCd: '',
        emdCd: '',
        keyword: '',
        
    });

    // 원본 리스트
    const [originAptList, setOriginAptList] = useState([]);

    // 필터 리스트
    const [filteredAptList, setFilteredAptList] = useState([]);

    // 선택 아파트
    const [selectedApt, setSelectedApt] = useState(null);

    // 로딩
    const [loading, setLoading] = useState(false);

    /**
     * 아파트 조회
     */
    const handleLoadApartments = async ({
        sidoCd,
        sigunguCd,
        emdCd,
    }) => {

        try {

            setLoading(true);

            const res = await getApartmentList({
                sido: sidoCd,
                sigungu: sigunguCd,
                emd: emdCd,
            });

            const list = res.data || [];

            setOriginAptList(list);

            setFilteredAptList(list);

        } catch (e) {

            console.error(e);

        } finally {

            setLoading(false);
        }
    };

    /**
     * 아파트 선택
     */
    const handleSelectApt = (apt) => {
        setSelectedApt(apt);
    };

    /**
     * 이름 필터
     */
    const handleFilter = (keyword) => {

        const trimmed =
            keyword.trim();

        if (!trimmed) {

            setFilteredAptList(
                originAptList
            );

            return;
        }

        const filtered =
            originAptList.filter((apt) =>
                apt.kaptName
                    ?.replaceAll(' ', '')
                    .includes(
                        trimmed.replaceAll(' ', '')
                    )
            );

        setFilteredAptList(filtered);
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
                        아파트를 검색하고
                        단지 정보를 관리합니다.
                    </p>

                </div>

            </div>

            <div className="apt-manage-layout">

                {/* 검색 */}
                <div className="apt-section">

                    <div className="apt-section-header">
                        아파트 검색
                    </div>

                    <AptSearchFilter
                        searchForm={searchForm}
                        setSearchForm={setSearchForm}
                        onLoadApartments={
                            handleLoadApartments
                        }
                        onFilter={handleFilter}
                        loading={loading}
                    />

                </div>

                {/* 리스트 */}
                <div className="apt-section">

                    <div className="apt-section-header">
                        검색 결과
                        <span>
                            {filteredAptList.length}건
                        </span>
                    </div>

                    <AptList
                        aptList={filteredAptList}
                        selectedApt={selectedApt}
                        onSelect={handleSelectApt}
                        loading={loading}
                    />

                </div>

                {/* 상세 */}
                <div className="apt-section">

                    <div className="apt-section-header">
                        상세 정보
                    </div>

                    <AptDetailPanel
                        selectedApt={selectedApt}
                    />

                </div>

            </div>

        </div>
    );
};

export default AptManagePage;