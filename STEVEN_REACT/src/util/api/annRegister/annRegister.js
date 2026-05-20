import requestApi from '../requestApi';

/** API 응답 → select용 { value, label }[] (문자열 배열·단지 객체 모두 처리) */
export function toSelectOptions(data) {
  const list = Array.isArray(data) ? data : [];
  if (data != null && !Array.isArray(data)) {
    console.error('API 응답이 배열이 아닙니다. JWT·URL을 확인하세요.', data);
  }
  return list
    .map((item, idx) => {
      if (item == null) return null;
      if (typeof item === 'string' || typeof item === 'number') {
        const s = String(item);
        return { value: s, label: s };
      }
      const value = item.aptCmplexNo ?? item.code ?? item.value ?? `opt-${idx}`;
      const label = item.aptCmplexNm ?? item.name ?? item.nm ?? item.label ?? String(value);
      return { value: String(value), label: String(label) };
    })
    .filter(Boolean);
}

/**
 * 시/도 리스트 조회
 */
export const getSido = async () => {
  const res = await requestApi.get('/api/annRegister/sido');
  return res.data;
};

/**
 * 시/군/구 리스트 조회
 */
export const getSigungu = async (sidoNm) => {
  const res = await requestApi.get('/api/annRegister/sigungu', {
    params: {sidoNm},
  });
  return res.data;
};

/**
 * 읍/면/동 리스트 조회
 */
export const getEmd = async (sidoNm, sigunguNm) => {
  const res = await requestApi.get('/api/annRegister/emd', {
    params: {sidoNm, sigunguNm},
  });
  return res.data;
};

/**
 * 아파트 단지 리스트 조회
 */
export const getAptList = async (sidoNm, sigunguNm, emdNm) => {
  const res = await requestApi.get('/api/annRegister/aptList', {
    params: {sidoNm, sigunguNm, emdNm}
  });
  return res.data;
};

/**
 * 아파트 단지 상세 조회 (주소, 호 타입 목록)
 */
export const getAptDetail = async (aptCmplexNo) => {
  const res = await requestApi.get('/api/annRegister/aptDetail', {
    params: {aptCmplexNo},
  });
  return res.data;
};

/**
 * 제출서류 목록 조회
 */
export const getSubmitDocTypes = async (aptCmplexNo) => {
    const res = await requestApi.get('/api/annRegister/sbmsnDocList',{
        params: {aptCmplexNo},
    });
    return res.data;
}

/**
 * 공고 등록
 */
export const insertAnn = async (formData) => {
  const res = await requestApi.post('/api/annRegister/insertAnn', formData);
  return res.data;
};
