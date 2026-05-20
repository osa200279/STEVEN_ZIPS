import { LR, SUPPLY_COLS, SUPPLY_LABELS, annStyles } from './formBits';

const L = SUPPLY_LABELS;

export default function SupplyInfoSection({
  sido,
  setsido,
  sigungu,
  setsigungu,
  emd,
  setemd,
  aptCmplexNo,
  setAptCmplexNo,
  setAddr,
  addr,
  sidoOptions = [],
  sigunguOptions = [],
  emdOptions = [],
  aptOptions = [],
  setHoTyList,
  hoTyList = [],
  setSubmitDocOptions,
  handleAptChange,
  resetBelow,
}) {
  const clearFromSigungu = () => {
    setemd('');
    setAptCmplexNo('');
    resetBelow?.();
  };

  return (
    <section className="form-card">
      <h2 className="form-card-title">{L.sectionTitle}</h2>
      <div className="form-grid-stack">
        <div className="form-row-grid">
          <div className="form-input-group">
            <LR htmlFor="sido" req>{L.sido}</LR>
            <select
              id="sido"
              name="sido"
              value={sido}
              onChange={(e) => {
                setsido(e.target.value);
                setsigungu('');
                clearFromSigungu();
              }}
            >
              <option value="">{L.sidoSelect}</option>
              {sidoOptions.map((o) => (
                <option key={o.value} value={o.value}>{o.label}</option>
              ))}
            </select>
          </div>
          <div className="form-input-group">
            <LR htmlFor="sigungu" req>{L.sigungu}</LR>
            <select
              id="sigungu"
              name="sigungu"
              value={sigungu}
              disabled={!sido}
              onChange={(e) => {
                setsigungu(e.target.value);
                clearFromSigungu();
              }}
            >
              <option value="">{sido ? L.sigunguSelect : L.needSido}</option>
              {sigunguOptions.map((o) => (
                <option key={o.value} value={o.value}>{o.label}</option>
              ))}
            </select>
          </div>
        </div>
        <div className="form-row-grid">
          <div className="form-input-group">
            <LR htmlFor="emd" req>{L.emd}</LR>
            <select
              id="emd"
              name="emd"
              value={emd}
              disabled={!sigungu}
              onChange={(e) => {
                setemd(e.target.value);
                setAptCmplexNo('');
                setAddr('');
                setHoTyList([]);
                setSubmitDocOptions?.([]);
              }}
            >
              <option value="">{sigungu ? L.emdSelect : L.needSigungu}</option>
              {emdOptions.map((o) => (
                <option key={o.value} value={o.value}>{o.label}</option>
              ))}
            </select>
          </div>
          <div className="form-input-group">
            <LR htmlFor="aptCmplexNo" req>{L.apt}</LR>
            <select
              id="aptCmplexNo"
              name="aptCmplexNo"
              value={aptCmplexNo}
              disabled={!emd}
              onChange={handleAptChange ?? ((e) => setAptCmplexNo(e.target.value))}
            >
              <option value="">{emd ? L.aptSelect : L.needEmd}</option>
              {aptOptions.map((o) => (
                <option key={o.value} value={o.value}>{o.label}</option>
              ))}
            </select>
          </div>
        </div>
        <div className="form-input-group">
          <label htmlFor="addr">{L.addr}</label>
          <input
            id="addr"
            name="addr"
            type="text"
            readOnly
            style={annStyles.readonly}
            value={addr}
            placeholder={L.addrPh}
          />
        </div>
        <div className="table-wrapper">
          <div className="table-container">
            <table className="data-table ann-supply-table">
              <thead>
                <tr>
                  {SUPPLY_COLS.map((c) => (
                    <th key={c.key}>{c.label}</th>
                  ))}
                </tr>
              </thead>
              <tbody>
    {hoTyList.length > 0
        ? hoTyList.map((row, i) => (
            <tr key={i}>
                <td>{row.TY_NM}</td>
                <td>{row.EXCLUSIVE_SIZE}</td>
                <td>{row.ROOM_CNT}</td>
                <td>{row.BATHROOM_CNT}</td>
                <td>{row.UNIT_CNT}</td>
            </tr>
        ))
        : <tr>
            <td colSpan={5} style={{ textAlign: 'center', color: 'gray' }}>
                단지를 선택하세요
            </td>
          </tr>
            }
        </tbody>
            </table>
          </div>
        </div>
      </div>
    </section>
  );
}
