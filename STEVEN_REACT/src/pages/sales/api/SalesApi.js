import requestApi from "../../../util/api/requestApi";

/**
 * 동 리스트 조회
 */
export const getBuildingList = async (aptComplexNo) => {

  const res = await requestApi.get(
    '/api/sales/buildings',
    {
      params: {
        aptComplexNo
      }
    }
  );

  return res.data;
};

/**
 * 동 배치도 조회
 */
export const getBuildingLayout = async (aptComplexNo, buildingNo) => {

  const res = await requestApi.get(
    '/api/sales/layout',
    {
      params: {
        aptComplexNo,
        buildingNo
      }
    }
  );

  return res.data;
};