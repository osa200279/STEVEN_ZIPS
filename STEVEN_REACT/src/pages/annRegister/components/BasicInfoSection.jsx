import { LR, annStyles } from './formBits';

export default function BasicInfoSection() {
  return (
    <section className="form-card">
      <h2 className="form-card-title">기본 정보</h2>
      <div className="form-grid-stack">
        <div className="form-input-group">
          <LR htmlFor="ttl" req>
            공고 제목
          </LR>
          <input id="ttl" name="ttl" type="text" placeholder="공고 제목을 입력하세요" />
        </div>
        <div className="form-input-group">
          <LR htmlFor="content" req>
            공고 내용
          </LR>
          <textarea
            id="content"
            name="content"
            style={annStyles.textarea}
            placeholder="공고 내용을 입력하세요"
          />
        </div>
      </div>
    </section>
  );
}
