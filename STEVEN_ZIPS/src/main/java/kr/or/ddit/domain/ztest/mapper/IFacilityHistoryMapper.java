package kr.or.ddit.domain.ztest.mapper;

import kr.or.ddit.domain.ztest.vo.FacilityHistoryVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface IFacilityHistoryMapper {


    List<FacilityHistoryVO> selectFacilityHistoryList();

    FacilityHistoryVO selectFacilityHistoryDetail(String id);
}
