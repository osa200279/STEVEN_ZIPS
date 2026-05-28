import React from 'react';
import { Search, Filter } from 'lucide-react';

const FeeFilter = ({ filters, setFilters, onSearch }) => {
    const handleInputChange = (e) => {
        const { name, value } = e.target;
        setFilters(prev => ({ ...prev, [name]: value }));
    };

    return (
        <div className="filter-panel">
            <div className="filter-grid">
                {/* 단지 필터 */}
                <div className="filter-column">
                    <div className="filter-group">
                        <label className="filter-label">단지명</label>
                        <select 
                            name="aptCmplexNo" 
                            className="filter-input" 
                            value={filters.aptCmplexNo} 
                            onChange={handleInputChange}
                        >
                            <option value="">전체 단지</option>
                            <option value="1">A아파트</option>
                            <option value="2">B아파트</option>
                        </select>
                    </div>
                </div>

                {/* 기간 필터 (연도) */}
                <div className="filter-column">
                    <div className="filter-group">
                        <label className="filter-label">연도</label>
                        <input 
                            type="number" 
                            name="year" 
                            className="filter-input" 
                            placeholder="YYYY"
                            value={filters.year}
                            onChange={handleInputChange}
                        />
                    </div>
                </div>

                {/* 기간 필터 (월) */}
                <div className="filter-column">
                    <div className="filter-group">
                        <label className="filter-label">월</label>
                        <select name="month" className="filter-input" value={filters.month} onChange={handleInputChange}>
                            {[...Array(12)].map((_, i) => (
                                <option key={i + 1} value={i + 1}>{i + 1}월</option>
                            ))}
                        </select>
                    </div>
                </div>

                {/* 조회 버튼 */}
                <div className="filter-column" style={{ justifyContent: 'flex-end' }}>
                    <button className="btn-primary" onClick={onSearch}>
                        <Search size={16} />
                        조회
                    </button>
                </div>
            </div>
        </div>
    );
};

export default FeeFilter;