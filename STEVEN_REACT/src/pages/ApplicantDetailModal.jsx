import React from 'react';
import { X } from 'lucide-react';

const ApplicantDetailModal = ({ isOpen, data, onClose }) => {
    if (!isOpen || !data) return null;
    console.log(data.docList);
    console.log(data.docList[0].fileInfo.googleId);

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
                <div>
                    <div><strong>아이디:</strong> {data.userId}</div>
                    <div><strong>이름:</strong> {data.userNm}</div>
                    <div><strong>공고명:</strong> {data.tyNm}</div>
                    <div><strong>공고명:</strong> {data.ttl}</div>
                    <div><strong>공고명:</strong> {data.aptCmplexNo}</div>
                    <div><strong>타입/면적:</strong> {data.tyNm} / {data.exclusiveSize}㎡</div>
                    <div><strong>첨부 파일</strong></div>
                    {
                        data.docList.map((doc, index) => {
                            const hasDate = doc.mdfcnDt || doc.regDt;
                            const formattedDate = hasDate ? new Date(doc.mdfcnDt || doc.regDt).toLocaleDateString('sv-SE') : "미등록";
                            return (
                                <div key={index}>
                                    {index+1}.&nbsp;<a href={`http://localhost:8080/file/download/${doc.fileInfo?.googleId}`} rel='noopener noreferrer'>
                                        [ {doc.mdfcnDt ? `수정일  ${formattedDate}` : `등록일 ${formattedDate}`} ] {doc.sbmsnDocTyCd} : {doc.fileInfo?.fileOgName}
                                    </a>
                                    <br />
                                </div>
                            )
                        })
                    }
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