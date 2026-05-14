import React from 'react';
import { X } from 'lucide-react';

const ApplicantDetailModal = ({ isOpen, data, onClose }) => {
    if (!isOpen || !data) return null;

    return (
        <div className="modal-overlay" style={overlayStyle}>
            <div className="modal-content" style={modalStyle}>
                <div style={headerStyle}>
                    <h3>신청 상세 정보 ({data.aplctNo})</h3>
                    <button onClick={onClose} style={{ border: 'none', background: 'none', cursor: 'pointer' }}>
                        <X size={24} />
                    </button>
                </div>
                <hr />
                <div style={bodyStyle}>
                    {/* 여기서 상세 정보를 렌더링 */}
                    <div className="info-row"><strong>신청 번호:</strong> {data.aplctNo}</div>
                    <div className="info-row"><strong>이름:</strong> {data.userNm}</div>
                    <div className="info-row"><strong>아이디:</strong> {data.userId}</div>
                    <div className="info-row"><strong>공고명:</strong> {data.ttl}</div>
                    <div className="info-row"><strong>타입/면적:</strong> {data.tyNm} / {data.exclusiveSize}㎡</div>
                </div>
                <div style={footerStyle}>
                    <button onClick={onClose} className="btn-close">닫기</button>
                </div>
            </div>
        </div>
    );
};

const overlayStyle = { position: 'fixed', top: 0, left: 0, width: '100%', height: '100%', backgroundColor: 'rgba(0,0,0,0.5)', display: 'flex', justifyContent: 'center', alignItems: 'center', zIndex: 1000 };
const modalStyle = { backgroundColor: '#fff', padding: '20px', borderRadius: '12px', width: '600px', maxWidth: '90%', maxHeight: '80vh', overflowY: 'auto' };
const headerStyle = { display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '10px' };
const bodyStyle = { padding: '20px 0' };
const footerStyle = { textAlign: 'right', marginTop: '20px' };

export default ApplicantDetailModal;