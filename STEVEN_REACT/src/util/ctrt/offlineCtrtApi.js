import requestApi
    from '../api/requestApi';

/* 아파트 검색 */
export const searchApartment =
    async (keyword, page = 1, size = 10) => {
        const response = await requestApi.get(
                '/api/react/apt/search',
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
                '/api/react/apt/dong-list',
                {
                    params: {
                        aptCmplexNo
                    }
                }
            );

        return response.data;
    };
