import { Card } from '../common/Card';

const AptDetailPanel = ({
    selectedApt,
}) => {

    // 선택 안됨
    if (!selectedApt) {

        return (
            <Card
                title="상세 정보"
                subtitle="아파트를 선택해주세요."
            >
                <div
                    style={{
                        padding: '40px 20px',
                        textAlign: 'center',
                        color: 'var(--on-surface-variant)',
                    }}
                >
                    좌측 목록에서 아파트를 선택해주세요.
                </div>
            </Card>
        );
    }

    return (

        <Card
            title="상세 정보"
            subtitle={selectedApt.kaptName}
        >

            {/* 기본정보 */}
            <div>

                <div>
                    <label>아파트명</label>

                    <input
                        className="c-input"
                        value={selectedApt.kaptName || ''}
                    />
                </div>

                <div>
                    <label>주소</label>

                    <input
                        className="c-input"
                        value={selectedApt.doroJuso || ''}
                    />
                </div>

            </div>

            {/* 동 탭 */}

            {/* 동 수정폼 */}

        </Card>

    );
};

export default AptDetailPanel;