package kr.or.ddit.domain.apt.mgmtOffice.facility.service;

import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.domain.apt.mgmtOffice.facility.dto.FacilityDTO;
import kr.or.ddit.domain.apt.mgmtOffice.facility.vo.FacilityVO;
import org.springframework.web.multipart.MultipartFile;
import kr.or.ddit.domain.apt.mgmtOffice.facility.dto.FacilityLocationDTO;
import java.util.List;
import java.util.Map;

/**
 * 시설 Service 인터페이스
 */
public interface IFacilityService {

    /**
     * 시설 목록 조회
     *
     * FACILITY 테이블 기준 기존 시설 목록 조회
     * 일반시설 등록/수정 화면의 기존 흐름 유지용
     */
    List<FacilityVO> selectFacilityList(Map<String, Object> paramMap);

    /**
     * 시설 화면 목록 조회
     *
     * 조회 기준
     * - FACILITY 기준 전체 시설 조회
     * - PUBLIC_FACILITY 연결 여부로 일반시설/편의시설 구분
     *
     * 사용 위치
     * - 시설관리 목록 화면
     * - 일반시설/편의시설 통합 목록 표시
     * - 화면 버튼 분기용 facilityKind 확인
     *
     * paramMap 검색 조건 키
     * - mgmtOfcNo     : 관리사무소 번호
     * - facilityKind  : 시설종류, ALL/FACILITY/PUBLIC
     * - keyword       : 시설명·상세위치 검색어
     * - facilityTyCd  : 시설유형코드
     * - useYn         : 사용여부
     * - dongNo        : 동번호
     */
    List<FacilityDTO> selectFacilityViewList(Map<String, Object> paramMap);

    int selectFacilityViewCount(Map<String, Object> paramMap);

    /**
     * 시설 화면 상세 조회
     *
     * 조회 기준
     * - FACILITY.FACILITY_NO 기준 단건 조회
     * - PUBLIC_FACILITY 연결 시 편의시설 요약 정보 포함
     *
     * 사용 위치
     * - 일반시설 상세 요약
     * - 편의시설 상세 요약
     * - 시설 기본 상세 표시
     * - 편의시설 기본 정보 표시
     * - 점검/협력업체/검침 정보는 추후 별도 조회로 확장
     */
    FacilityDTO selectFacilityViewDetail(
            String mgmtOfcNo,   // 관리사무소 번호
            String facilityNo   // 시설번호, FACILITY.FACILITY_NO
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
     * 상세/수정 화면용
     */
    List<AttachFileVO> selectFacilityFileList(Long fileGroupNo); // 파일그룹번호

    /**
     * 이용불가 시설 통계 조회
     * 현황 카드 표시용
     *
     * 반환 키
     * - DISABLED_TOTAL : 전체 이용불가 시설 수
     * - DISABLED_TODAY : 오늘 FAULT 판정 건수
     */
    Map<String, Object> selectDisabledStats(String mgmtOfcNo); // 관리사무소 번호

    /**
     * 시설 등록
     *
     * 처리 순서
     * 1. 시설번호 채번
     * 2. 단지번호 서버 기준 세팅
     * 3. 사진 업로드
     * 4. FACILITY INSERT
     */
    boolean insertFacility(
            String mgmtOfcNo,               // 관리사무소 번호
            FacilityVO facilityVO,          // 등록할 시설 정보
            MultipartFile[] facilityFiles,  // 업로드할 사진 파일 목록
            String userNo                   // 로그인 사용자 번호 (파일 경로 생성용)
    );

    /**
     * 시설 수정
     *
     * 수정 가능: 시설명 · 설치일자 · 상세위치 · 사용여부 · 사진
     * 수정 제외: 시설유형 · 단지번호 · 동번호
     */
    boolean updateFacility(
            String mgmtOfcNo,               // 관리사무소 번호
            FacilityVO facilityVO,          // 수정할 시설 정보
            MultipartFile[] facilityFiles,  // 추가할 사진 파일 목록
            String deleteFileUuids,         // 삭제할 FILE_SAVE_UUID 목록 (쉼표 구분)
            String userNo                   // 로그인 사용자 번호
    );

    /**
     * 시설유형 정정 가능 여부 조회
     * 계약·점검이력·검침기록 연결 데이터 없으면 true 반환
     * 실제 변경은 하지 않음
     */
    boolean checkFacilityTypeCorrection(String mgmtOfcNo, FacilityVO facilityVO);

    /**
     * 시설유형 정정
     * 계약·점검이력·검침기록 연결 여부 확인 후 시설유형 변경
     */
    boolean correctFacilityType(
            String mgmtOfcNo,       // 관리사무소 번호
            FacilityVO facilityVO   // 정정할 시설번호 + 시설유형코드
    );

    /**
     * 시설 사용여부 변경
     * 삭제 대신 USE_YN 변경
     * FAULT 시 트리거 자동 N / 복구는 수동 Y
     */
    boolean updateFacilityUseYn(
            String mgmtOfcNo,       // 관리사무소 번호
            FacilityVO facilityVO   // 변경할 시설번호 + 사용여부
    );

    /**
     * 시설 사진 삭제
     * Google Drive 휴지통 이동 + ATTACH_FILE 삭제
     */
    boolean deleteFacilityFile(Map<String, Object> param);

    /**
     * 동 목록 조회
     * 시설 등록 화면 동 선택 드롭다운용
     */
    List<FacilityVO> selectDongList(String mgmtOfcNo); // 관리사무소 번호

    /**
     * 시설유형 필터 목록 조회
     * - FACILITY_TY 공통코드 기준
     * - 편의시설 탭은 PUBLIC_FACILITY 연결 유형만 조회
     */
    List<Map<String, Object>> selectFacilityTypeList(Map<String, Object> paramMap);

    /**
     * 시설 위치 동 목록 조회
     * 관리사무소 번호 기준으로 단지번호를 찾은 뒤 APT_UNIT 동 목록 조회
     */
    List<FacilityLocationDTO> selectFacilityUnitList(String mgmtOfcNo);

    /**
     * 시설 위치 층 목록 조회
     * 선택한 동번호 기준으로 APT_DETAIL 층 목록 조회
     */
    List<FacilityLocationDTO> selectFacilityFloorList(String dongNo);

    /**
     * 시설 위치 호 목록 조회
     * 선택한 동번호와 층 기준으로 APT_DETAIL 호 목록 조회
     */
    List<FacilityLocationDTO> selectFacilityRoomList(String dongNo, String floor);
}
