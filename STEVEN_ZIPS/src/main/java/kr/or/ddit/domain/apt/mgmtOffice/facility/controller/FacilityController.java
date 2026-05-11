package kr.or.ddit.domain.apt.mgmtOffice.facility.controller;

import kr.or.ddit.domain.apt.mgmtOffice.facility.service.IFacilityService;
import kr.or.ddit.domain.apt.mgmtOffice.facility.vo.FacilityVO;
import kr.or.ddit.common.file.vo.AttachFileVO;
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

@Slf4j
@Controller
@PreAuthorize("hasRole('MNGR')")
@RequestMapping("/manager/facility")
public class FacilityController {

    @Autowired
    private IFacilityService facilityService;


    /**
     * 시설 자산 목록 조회
     *
     * ADMIN: 조회 가능
     * MNGR : 조회 가능
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/api/list/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> selectFacilityList(
            @PathVariable String mgmtOfcNo,
            @RequestParam(required = false, defaultValue = "") String keyword,
            @RequestParam(required = false, defaultValue = "") String facilityTyCd,
            @RequestParam(required = false, defaultValue = "") String useYn,
            @RequestParam(required = false, defaultValue = "") String dongNo,
            @RequestParam(required = false, defaultValue = "") String meterLinkedYn
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            // 검색 조건 전달용 Map
            Map<String, Object> paramMap = new HashMap<>();
            paramMap.put("mgmtOfcNo", mgmtOfcNo);
            paramMap.put("keyword", keyword);
            paramMap.put("facilityTyCd", facilityTyCd);
            paramMap.put("useYn", useYn);
            paramMap.put("dongNo", dongNo);
            paramMap.put("meterLinkedYn", meterLinkedYn);

            // 시설 목록 조회
            List<FacilityVO> list = facilityService.selectFacilityList(paramMap);

            result.put("success", true);
            result.put("list", list);

        } catch (Exception e) {
            log.error("시설 자산 목록 조회 오류", e);

            result.put("success", false);
            result.put("message", "시설 자산 목록 조회 중 오류가 발생했습니다.");
            result.put("list", new ArrayList<>());
        }

        return ResponseEntity.ok(result);
    }


    /**
     * 시설 자산 상세 조회
     *
     * ADMIN: 조회 가능
     * MNGR : 조회 가능
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/api/detail/{mgmtOfcNo}/{facilityNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> selectFacilityDetail(
            @PathVariable String mgmtOfcNo,
            @PathVariable String facilityNo
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            // 시설 상세 조회
            FacilityVO detail = facilityService.selectFacilityDetail(mgmtOfcNo, facilityNo);
            // 상세/수정 화면에서 출력할 기존 시설 사진 목록
            List<AttachFileVO> fileList = facilityService.selectFacilityFileList(
                    detail != null ? detail.getFileGroupNo() : null
            );

            result.put("success", true);
            result.put("detail", detail);
            result.put("fileList", fileList);

        } catch (Exception e) {
            log.error("시설 자산 상세 조회 오류", e);

            result.put("success", false);
            result.put("message", "시설 자산 상세 조회 중 오류가 발생했습니다.");
            result.put("detail", null);
        }

        return ResponseEntity.ok(result);
    }


    /**
     * 시설 자산 등록
     *
     * 신규 등록이므로 기존 삭제 파일은 없음
     * 새 사진 업로드만 처리
     *
     * 파일 업로드가 있으므로 multipart/form-data 방식 사용
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/api/insert/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> insertFacility(
            @PathVariable String mgmtOfcNo,
            @ModelAttribute FacilityVO facilityVO,
            @RequestParam(required = false) MultipartFile[] facilityFiles,
            @AuthenticationPrincipal CustomUser customUser
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            // 파일 저장 경로 생성용 로그인 사용자 번호
            String userNo = customUser.getMember().getUserNo();

            // 시설 등록 + 사진 업로드
            boolean success = facilityService.insertFacility(
                    mgmtOfcNo,
                    facilityVO,
                    facilityFiles,
                    userNo
            );

            result.put("success", success);
            result.put("message", success ? "시설 자산이 등록되었습니다." : "시설 자산 등록에 실패했습니다.");

        } catch (Exception e) {
            log.error("시설 자산 등록 오류", e);

            result.put("success", false);
            result.put("message", "시설 자산 등록 중 오류가 발생했습니다.");
        }

        return ResponseEntity.ok(result);
    }


    /**
     * 시설 자산 수정
     *
     * 기존 파일 삭제 + 신규 파일 추가 가능
     *
     * deleteFileUuids
     * = 삭제할 기존 첨부파일 번호 목록
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/api/update/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateFacility(
            @PathVariable String mgmtOfcNo,
            @ModelAttribute FacilityVO facilityVO,
            @RequestParam(required = false) MultipartFile[] facilityFiles,
            @RequestParam(required = false, defaultValue = "") String deleteFileUuids,
            @AuthenticationPrincipal CustomUser customUser
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            // 파일 저장 경로 생성용 로그인 사용자 번호
            String userNo = customUser.getMember().getUserNo();

            /*
             * 시설 수정 처리
             * - 기본정보 수정
             * - 신규 사진 추가
             * - 기존 사진 삭제
             */
            boolean success = facilityService.updateFacility(
                    mgmtOfcNo,
                    facilityVO,
                    facilityFiles,
                    deleteFileUuids,
                    userNo
            );

            result.put("success", success);
            result.put("message", success ? "시설 자산이 수정되었습니다." : "시설 자산 수정에 실패했습니다.");

        } catch (Exception e) {
            log.error("시설 자산 수정 오류", e);

            result.put("success", false);
            result.put("message", "시설 자산 수정 중 오류가 발생했습니다.");
        }

        return ResponseEntity.ok(result);
    }

    /**
     * 시설유형 정정 가능 여부 조회
     *
     * 정정 버튼 클릭 시 실제 변경 전에 먼저 이 API를 호출한다.
     * 계약·점검이력·검침기록 중 하나라도 연결되어 있으면 정정 불가 응답을 반환한다.
     * 실제 시설유형 변경은 하지 않고 연결 데이터 존재 여부만 확인한다.
     *
     * 가능 여부 확인 결과
     * - success true  : 연결 데이터 없음 → 정정 가능 → 화면에서 드롭다운 잠금 해제
     * - success false : 연결 데이터 있음 → 정정 불가 → 화면에서 오류 메시지 표시
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/api/type/correct/check/{mgmtOfcNo}/{facilityNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> checkFacilityTypeCorrection(
            @PathVariable String mgmtOfcNo,  // 관리사무소 번호
            @PathVariable String facilityNo  // 정정 대상 시설번호
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            /*
             * 연결 데이터 존재 여부 조회
             * selectFacilityLinkedCount: 계약·점검이력·검침기록 건수 합산 단일 쿼리
             * 0이면 정정 가능 / 1 이상이면 정정 불가
             */
            FacilityVO facilityVO = new FacilityVO();
            facilityVO.setFacilityNo(facilityNo); // 조회 대상 시설번호

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
     * 정정 가능 여부는 checkFacilityTypeCorrection(GET)에서 먼저 확인 후 호출한다.
     * 계약·점검이력·검침기록 연결 여부를 서버에서 한 번 더 검증 후 변경 처리한다.
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/api/type/correct/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> correctFacilityType(
            @PathVariable String mgmtOfcNo,
            @RequestBody FacilityVO facilityVO
    ) {
        Map<String, Object> result = new HashMap<>();

        try {

            /*
             * 분류 정정 처리
             * - facilityNo
             * - facilityTyCd
             */
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
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/api/use/update/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateFacilityUseYn(
            @PathVariable String mgmtOfcNo,
            @RequestBody FacilityVO facilityVO
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            // 시설 활성/비활성 처리
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
    @PostMapping("/api/file/delete/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteFacilityFile(
            @PathVariable String mgmtOfcNo,
            @RequestBody Map<String, Object> param
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            // 관리사무소 번호 전달
            param.put("mgmtOfcNo", mgmtOfcNo);

            // 파일 삭제 처리
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
     * 현재는 등록된 시설의 DONG_NO 기준 목록
     * 추후 동 전체 목록 테이블이 확정되면 해당 테이블 기준으로 변경
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/api/dong/list/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> selectDongList(
            @PathVariable String mgmtOfcNo
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
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
