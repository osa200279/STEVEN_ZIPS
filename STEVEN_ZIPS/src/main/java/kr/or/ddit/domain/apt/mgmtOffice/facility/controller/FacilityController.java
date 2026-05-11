package kr.or.ddit.domain.apt.mgmtOffice.facility.controller;

import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.domain.apt.mgmtOffice.facility.dto.FacilityDTO;
import kr.or.ddit.domain.apt.mgmtOffice.facility.service.IFacilityService;
import kr.or.ddit.domain.apt.mgmtOffice.facility.vo.FacilityVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 시설 Controller
 *
 * [역할]
 * - 시설관리 화면 API 처리
 * - 일반시설/편의시설 통합 조회 처리
 * - 일반시설 등록/수정/사용여부 변경 처리
 * - 시설 사진 첨부파일 처리
 *
 * [객체 사용 기준]
 * - FacilityDTO: 시설관리 화면 목록/상세 조회용
 * - FacilityVO : FACILITY 등록/수정/사용여부 변경용
 */
@Slf4j
@Controller
@PreAuthorize("hasRole('MNGR')")
@RequestMapping("/manager/facility")
public class FacilityController {

    @Autowired
    private IFacilityService facilityService; // 시설 Service

    /**
     * 시설 목록 조회
     *
     * ADMIN: 조회 가능
     * MNGR : 조회 가능
     *
     * 조회 기준
     * - FACILITY 기준 전체 시설 조회
     * - PUBLIC_FACILITY 연결 여부로 일반시설/편의시설 구분
     * - 목록 화면은 FacilityDTO 기준으로 응답
     *
     * 검색 조건
     * - facilityKind : 시설종류, ALL/FACILITY/PUBLIC
     * - keyword      : 시설번호·시설명·편의시설명·상세위치 검색어
     * - facilityTyCd : 시설유형코드
     * - useYn        : 사용여부
     * - dongNo       : 동번호
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/list/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> selectFacilityList(
            @PathVariable String mgmtOfcNo,
            @RequestParam(required = false, defaultValue = "ALL") String facilityKind,
            @RequestParam(required = false, defaultValue = "") String keyword,
            @RequestParam(required = false, defaultValue = "") String facilityTyCd,
            @RequestParam(required = false, defaultValue = "") String useYn,
            @RequestParam(required = false, defaultValue = "") String dongNo
            //검침 이력, 유지보수이력 연결시 다시 쓸 수 있으면 쓰기
            //@RequestParam(required = false, defaultValue = "") String meterLinkedYn
    ) {
        Map<String, Object> result = new HashMap<>(); // JSON 응답 Map

        try {
            /* 검색 조건 전달용 Map 구성 */
            Map<String, Object> paramMap = new HashMap<>();
            paramMap.put("mgmtOfcNo", mgmtOfcNo);           // 관리사무소 번호
            paramMap.put("facilityKind", facilityKind);     // 시설종류, ALL/FACILITY/PUBLIC
            paramMap.put("keyword", keyword);               // 통합 검색어
            paramMap.put("facilityTyCd", facilityTyCd);     // 시설유형코드
            paramMap.put("useYn", useYn);                   // 사용여부
            paramMap.put("dongNo", dongNo);                 // 동번호
           // paramMap.put("meterLinkedYn", meterLinkedYn);   // 검침연결여부

            /* 시설 화면 목록 조회 */
            List<FacilityDTO> list = facilityService.selectFacilityViewList(paramMap);

            result.put("success", true);
            result.put("list", list);

        } catch (Exception e) {
            log.error("시설 목록 조회 오류", e);

            result.put("success", false);
            result.put("message", "시설 목록 조회 중 오류가 발생했습니다.");
            result.put("list", new ArrayList<>());
        }

        return ResponseEntity.ok(result);
    }

    /**
     * 시설 상세 조회
     *
     * ADMIN: 조회 가능
     * MNGR : 조회 가능
     *
     * 조회 기준
     * - FACILITY.FACILITY_NO 기준 단건 조회
     * - PUBLIC_FACILITY 연결 시 편의시설 요약 정보 포함
     * - 상세 화면은 FacilityDTO 기준으로 응답
     *
     * 사진 조회 기준
     * - 첨부파일은 FACILITY 테이블의 FILE_GROUP_NO 기준
     * - FacilityDTO에는 FILE_GROUP_NO가 없으므로 기존 FacilityVO 상세 조회로 파일그룹번호만 별도 확인
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/detail/{mgmtOfcNo}/{facilityNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> selectFacilityDetail(
            @PathVariable String mgmtOfcNo,
            @PathVariable String facilityNo
    ) {
        Map<String, Object> result = new HashMap<>(); // JSON 응답 Map

        try {
            /* 시설 화면 상세 조회 */
            FacilityDTO detail = facilityService.selectFacilityViewDetail(mgmtOfcNo, facilityNo);

            /* 파일그룹번호 확인용 기존 FACILITY 상세 조회 */
            FacilityVO savedFacility = facilityService.selectFacilityDetail(mgmtOfcNo, facilityNo);

            /* 상세/수정 화면에서 출력할 기존 시설 사진 목록 */
            List<AttachFileVO> fileList = facilityService.selectFacilityFileList(
                    savedFacility != null ? savedFacility.getFileGroupNo() : null
            );

            result.put("success", true);
            result.put("detail", detail);
            result.put("fileList", fileList);
            result.put("latestContract", null);
            result.put("recentCheckList", new ArrayList<>());
            result.put("meterInfo", null);

        } catch (Exception e) {
            log.error("시설 상세 조회 오류", e);

            result.put("success", false);
            result.put("message", "시설 상세 조회 중 오류가 발생했습니다.");
            result.put("detail", null);
            result.put("fileList", new ArrayList<>());
            result.put("latestContract", null);
            result.put("recentCheckList", new ArrayList<>());
            result.put("meterInfo", null);

        }

        return ResponseEntity.ok(result);
    }

    /**
     * 시설 등록
     *
     * 신규 등록이므로 기존 삭제 파일은 없음
     * 새 사진 업로드만 처리
     *
     * 파일 업로드가 있으므로 multipart/form-data 방식 사용
     *
     * 주의
     * - 시설관리 화면의 일반시설 등록용
     * - 편의시설 등록은 기존 편의시설관리 화면에서 처리
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/insert/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> insertFacility(
            @PathVariable String mgmtOfcNo,
            @ModelAttribute FacilityVO facilityVO,
            @RequestParam(required = false) MultipartFile[] facilityFiles,
            @AuthenticationPrincipal CustomUser customUser
    ) {
        Map<String, Object> result = new HashMap<>(); // JSON 응답 Map

        try {
            /* 파일 저장 경로 생성용 로그인 사용자 번호 */
            String userNo = customUser.getMember().getUserNo();

            /* 시설 등록 + 사진 업로드 */
            boolean success = facilityService.insertFacility(
                    mgmtOfcNo,
                    facilityVO,
                    facilityFiles,
                    userNo
            );

            result.put("success", success);
            result.put("message", success ? "시설이 등록되었습니다." : "시설 등록에 실패했습니다.");

        } catch (Exception e) {
            log.error("시설 등록 오류", e);

            result.put("success", false);
            result.put("message", "시설 등록 중 오류가 발생했습니다.");
        }

        return ResponseEntity.ok(result);
    }

    /**
     * 시설 수정
     *
     * 기존 파일 삭제 + 신규 파일 추가 가능
     *
     * deleteFileUuids
     * = 삭제할 기존 첨부파일 번호 목록
     *
     * 주의
     * - 시설관리 화면의 일반시설 수정용
     * - 편의시설 수정은 기존 편의시설관리 화면에서 처리
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/update/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateFacility(
            @PathVariable String mgmtOfcNo,
            @ModelAttribute FacilityVO facilityVO,
            @RequestParam(required = false) MultipartFile[] facilityFiles,
            @RequestParam(required = false, defaultValue = "") String deleteFileUuids,
            @AuthenticationPrincipal CustomUser customUser
    ) {
        Map<String, Object> result = new HashMap<>(); // JSON 응답 Map

        try {
            /* 파일 저장 경로 생성용 로그인 사용자 번호 */
            String userNo = customUser.getMember().getUserNo();

            /* 시설 수정 처리 */
            boolean success = facilityService.updateFacility(
                    mgmtOfcNo,
                    facilityVO,
                    facilityFiles,
                    deleteFileUuids,
                    userNo
            );

            result.put("success", success);
            result.put("message", success ? "시설이 수정되었습니다." : "시설 수정에 실패했습니다.");

        } catch (Exception e) {
            log.error("시설 수정 오류", e);

            result.put("success", false);
            result.put("message", "시설 수정 중 오류가 발생했습니다.");
        }

        return ResponseEntity.ok(result);
    }

    /**
     * 시설유형 정정 가능 여부 조회
     *
     * 정정 버튼 클릭 시 실제 변경 전에 먼저 이 API를 호출
     * 계약·점검이력·검침기록 중 하나라도 연결되어 있으면 정정 불가 응답 반환
     * 실제 시설유형 변경은 하지 않고 연결 데이터 존재 여부만 확인
     *
     * 가능 여부 확인 결과
     * - success true  : 연결 데이터 없음 → 정정 가능 → 화면에서 드롭다운 잠금 해제
     * - success false : 연결 데이터 있음 → 정정 불가 → 화면에서 오류 메시지 표시
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/type/correct/check/{mgmtOfcNo}/{facilityNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> checkFacilityTypeCorrection(
            @PathVariable String mgmtOfcNo,
            @PathVariable String facilityNo
    ) {
        Map<String, Object> result = new HashMap<>(); // JSON 응답 Map

        try {
            /* 연결 데이터 존재 여부 조회용 VO 구성 */
            FacilityVO facilityVO = new FacilityVO();
            facilityVO.setFacilityNo(facilityNo); // 조회 대상 시설번호

            /* 시설유형 정정 가능 여부 조회 */
            boolean correctable = facilityService.checkFacilityTypeCorrection(mgmtOfcNo, facilityVO);

            result.put("success", correctable);
            result.put(
                    "message",
                    correctable
                            ? "정정 가능한 시설입니다. 변경할 시설유형을 선택하고 저장하세요."
                            : "계약·점검·검침 데이터가 연결된 시설은 시설유형을 변경할 수 없습니다."
            );

        } catch (Exception e) {
            log.error("시설유형 정정 가능 여부 조회 오류", e);

            result.put("success", false);
            result.put("message", "시설유형 정정 가능 여부 확인 중 오류가 발생했습니다.");
        }

        return ResponseEntity.ok(result);
    }

    /**
     * 시설유형 정정
     *
     * 일반 수정에서 처리하지 않는 시설유형 변경 전용
     * 정정 가능 여부는 checkFacilityTypeCorrection(GET)에서 먼저 확인 후 호출
     * 계약·점검이력·검침기록 연결 여부를 서버에서 한 번 더 검증 후 변경 처리
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/type/correct/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> correctFacilityType(
            @PathVariable String mgmtOfcNo,
            @RequestBody FacilityVO facilityVO
    ) {
        Map<String, Object> result = new HashMap<>(); // JSON 응답 Map

        try {
            /* 시설유형 정정 처리 */
            boolean success = facilityService.correctFacilityType(
                    mgmtOfcNo,
                    facilityVO
            );

            result.put("success", success);
            result.put(
                    "message",
                    success
                            ? "시설 분류가 정정되었습니다."
                            : "연결된 계약/검침/점검 정보가 있어 분류를 변경할 수 없습니다."
            );

        } catch (Exception e) {
            log.error("시설 분류 정정 오류", e);

            result.put("success", false);
            result.put("message", "시설 분류 정정 중 오류가 발생했습니다.");
        }

        return ResponseEntity.ok(result);
    }

    /**
     * 시설 사용여부 변경
     *
     * 삭제 대신 USE_YN 변경
     * Y = 사용 가능
     * N = 사용 불가
     *
     * 처리 기준
     * - 점검 FAULT 등으로 자동 N 처리 가능
     * - 점검 DONE 후에도 자동 Y 처리하지 않음
     * - 사용 불가 + 최근 점검완료 상태는 화면에서 확인 필요 표시
     * - 최종 사용 가능 처리 여부는 관리자가 수동 변경
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/use/update/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateFacilityUseYn(
            @PathVariable String mgmtOfcNo,
            @RequestBody FacilityVO facilityVO
    ) {
        Map<String, Object> result = new HashMap<>(); // JSON 응답 Map

        try {
            /* 시설 사용여부 변경 처리 */
            boolean success = facilityService.updateFacilityUseYn(mgmtOfcNo, facilityVO);

            result.put("success", success);
            result.put("message", success ? "시설 사용여부가 변경되었습니다." : "시설 사용여부 변경에 실패했습니다.");

        } catch (Exception e) {
            log.error("시설 사용여부 변경 오류", e);

            result.put("success", false);
            result.put("message", "시설 사용여부 변경 중 오류가 발생했습니다.");
        }

        return ResponseEntity.ok(result);
    }

    /**
     * 시설 사진 삭제
     *
     * 시설 자체 삭제가 아니라 첨부파일만 삭제
     * Google Drive 파일은 휴지통 이동 처리
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/file/delete/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteFacilityFile(
            @PathVariable String mgmtOfcNo,
            @RequestBody Map<String, Object> param
    ) {
        Map<String, Object> result = new HashMap<>(); // JSON 응답 Map

        try {
            /* 관리사무소 번호 전달 */
            param.put("mgmtOfcNo", mgmtOfcNo);

            /* 파일 삭제 처리 */
            boolean success = facilityService.deleteFacilityFile(param);

            result.put("success", success);
            result.put("message", success ? "시설 사진이 삭제되었습니다." : "시설 사진 삭제에 실패했습니다.");

        } catch (Exception e) {
            log.error("시설 사진 삭제 오류", e);

            result.put("success", false);
            result.put("message", "시설 사진 삭제 중 오류가 발생했습니다.");
        }

        return ResponseEntity.ok(result);
    }

    /**
     * 시설 동 목록 조회
     *
     * APT_UNIT 기준 단지 내 동 목록 조회
     * 시설 등록 화면 동 선택 드롭다운용
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/dong/list/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> selectDongList(
            @PathVariable String mgmtOfcNo
    ) {
        Map<String, Object> result = new HashMap<>(); // JSON 응답 Map

        try {
            /* 동 목록 조회 */
            List<FacilityVO> list = facilityService.selectDongList(mgmtOfcNo);

            result.put("success", true);
            result.put("list", list);

        } catch (Exception e) {
            log.error("시설 동 목록 조회 오류", e);

            result.put("success", false);
            result.put("message", "시설 동 목록 조회 중 오류가 발생했습니다.");
            result.put("list", new ArrayList<>());
        }

        return ResponseEntity.ok(result);
    }
}
