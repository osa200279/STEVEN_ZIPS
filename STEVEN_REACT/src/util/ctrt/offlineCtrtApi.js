import requestApi
    from '../api/requestApi';

/* 아파트 검색 */
export const searchApartment =
    async (keyword, page = 1, size = 10) => {
        const response = await requestApi.get(
            '/api/offlineCtrt/apt/search',
            {
                params: {
                    keyword,
                    page,
                    size
                }
            }
        );

        return response.data;
    };

/* 동 목록 조회 */
export const getDongList =
    async (aptCmplexNo) => {
        const response = await requestApi.get(
            '/api/offlineCtrt/apt/dong-list',
            {
                params: {
                    aptCmplexNo
                }
            }
        );

        return response.data;
    };

/* 호 목록 조회 */
export const getHoList =
    async (aptCmplexNo, dongNo) => {

        const response =
            await requestApi.get(
                '/api/offlineCtrt/apt/ho-list',
                {
                    params: {
                        aptCmplexNo,
                        dongNo
                    }
                }
            );

        return response.data;
    };