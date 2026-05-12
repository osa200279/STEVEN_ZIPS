package kr.or.ddit.domain.member.resident.mapper;


import kr.or.ddit.domain.central.dto.FacilityInfoDTO;
import kr.or.ddit.domain.member.resident.dto.ResidentFacilityHistoryDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 입주민 시설관리이력 Mapper
 *
 * Mapper란?
 * → Java 메서드와 MyBatis XML SQL을 연결하는 인터페이스.
 */
@Mapper
public interface IResidentFacilityMapper {

    String selectResidentAptCmplexNo(@Param("userNo") String userNo);

    FacilityInfoDTO selectAptInfo(@Param("aptCmplexNo") String aptCmplexNo);

    List<ResidentFacilityHistoryDTO> selectFacilityStatusCardList(@Param("aptCmplexNo") String aptCmplexNo);

    List<ResidentFacilityHistoryDTO> selectFacilityHistoryList(
            @Param("aptCmplexNo") String aptCmplexNo,
            @Param("facilityTyCd") String facilityTyCd,
            @Param("startRow") int startRow,
            @Param("endRow") int endRow
    );

    int selectFacilityHistoryCount(@Param("aptCmplexNo") String aptCmplexNo,
                                   @Param("facilityTyCd") String facilityTyCd);

    /*
     * 입주민 시설관리이력 화면 - 단지 시설 목록 조회
     */
    List<FacilityInfoDTO> selectResidentFacilityInfoList(
            @Param("aptCmplexNo") String aptCmplexNo,
            @Param("facilityTyCd") String facilityTyCd
    );
}