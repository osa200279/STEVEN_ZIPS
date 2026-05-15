package kr.or.ddit.domain.apt.mgmtOffice.facility.controller;

import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.domain.apt.mgmtOffice.common.service.IManagerModelService;
import kr.or.ddit.domain.apt.mgmtOffice.facility.dto.FacilityDTO;
import kr.or.ddit.domain.apt.mgmtOffice.facility.dto.FacilityLocationDTO;
import kr.or.ddit.domain.apt.mgmtOffice.facility.service.IFacilityService;
import kr.or.ddit.domain.apt.mgmtOffice.facility.vo.FacilityVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 시설 Controller
 *
 * 역할
 * - 시설자산 화면 이동
 * - 시설자산 조회 API
 * - 시설자산 등록/수정 API
 * - 시설유형 정정 API
 * - 위치 조회 API
 *
 * 정리 기준
 * - 사진 업로드/삭제는 Service에서 동기 처리
 * - Controller는 요청 수신, Service 호출, 응답 구성만 담당
 */
@Slf4j
@Controller
@PreAuthorize("hasRole('MNGR')")
@RequestMapping("/manager/facility")
public class FacilityController {

    @Autowired
    private IFacilityService facilityService; // 시설 Service

    @Autowired
    private IManagerModelService managerModelService; // 관리사무소 공통 모델 Service



    /**
     * 시설 등록 화면 이동
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @GetMapping("/register/{mgmtOfcNo}")
    public String facilityRegisterPage(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        /* 관리사무소 공통 화면 모델 */
        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);

        /* 화면 API 기준 관리사무소 번호 */
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);

        /* 시설 위치 선택용 동 목록 */
        model.addAttribute("dongList", facilityService.selectDongList(mgmtOfcNo));

        /* 등록 화면 편의시설 유형 목록 */
        model.addAttribute("publicFacilityTypeList", facilityService.selectPublicFacilityTypeList());

        /* 시설자산 등록 JSP */
        return "apt/mgmtOffice/facility/mngr_facility_register";
    }

    /**
     * 시설 수정 화면 이동
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @GetMapping("/update-page/{mgmtOfcNo}/{facilityNo}")
    public String facilityUpdatePage(
            @PathVariable String mgmtOfcNo,
            @PathVariable String facilityNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        /* 관리사무소 공통 화면 모델 */
        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);

        /* 화면 API 기준 관리사무소 번호 */
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);

        /* 수정 대상 시설번호 */
        model.addAttribute("facilityNo", facilityNo);

        /* 시설 위치 선택용 동 목록 */
        model.addAttribute("dongList", facilityService.selectDongList(mgmtOfcNo));

        /* 시설자산 수정 JSP */
        return "apt/mgmtOffice/facility/mngr_facility_update";
    }

    /**
     * 시설 상세 화면 이동
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/detail-page/{mgmtOfcNo}/{facilityNo}")
    public String facilityDetailPage(
            @PathVariable String mgmtOfcNo,
            @PathVariable String facilityNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        /* 관리사무소 공통 화면 모델 */
        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);

        /* 화면 API 기준 관리사무소 번호 */
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);

        /* 상세 조회 대상 시설번호 */
        model.addAttribute("facilityNo", facilityNo);

        /* 시설자산 상세 JSP */
        return "apt/mgmtOffice/facility/mngr_facility_detail";
    }

    /**
     * 시설 목록 조회
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
            @RequestParam(required = false, defaultValue = "") String dongNo,
            @RequestParam(required = false, defaultValue = "") String instlStartDt,
            @RequestParam(required = false, defaultValue = "") String instlEndDt
    ) {
        /* JSON 응답 Map */
        Map<String, Object> result = new HashMap<>();

        try {
            /* 검색 조건 Map */
            Map<String, Object> paramMap = new HashMap<>();
            paramMap.put("mgmtOfcNo", mgmtOfcNo);
            paramMap.put("facilityKind", facilityKind);
            paramMap.put("keyword", keyword);
            paramMap.put("facilityTyCd", facilityTyCd);
            paramMap.put("useYn", useYn);
            paramMap.put("dongNo", dongNo);
            paramMap.put("instlStartDt", instlStartDt);
            paramMap.put("instlEndDt", instlEndDt);

            /* 시설 목록 조회 */
            List<FacilityDTO> list = facilityService.selectFacilityViewList(paramMap);

            /* 성공 응답 구성 */
            result.put("success", true);
            result.put("list", list);
        } catch (Exception e) {
            /* 시설 목록 조회 오류 로그 */
            log.error("시설 목록 조회 오류", e);

            /* 실패 응답 구성 */
            result.put("success", false);
            result.put("message", "시설 목록 조회 중 오류가 발생했습니다.");
            result.put("list", new ArrayList<>());
        }

        /* JSON 응답 반환 */
        return ResponseEntity.ok(result);
    }

    /**
     * 시설 목록 건수 조회
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/count/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> selectFacilityCount(
            @PathVariable String mgmtOfcNo,
            @RequestParam(required = false, defaultValue = "ALL") String facilityKind,
            @RequestParam(required = false, defaultValue = "") String keyword,
            @RequestParam(required = false, defaultValue = "") String facilityTyCd,
            @RequestParam(required = false, defaultValue = "") String useYn,
            @RequestParam(required = false, defaultValue = "") String dongNo,
            @RequestParam(required = false, defaultValue = "") String instlStartDt,
            @RequestParam(required = false, defaultValue = "") String instlEndDt
    ) {
        /* JSON 응답 Map */
        Map<String, Object> result = new HashMap<>();

        try {
            /* 검색 조건 Map */
            Map<String, Object> paramMap = new HashMap<>();
            paramMap.put("mgmtOfcNo", mgmtOfcNo);
            paramMap.put("facilityKind", facilityKind);
            paramMap.put("keyword", keyword);
            paramMap.put("facilityTyCd", facilityTyCd);
            paramMap.put("useYn", useYn);
            paramMap.put("dongNo", dongNo);
            paramMap.put("instlStartDt", instlStartDt);
            paramMap.put("instlEndDt", instlEndDt);

            /* 시설 목록 건수 조회 */
            int count = facilityService.selectFacilityViewCount(paramMap);

            /* 성공 응답 구성 */
            result.put("success", true);
            result.put("count", count);
        } catch (Exception e) {
            /* 시설 목록 건수 조회 오류 로그 */
            log.error("시설 목록 건수 조회 오류", e);

            /* 실패 응답 구성 */
            result.put("success", false);
            result.put("message", "시설 목록 건수 조회 중 오류가 발생했습니다.");
            result.put("count", 0);
        }

        /* JSON 응답 반환 */
        return ResponseEntity.ok(result);
    }

    /**
     * 시설 상세 조회
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/detail/{mgmtOfcNo}/{facilityNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> selectFacilityDetail(
            @PathVariable String mgmtOfcNo,
            @PathVariable String facilityNo
    ) {
        /* JSON 응답 Map */
        Map<String, Object> result = new HashMap<>();

        try {
            /* 시설 상세 조회 */
            FacilityDTO detail = facilityService.selectFacilityViewDetail(mgmtOfcNo, facilityNo);

            /* 시설 사진 목록 조회 */
            List<AttachFileVO> fileList = facilityService.selectFacilityFileList(
                    detail != null ? detail.getFileGroupNo() : null
            );

            /* 성공 응답 구성 */
            result.put("success", true);
            result.put("detail", detail);
            result.put("fileList", fileList);
            result.put("latestContract", null);
            result.put("recentCheckList", new ArrayList<>());
            result.put("meterInfo", null);
        } catch (Exception e) {
            /* 시설 상세 조회 오류 로그 */
            log.error("시설 상세 조회 오류", e);

            /* 실패 응답 구성 */
            result.put("success", false);
            result.put("message", "시설 상세 조회 중 오류가 발생했습니다.");
            result.put("detail", null);
            result.put("fileList", new ArrayList<>());
            result.put("latestContract", null);
            result.put("recentCheckList", new ArrayList<>());
            result.put("meterInfo", null);
        }

        /* JSON 응답 반환 */
        return ResponseEntity.ok(result);
    }

    /**
     * 시설 등록
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/insert/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> insertFacility(
            @PathVariable String mgmtOfcNo,
            @ModelAttribute FacilityVO facilityVO,
            @RequestPart(required = false) MultipartFile[] facilityFiles,
            @AuthenticationPrincipal CustomUser customUser
    ) {
        /* JSON 응답 Map */
        Map<String, Object> result = new HashMap<>();

        try {
            /* 로그인 사용자 번호 */
            String userNo = customUser.getMember().getUserNo();

            /* 시설 기본정보 + 사진 업로드 동기 처리 */
            boolean success = facilityService.insertFacility(
                    mgmtOfcNo,
                    facilityVO,
                    facilityFiles,
                    userNo
            );

            /* 성공 응답 구성 */
            result.put("success", success);
            result.put("facilityNo", facilityVO.getFacilityNo());
            result.put("message", success ? "시설이 등록되었습니다." : "시설 등록에 실패했습니다.");
        } catch (Exception e) {
            /* 시설 등록 오류 로그 */
            log.error("시설 등록 오류", e);

            /* 실패 응답 구성 */
            result.put("success", false);
            result.put("message", "시설 등록 중 오류가 발생했습니다.");
        }

        /* JSON 응답 반환 */
        return ResponseEntity.ok(result);
    }

    /**
     * 시설 수정
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/update/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateFacility(
            @PathVariable String mgmtOfcNo,
            @ModelAttribute FacilityVO facilityVO,
            @RequestPart(required = false) MultipartFile[] facilityFiles,
            @RequestParam(required = false, defaultValue = "") String deleteFileUuids,
            @AuthenticationPrincipal CustomUser customUser
    ) {
        /* JSON 응답 Map */
        Map<String, Object> result = new HashMap<>();

        try {
            /* 로그인 사용자 번호 */
            String userNo = customUser.getMember().getUserNo();

            /* 시설 기본정보 수정 + 사진 추가/삭제 동기 처리 */
            boolean success = facilityService.updateFacility(
                    mgmtOfcNo,
                    facilityVO,
                    facilityFiles,
                    deleteFileUuids,
                    userNo
            );

            /* 성공 응답 구성 */
            result.put("success", success);
            result.put("facilityNo", facilityVO.getFacilityNo());
            result.put("message", success ? "시설이 수정되었습니다." : "시설 수정에 실패했습니다.");
        } catch (Exception e) {
            /* 시설 수정 오류 로그 */
            log.error("시설 수정 오류", e);

            /* 실패 응답 구성 */
            result.put("success", false);
            result.put("message", "시설 수정 중 오류가 발생했습니다.");
        }

        /* JSON 응답 반환 */
        return ResponseEntity.ok(result);
    }

    /**
     * 시설유형 정정 가능 여부 조회
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/type/correct/check/{mgmtOfcNo}/{facilityNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> checkFacilityTypeCorrection(
            @PathVariable String mgmtOfcNo,
            @PathVariable String facilityNo
    ) {
        /* JSON 응답 Map */
        Map<String, Object> result = new HashMap<>();

        try {
            /* 정정 가능 여부 조회용 VO */
            FacilityVO facilityVO = new FacilityVO();
            facilityVO.setFacilityNo(facilityNo);

            /* 시설유형 정정 가능 여부 */
            boolean correctable = facilityService.checkFacilityTypeCorrection(mgmtOfcNo, facilityVO);

            /* 성공 응답 구성 */
            result.put("success", correctable);
            result.put(
                    "message",
                    correctable
                            ? "정정 가능한 시설입니다. 변경할 시설유형을 선택하고 저장하세요."
                            : "계약·점검·검침 데이터가 연결된 시설은 시설유형을 변경할 수 없습니다."
            );
        } catch (Exception e) {
            /* 시설유형 정정 가능 여부 조회 오류 로그 */
            log.error("시설유형 정정 가능 여부 조회 오류", e);

            /* 실패 응답 구성 */
            result.put("success", false);
            result.put("message", "시설유형 정정 가능 여부 확인 중 오류가 발생했습니다.");
        }

        /* JSON 응답 반환 */
        return ResponseEntity.ok(result);
    }

    /**
     * 시설유형 정정
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/type/correct/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> correctFacilityType(
            @PathVariable String mgmtOfcNo,
            @RequestBody FacilityVO facilityVO
    ) {
        /* JSON 응답 Map */
        Map<String, Object> result = new HashMap<>();

        try {
            /* 시설유형 정정 처리 */
            boolean success = facilityService.correctFacilityType(mgmtOfcNo, facilityVO);

            /* 성공 응답 구성 */
            result.put("success", success);
            result.put(
                    "message",
                    success
                            ? "시설 분류가 정정되었습니다."
                            : "연결된 계약/검침/점검 정보가 있어 분류를 변경할 수 없습니다."
            );
        } catch (Exception e) {
            /* 시설유형 정정 오류 로그 */
            log.error("시설 분류 정정 오류", e);

            /* 실패 응답 구성 */
            result.put("success", false);
            result.put("message", "시설 분류 정정 중 오류가 발생했습니다.");
        }

        /* JSON 응답 반환 */
        return ResponseEntity.ok(result);
    }

    /**
     * 시설 사용여부 변경
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/use/update/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateFacilityUseYn(
            @PathVariable String mgmtOfcNo,
            @RequestBody FacilityVO facilityVO
    ) {
        /* JSON 응답 Map */
        Map<String, Object> result = new HashMap<>();

        try {
            /* 시설 사용여부 변경 처리 */
            boolean success = facilityService.updateFacilityUseYn(mgmtOfcNo, facilityVO);

            /* 성공 응답 구성 */
            result.put("success", success);
            result.put("message", success ? "시설 사용여부가 변경되었습니다." : "시설 사용여부 변경에 실패했습니다.");
        } catch (Exception e) {
            /* 시설 사용여부 변경 오류 로그 */
            log.error("시설 사용여부 변경 오류", e);

            /* 실패 응답 구성 */
            result.put("success", false);
            result.put("message", "시설 사용여부 변경 중 오류가 발생했습니다.");
        }

        /* JSON 응답 반환 */
        return ResponseEntity.ok(result);
    }

    /**
     * 시설 사진 삭제
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/file/delete/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteFacilityFile(
            @PathVariable String mgmtOfcNo,
            @RequestBody Map<String, Object> param
    ) {
        /* JSON 응답 Map */
        Map<String, Object> result = new HashMap<>();

        try {
            /* 관리사무소 번호 추가 */
            param.put("mgmtOfcNo", mgmtOfcNo);

            /* 시설 사진 삭제 처리 */
            boolean success = facilityService.deleteFacilityFile(param);

            /* 성공 응답 구성 */
            result.put("success", success);
            result.put("message", success ? "시설 사진이 삭제되었습니다." : "시설 사진 삭제에 실패했습니다.");
        } catch (Exception e) {
            /* 시설 사진 삭제 오류 로그 */
            log.error("시설 사진 삭제 오류", e);

            /* 실패 응답 구성 */
            result.put("success", false);
            result.put("message", "시설 사진 삭제 중 오류가 발생했습니다.");
        }

        /* JSON 응답 반환 */
        return ResponseEntity.ok(result);
    }

    /**
     * 시설 동 목록 조회
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/dong/list/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> selectDongList(
            @PathVariable String mgmtOfcNo
    ) {
        /* JSON 응답 Map */
        Map<String, Object> result = new HashMap<>();

        try {
            /* 동 목록 조회 */
            List<FacilityVO> list = facilityService.selectDongList(mgmtOfcNo);

            /* 성공 응답 구성 */
            result.put("success", true);
            result.put("list", list);
        } catch (Exception e) {
            /* 시설 동 목록 조회 오류 로그 */
            log.error("시설 동 목록 조회 오류", e);

            /* 실패 응답 구성 */
            result.put("success", false);
            result.put("message", "시설 동 목록 조회 중 오류가 발생했습니다.");
            result.put("list", new ArrayList<>());
        }

        /* JSON 응답 반환 */
        return ResponseEntity.ok(result);
    }

    /**
     * 위치 동 목록 조회
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/location/units/{mgmtOfcNo}")
    @ResponseBody
    public List<FacilityLocationDTO> selectFacilityUnitList(
            @PathVariable String mgmtOfcNo
    ) {
        /* 시설 위치 동 목록 반환 */
        return facilityService.selectFacilityUnitList(mgmtOfcNo);
    }

    /**
     * 위치 층 목록 조회
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/location/floors/{mgmtOfcNo}")
    @ResponseBody
    public List<FacilityLocationDTO> selectFacilityFloorList(
            @PathVariable String mgmtOfcNo,
            @RequestParam String dongNo
    ) {
        /* 시설 위치 층 목록 반환 */
        return facilityService.selectFacilityFloorList(dongNo);
    }

    /**
     * 위치 호 목록 조회
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/location/rooms/{mgmtOfcNo}")
    @ResponseBody
    public List<FacilityLocationDTO> selectFacilityRoomList(
            @PathVariable String mgmtOfcNo,
            @RequestParam String dongNo,
            @RequestParam String floor
    ) {
        /* 시설 위치 호 목록 반환 */
        return facilityService.selectFacilityRoomList(dongNo, floor);
    }

    /**
     * 시설유형 필터 목록 조회
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/type/list/{mgmtOfcNo}")
    @ResponseBody
    public Map<String, Object> selectFacilityTypeList(
            @PathVariable String mgmtOfcNo,
            @RequestParam(defaultValue = "ALL") String facilityKind
    ) {
        /* 시설유형 조회 조건 Map */
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("mgmtOfcNo", mgmtOfcNo);
        paramMap.put("facilityKind", facilityKind);

        /* 시설유형 목록 조회 */
        List<Map<String, Object>> typeList = facilityService.selectFacilityTypeList(paramMap);

        /* JSON 응답 Map */
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("typeList", typeList);

        /* JSON 응답 반환 */
        return result;
    }
}
