package kr.or.ddit.domain.member.resident.dto;

import kr.or.ddit.domain.central.dto.FacilityInfoDTO;
import lombok.Data;

import java.util.List;

/**
 * 입주민 시설관리이력 DTO
 *
 */
@Data
public class ResidentFacilityHistoryDTO {

    private String aptCmplexNo;        // 단지번호
    private String aptCmplexNm;        // 단지명

    private String facilityNo;         // 시설번호
    private String facilityNm;         // 시설명
    private String facilityTyCd;       // 시설유형코드

    private String facChkHstryNo;      // 시설점검이력번호
    private String chkDt;              // 점검일
    private String chkSttsCd;          // 점검상태코드
    private String chkCn;              // 점검내용
    private String chkTyCd;            // 점검유형코드

    private String partnerNm;          // 협력업체명
    private String picNm;              // 담당자명

    private int startRow;              // 페이징 시작 행
    private int endRow;                // 페이징 끝 행


    /*
     * 단지 기본정보 객체
     * → apt_headerLayout.jsp에서
     *   ${aptInfo.aptComplexInfo}를 apt 변수에 담고,
     *   ${apt.aptCmplexNo}, ${apt.aptCmplexNm}처럼 사용하기 때문.
     */
    private FacilityInfoDTO aptComplexInfo;

    /*
     * 관리사무소 정보
     */
    private String mgmtOfficeInfo;

    /*
     * 공고 목록
     */
    private List<FacilityInfoDTO> annBoardPostInfoList;



}