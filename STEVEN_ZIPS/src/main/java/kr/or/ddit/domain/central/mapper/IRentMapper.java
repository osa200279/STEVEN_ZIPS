package kr.or.ddit.domain.central.mapper;

import kr.or.ddit.domain.central.dto.RentListingMapDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface IRentMapper {

    List<RentListingMapDTO> selectRentListingMapList();

    RentListingMapDTO selectRentListingDetail(@Param("rentLstgNo") String rentLstgNo);
}
