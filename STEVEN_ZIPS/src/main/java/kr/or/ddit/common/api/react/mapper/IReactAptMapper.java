package kr.or.ddit.common.api.react.mapper;

import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface IReactAptMapper {
    List<AptComplexVO> searchApartment(String keyword, int startRow, int size);

    int countApartment(String keyword);

    List<String> getDongList(String aptCmplexNo);
}
