import { LR, SUPPLY_LABELS, annStyles } from './formBits';

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
  setSubmitDocOptions,
  handleAptChange,
  resetBelow,
  rentList = [],
  selectedRentList = [],
  setSelectedRentList,
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
              disabled={!sido}
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
                  <th>선택</th>
                  <th>호</th>
                  <th>타입</th>
                  <th>전용면적(㎡)</th>
                  <th>방 수</th>
                  <th>욕실 수</th>
                  <th>보증금</th>
                  <th>월임대료</th>
                </tr>
              </thead>
              <tbody>
                {rentList.length > 0
                  ? rentList.map((row, i) => (
                    <tr key={i}>
                      <td>
                        <input
                          type="checkbox"
                          checked={selectedRentList.includes(row.RENT_LSTG_NO ?? row.rent_lstg_no)}
                          onChange={(e) => {
                            const rentNo = row.RENT_LSTG_NO ?? row.rent_lstg_no;
                            if (e.target.checked) {
                              setSelectedRentList([...selectedRentList, rentNo]);
                            } else {
                              setSelectedRentList(selectedRentList.filter(r => r !== rentNo));
                            }
                          }}
                        />
                      </td>
                      <td>{row.HO ?? row.ho}</td>
                      <td>{row.TY_NM ?? row.ty_nm}</td>
                      <td>{row.EXCLUSIVE_SIZE ?? row.exclusive_size}</td>
                      <td>{row.ROOM_CNT ?? row.room_cnt}</td>
                      <td>{row.BATHROOM_CNT ?? row.bathroom_cnt}</td>
                      <td>{row.DPST_AMT ?? row.dpst_amt}</td>
                      <td>{row.MTHLY_RENT_AMT ?? row.mthly_rent_amt}</td>
                    </tr>
                  ))
                  : (
                    <tr>
                      <td colSpan={8} style={{ textAlign: 'center', color: 'gray' }}>
                        단지를 선택하세요
                      </td>
                    </tr>
                  )
                }
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </section>
  );
}