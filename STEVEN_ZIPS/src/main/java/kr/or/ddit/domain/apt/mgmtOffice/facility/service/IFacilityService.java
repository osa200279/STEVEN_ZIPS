package kr.or.ddit.domain.apt.mgmtOffice.facility.service;

import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.domain.apt.mgmtOffice.facility.dto.FacilityDTO;
import kr.or.ddit.domain.apt.mgmtOffice.facility.dto.FacilityLocationDTO;
import kr.or.ddit.domain.apt.mgmtOffice.facility.vo.FacilityVO;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

/**
 * 시설 Service 인터페이스
 *
 * 역할
 * - 시설자산 조회
 * - 시설자산 등록/수정
 * - 시설 사진 업로드/삭제
 * - 시설유형 정정
 * - 위치 조회
 */
public interface IFacilityService {

    /**
     * 시설 목록 조회
     */
    List<FacilityVO> selectFacilityList(Map<String, Object> paramMap);

    /**
     * 시설 화면 목록 조회
     *
     * 사용 위치
     * - 시설자산 목록 화면
     * - 일반시설/편의시설 통합 목록
     */
    List<FacilityDTO> selectFacilityViewList(Map<String, Object> paramMap);

    /**
     * 시설 화면 목록 건수 조회
     */
    int selectFacilityViewCount(Map<String, Object> paramMap);

    /**
     * 시설 화면 상세 조회
     */
    FacilityDTO selectFacilityViewDetail(
            String mgmtOfcNo,   // 관리사무소 번호
            String facilityNo   // 시설번호
    );

    /**
     * 시설 상세 조회
     */
    FacilityVO selectFacilityDetail(
            String mgmtOfcNo,   // 관리사무소 번호
            String facilityNo   // 시설번호
    );

    /**
     * 시설 첨부파일 목록 조회
     */
    List<AttachFileVO> selectFacilityFileList(Long fileGroupNo);

    /**
     * 이용불가 시설 통계 조회
     */
    Map<String, Object> selectDisabledStats(String mgmtOfcNo);

    /**
     * 시설 등록
     *
     * 처리 범위
     * - 시설번호 채번
     * - 단지번호 세팅
     * - 시설 사진 업로드
     * - FACILITY 등록
     */
    boolean insertFacility(
            String mgmtOfcNo,               // 관리사무소 번호
            FacilityVO facilityVO,          // 등록 시설 정보
            MultipartFile[] facilityFiles,  // 업로드 사진 목록
            String userNo                   // 로그인 사용자 번호
    );

    /**
     * 시설 수정
     *
     * 처리 범위
     * - 기존 시설 조회
     * - 수정값 보정
     * - 기존 사진 삭제
     * - 신규 사진 업로드
     * - FACILITY 수정
     */
    boolean updateFacility(
            String mgmtOfcNo,               // 관리사무소 번호
            FacilityVO facilityVO,          // 수정 시설 정보
            MultipartFile[] facilityFiles,  // 추가 사진 목록
            String deleteFileUuids,         // 삭제 사진 UUID 목록
            String userNo                   // 로그인 사용자 번호
    );

    /**
     * 시설유형 정정 가능 여부 조회
     */
    boolean checkFacilityTypeCorrection(
            String mgmtOfcNo,       // 관리사무소 번호
            FacilityVO facilityVO   // 시설번호 정보
    );

    /**
     * 시설유형 정정
     */
    boolean correctFacilityType(
            String mgmtOfcNo,       // 관리사무소 번호
            FacilityVO facilityVO   // 정정 시설 정보
    );

    /**
     * 시설 사용여부 변경
     */
    boolean updateFacilityUseYn(
            String mgmtOfcNo,       // 관리사무소 번호
            FacilityVO facilityVO   // 사용여부 변경 정보
    );

    /**
     * 시설 사진 삭제
     */
    boolean deleteFacilityFile(Map<String, Object> param);

    /**
     * 동 목록 조회
     */
    List<FacilityVO> selectDongList(String mgmtOfcNo);

    /**
     * 시설유형 필터 목록 조회
     */
    List<Map<String, Object>> selectFacilityTypeList(Map<String, Object> paramMap);

    /**
     * 등록 화면 편의시설 유형 목록 조회
     */
    List<Map<String, Object>> selectPublicFacilityTypeList();

    /**
     * 시설 위치 동 목록 조회
     */
    List<FacilityLocationDTO> selectFacilityUnitList(String mgmtOfcNo);

    /**
     * 시설 위치 층 목록 조회
     */
    List<FacilityLocationDTO> selectFacilityFloorList(String dongNo);

    /**
     * 시설 위치 호 목록 조회
     */
    List<FacilityLocationDTO> selectFacilityRoomList(String dongNo, String floor);
}
