package kr.or.ddit.domain.central.mapper;

import kr.or.ddit.domain.central.dto.FacilityInfoDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface IFacilityInfoMapper {

    /**
     * 단지 시설 정보 조회
     */
    List<FacilityInfoDTO> selectFacilityInfoList(FacilityInfoDTO dto);

    List<FacilityInfoDTO> selectAptCardList(FacilityInfoDTO dto);


}
