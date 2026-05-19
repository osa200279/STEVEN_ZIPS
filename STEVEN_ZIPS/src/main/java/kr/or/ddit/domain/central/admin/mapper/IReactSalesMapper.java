package kr.or.ddit.domain.central.admin.mapper;

import kr.or.ddit.domain.apt.main.vo.AptDetailVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface IReactSalesMapper {
    List<String> selectBuildingList(String aptCmplexNo);

    List<AptDetailVO> selectHoList(String aptCmplexNo, String dongNm);
}
