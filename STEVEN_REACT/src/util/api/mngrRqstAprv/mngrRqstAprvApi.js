import requestApi from '../requestApi';

/** 신청 계정 목록 (keyword, status) */
export const getRequestList = async (searchForm = {}) => {
  const res = await requestApi.get('/api/adm/mngrRqstAprv/requestList', {
    params: searchForm,
  });
  return res.data;
};

/** 관리자 계정 목록 (keyword, status, role) */
export const getAccountList = async (searchForm = {}) => {
  const res = await requestApi.get('/api/adm/mngrRqstAprv/accountList', {
    params: searchForm,
  });
  return res.data;
};

/** 신청 승인 */
export const approveRequest = async (rqstNo) => {
  const res = await requestApi.post(`/api/adm/mngrRqstAprv/approve/${rqstNo}`);
  return res.data;
};

/** 신청 반려 */
export const rejectRequest = async (rqstNo, rjctRsnCn) => {
  const res = await requestApi.post(`/api/adm/mngrRqstAprv/reject/${rqstNo}`, {
    rjctRsnCn,
  });
  return res.data;
};

/** 계정 사용/미사용 (userYn: Y | N) */
export const updateAccountUse = async (userNo, userYn) => {
  const res = await requestApi.put(`/api/adm/mngrRqstAprv/accountUse/${userNo}`, {
    userYn,
  });
  return res.data;
};
