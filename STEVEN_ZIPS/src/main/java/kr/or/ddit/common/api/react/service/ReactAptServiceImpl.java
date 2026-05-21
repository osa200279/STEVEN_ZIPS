package kr.or.ddit.common.api.react.service;

import kr.or.ddit.common.api.react.mapper.IReactAptMapper;
import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ReactAptServiceImpl implements IReactAptService {

    @Autowired
    private IReactAptMapper reactAptMapper;

    @Override
    public Map<String, Object> searchApartment(
            String keyword
            , int page
            , int size
    ) {
        int startRow = (page - 1) * size;
        List<AptComplexVO> content = reactAptMapper.searchApartment(
                keyword,
                startRow,
                size
        );

        int totalCount = reactAptMapper.countApartment(
                keyword
        );

        boolean hasNext = totalCount > (page * size);

        Map<String, Object> result = new HashMap<>();

        result.put(
                "content",
                content
        );

        result.put(
                "page",
                page
        );

        result.put(
                "size",
                size
        );

        result.put(
                "totalCount",
                totalCount
        );

        result.put(
                "hasNext",
                hasNext
        );

        return result;
    }

    @Override
    public List<String> getDongList(String aptCmplexNo) {
        return reactAptMapper.getDongList(aptCmplexNo);
    }
}
