package kr.or.ddit.domain.apt.mgmtOffice.facility.check.controller;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.mgmtOffice.common.service.IManagerModelService;
import kr.or.ddit.domain.apt.mgmtOffice.facility.check.service.IFacilityCheckService;
import kr.or.ddit.domain.apt.mgmtOffice.facility.check.vo.FacilityCheckHstryVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 시설 점검 이력 Controller
 *
 * 역할
 * - 시설 점검 이력 목록/상세/등록/수정 화면 이동
 * - 등록/수정 통합 폼 화면에 필요한 모델 구성
 * - 시설 선택/협력업체 선택/같은 시설 이력 조회 AJAX 처리
 * - office_sidebar.jsp 직접 수정 없이 office_active_sidebar.jspf 기준 active 처리
 */
@Slf4j
@Controller
@PreAuthorize("hasRole('MNGR')")
@RequiredArgsConstructor
@RequestMapping("/manager/checkHistory")
public class FacilityCheckController {

    /** 시설 점검 이력 Service */
    private final IFacilityCheckService facilityCheckService;

    /** 관리사무소 공통 모델 Service */
    private final IManagerModelService managerModelService;

    /**
     * 시설 점검 이력 목록 화면
     *
     * 화면 역할
     * - 점검 이력 목록 조회
     * - 현황 카드 조회
     * - 점검유형/점검상태/기간/검색어 필터 처리
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/{mgmtOfcNo}")
    public String list(
            @PathVariable String mgmtOfcNo,
            @RequestParam(required = false, defaultValue = "1") int page,
            @RequestParam(required = false, defaultValue = "") String searchWord,
            @RequestParam(required = false, defaultValue = "") String chkTyCd,
            @RequestParam(required = false, defaultValue = "") String chkSttsCd,
            @RequestParam(required = false, defaultValue = "") String chkStartDt,
            @RequestParam(required = false, defaultValue = "") String chkEndDt,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        /* 관리사무소 공통 화면 모델 세팅 */
        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);

        /* 목록 검색 조건 VO 생성 */
        FacilityCheckHstryVO searchVO = new FacilityCheckHstryVO();
        searchVO.setMgmtOfcNo(mgmtOfcNo);
        searchVO.setChkTyCd(chkTyCd);
        searchVO.setChkSttsCd(chkSttsCd);
        searchVO.setChkStartDt(chkStartDt);
        searchVO.setChkEndDt(chkEndDt);

        /* 공통 페이지네이션 VO 생성 */
        PaginationInfoVO<FacilityCheckHstryVO> pagingVO = new PaginationInfoVO<>();
        pagingVO.setSearchWord(searchWord);
        pagingVO.setSearchVO(searchVO);

        /* 전체 건수 조회 */
        int totalRecord = facilityCheckService.selectFacilityCheckCount(pagingVO);
        pagingVO.setTotalRecord(totalRecord);

        /* 현재 페이지 세팅 */
        pagingVO.setCurrentPage(page);

        /* 현재 페이지 목록 조회 */
        List<FacilityCheckHstryVO> dataList = facilityCheckService.selectFacilityCheckList(pagingVO);
        pagingVO.setDataList(dataList);

        /* 화면 표시 모델 세팅 */
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        model.addAttribute("pagingVO", pagingVO);
        model.addAttribute("searchVO", searchVO);
        model.addAttribute("searchWord", searchWord);

        /*
         * 현황 카드 건수
         * - 검색 조건과 무관하게 관리사무소 전체 기준으로 조회
         * - Mapper에서 null이 나와도 JSP에서 터지지 않도록 빈 VO 보정
         */
        FacilityCheckHstryVO summary = facilityCheckService.selectFacilityCheckSummary(mgmtOfcNo);
        model.addAttribute("summary", summary == null ? new FacilityCheckHstryVO() : summary);

        /* 필터용 공통코드 목록 */
        model.addAttribute("checkTypeList", facilityCheckService.selectCheckTypeList());
        model.addAttribute("checkStatusList", facilityCheckService.selectCheckStatusList());

        return "apt/mgmtOffice/facility/check/mngr_facility_check_list";
    }

    /**
     * 시설 점검 이력 상세 화면
     *
     * 화면 역할
     * - 선택한 점검 이력 상세 조회
     * - 같은 시설의 다른 점검 이력 목록 조회
     * - 상세 화면에서는 같은 시설 이력을 간략 목록으로 보여주고, 클릭 시 모달 상세로 확인하는 구조 예정
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/detail/{mgmtOfcNo}/{facChkHstryNo}")
    public String detail(
            @PathVariable String mgmtOfcNo,
            @PathVariable String facChkHstryNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        /* 관리사무소 공통 화면 모델 세팅 */
        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);

        /* 상세 대상 조회 */
        FacilityCheckHstryVO check = facilityCheckService.selectFacilityCheckDetail(mgmtOfcNo, facChkHstryNo);

        /* 상세 대상이 없는 경우 목록으로 복귀 */
        if (check == null) {
            redirectAttributes.addFlashAttribute("message", "조회된 시설 점검 이력이 없습니다.");
            return "redirect:/manager/checkHistory/" + mgmtOfcNo;
        }

        /*
         * 같은 시설 이력 목록 조회
         * - 상세 화면의 간략 이력 목록
         * - 등록/수정 통합폼의 왼쪽 이력 목록과 같은 기준
         */
        List<FacilityCheckHstryVO> sameFacilityCheckList =
                facilityCheckService.selectSameFacilityCheckList(mgmtOfcNo, check.getFacilityNo());

        /* 화면 표시 모델 세팅 */
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        model.addAttribute("check", check);
        model.addAttribute("sameFacilityCheckList", sameFacilityCheckList);

        return "apt/mgmtOffice/facility/check/mngr_facility_check_detail";
    }

    /**
     * 시설 점검 이력 등록 화면
     *
     * 화면 역할
     * - 등록/수정 통합 폼의 등록 모드
     * - facilityNo 파라미터가 없으면 시설 선택 전 등록 화면
     * - facilityNo 파라미터가 있으면 특정 시설의 첫 이력 또는 새 이력 등록 화면
     *
     * 예시
     * - /manager/checkHistory/register/74
     * - /manager/checkHistory/register/74?facilityNo=FAC0051
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/register/{mgmtOfcNo}")
    public String registerPage(
            @PathVariable String mgmtOfcNo,
            @RequestParam(required = false, defaultValue = "") String facilityNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        /* 관리사무소 공통 화면 모델 세팅 */
        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);

        /* 등록 화면 기본 객체 생성 */
        FacilityCheckHstryVO check = new FacilityCheckHstryVO();
        check.setMgmtOfcNo(mgmtOfcNo);

        /*
         * 시설 상세에서 점검 이력 등록으로 진입한 경우
         * - 시설번호를 미리 세팅함
         * - JSP에서 해당 시설 선택 상태와 같은 시설 이력 목록을 표시할 수 있음
         */
        if (facilityNo != null && !facilityNo.isBlank()) {
            check.setFacilityNo(facilityNo);
        }

        /* 등록 화면 공통 모델 세팅 */
        setFormModel(mgmtOfcNo, "register", check, model);

        return "apt/mgmtOffice/facility/check/mngr_facility_check_form";
    }

    /**
     * 시설 점검 이력 등록 처리
     *
     * 처리 기준
     * - facChkHstryNo 없음
     * - FACILITY_CHECK_HSTRY insert
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/register/{mgmtOfcNo}")
    public String register(
            @PathVariable String mgmtOfcNo,
            @ModelAttribute FacilityCheckHstryVO facilityCheckHstryVO,
            RedirectAttributes redirectAttributes
    ) {
        /* 관리사무소 번호 보정 */
        facilityCheckHstryVO.setMgmtOfcNo(mgmtOfcNo);

        /* 시설 점검 이력 등록 */
        String facChkHstryNo = facilityCheckService.insertFacilityCheckHistory(facilityCheckHstryVO);

        /* 완료 메시지 */
        redirectAttributes.addFlashAttribute("message", "시설 점검 이력이 등록되었습니다.");

        return "redirect:/manager/checkHistory/detail/" + mgmtOfcNo + "/" + facChkHstryNo;
    }

    /**
     * 시설 점검 이력 수정 화면
     *
     * 화면 역할
     * - 등록/수정 통합 폼의 수정 모드
     * - 왼쪽에는 같은 시설의 이력 목록
     * - 오른쪽에는 선택한 이력 수정 폼
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/update/{mgmtOfcNo}/{facChkHstryNo}")
    public String updatePage(
            @PathVariable String mgmtOfcNo,
            @PathVariable String facChkHstryNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        /* 관리사무소 공통 화면 모델 세팅 */
        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);

        /* 수정 대상 조회 */
        FacilityCheckHstryVO check = facilityCheckService.selectFacilityCheckDetail(mgmtOfcNo, facChkHstryNo);

        /* 수정 대상이 없는 경우 목록으로 복귀 */
        if (check == null) {
            redirectAttributes.addFlashAttribute("message", "수정할 시설 점검 이력이 없습니다.");
            return "redirect:/manager/checkHistory/" + mgmtOfcNo;
        }

        /* 수정 화면 공통 모델 세팅 */
        setFormModel(mgmtOfcNo, "update", check, model);

        return "apt/mgmtOffice/facility/check/mngr_facility_check_form";
    }

    /**
     * 시설 점검 이력 수정 처리
     *
     * 처리 기준
     * - facChkHstryNo 있음
     * - FACILITY_CHECK_HSTRY update
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/update/{mgmtOfcNo}/{facChkHstryNo}")
    public String update(
            @PathVariable String mgmtOfcNo,
            @PathVariable String facChkHstryNo,
            @ModelAttribute FacilityCheckHstryVO facilityCheckHstryVO,
            RedirectAttributes redirectAttributes
    ) {
        /* 수정 기준값 보정 */
        facilityCheckHstryVO.setMgmtOfcNo(mgmtOfcNo);
        facilityCheckHstryVO.setFacChkHstryNo(facChkHstryNo);

        /* 시설 점검 이력 수정 */
        facilityCheckService.updateFacilityCheckHistory(facilityCheckHstryVO);

        /* 완료 메시지 */
        redirectAttributes.addFlashAttribute("message", "시설 점검 이력이 수정되었습니다.");

        return "redirect:/manager/checkHistory/detail/" + mgmtOfcNo + "/" + facChkHstryNo;
    }

    /**
     * 등록/수정 폼 공통 모델 세팅
     *
     * 모델 구성
     * - formMode                : register / update
     * - check                   : 등록 기본값 또는 수정 대상
     * - facilityList            : 시설 선택 모달 기본 목록
     * - partnerList             : 협력업체 선택 모달 기본 목록
     * - checkTypeList           : 점검유형 공통코드
     * - checkStatusList         : 점검상태 공통코드
     * - assetFacilityTypeList   : 일반 시설자산 유형 목록 (모달 optgroup)
     * - publicFacilityTypeList  : 편의시설 유형 목록 (모달 optgroup)
     * - sameFacilityCheckList   : 선택 시설의 기존 점검 이력 목록
     */
    private void setFormModel(String mgmtOfcNo, String formMode, FacilityCheckHstryVO check, Model model) {
        /* null 방지용 기본 객체 보정 */
        if (check == null) {
            check = new FacilityCheckHstryVO();
        }

        /* 관리사무소 번호 보정 */
        check.setMgmtOfcNo(mgmtOfcNo);

        /* 화면 기본값 */
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        model.addAttribute("formMode", formMode);
        model.addAttribute("check", check);

        /*
         * 선택 모달 기본 목록
         * - 초기 진입 시 모달 안에 기본 목록 표시
         * - 상세 필터는 AJAX API에서 다시 조회
         */
        model.addAttribute("facilityList", facilityCheckService.selectFacilitySelectList(mgmtOfcNo));
        model.addAttribute("partnerList", facilityCheckService.selectPartnerSelectList(mgmtOfcNo));

        /* 공통코드 목록 */
        model.addAttribute("checkTypeList", facilityCheckService.selectCheckTypeList());
        model.addAttribute("checkStatusList", facilityCheckService.selectCheckStatusList());

        /* 시설유형 목록 — 모달 optgroup(일반시설 / 편의시설) 렌더링용 */
        model.addAttribute("assetFacilityTypeList", facilityCheckService.selectAssetFacilityTypeList());
        model.addAttribute("publicFacilityTypeList", facilityCheckService.selectPublicFacilityTypeList());

        /*
         * 같은 시설의 기존 점검 이력 목록
         * - 수정 모드: 수정 대상의 facilityNo 기준 조회
         * - 등록 모드: facilityNo 파라미터가 있으면 해당 시설 기준 조회
         * - facilityNo가 없으면 JSP에서 시설 선택 안내 표시
         */
        if (check.getFacilityNo() != null && !check.getFacilityNo().isBlank()) {
            List<FacilityCheckHstryVO> sameFacilityCheckList =
                    facilityCheckService.selectSameFacilityCheckList(mgmtOfcNo, check.getFacilityNo());

            model.addAttribute("sameFacilityCheckList", sameFacilityCheckList);
        }
    }

    /**
     * 선택한 시설의 기존 점검 이력 목록 AJAX 조회
     *
     * 사용 위치
     * - 등록 화면에서 시설 선택 후 왼쪽 이력 목록 다시 그리기
     * - 수정 통합폼에서 시설 변경 시 이력 목록 갱신
     */
    @ResponseBody
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/history/list/{mgmtOfcNo}/{facilityNo}")
    public Map<String, Object> selectSameFacilityCheckList(
            @PathVariable String mgmtOfcNo,
            @PathVariable String facilityNo
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            /* 선택한 시설번호 기준 기존 점검 이력 조회 */
            List<FacilityCheckHstryVO> historyList =
                    facilityCheckService.selectSameFacilityCheckList(mgmtOfcNo, facilityNo);

            /* JSON 응답 데이터 */
            result.put("success", true);
            result.put("historyList", historyList);
        } catch (Exception e) {
            log.error("시설 점검 이력 목록 AJAX 조회 실패. mgmtOfcNo={}, facilityNo={}", mgmtOfcNo, facilityNo, e);

            result.put("success", false);
            result.put("message", "시설 점검 이력 조회 중 오류가 발생했습니다.");
        }

        return result;
    }

    /**
     * 시설 점검 이력 상세 AJAX 조회
     *
     * 사용 위치
     * - 상세 화면의 간략 이력 목록 클릭 시 모달 상세 표시
     * - 등록/수정 통합폼에서 이력 미리보기 또는 향후 AJAX 폼 전환 시 재사용 가능
     */
    @ResponseBody
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/detail-json/{mgmtOfcNo}/{facChkHstryNo}")
    public Map<String, Object> selectFacilityCheckDetailJson(
            @PathVariable String mgmtOfcNo,
            @PathVariable String facChkHstryNo
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            /* 점검 이력 단건 상세 조회 */
            FacilityCheckHstryVO check =
                    facilityCheckService.selectFacilityCheckDetail(mgmtOfcNo, facChkHstryNo);

            /* 조회 결과 응답 */
            result.put("success", check != null);
            result.put("check", check);

            if (check == null) {
                result.put("message", "조회된 시설 점검 이력이 없습니다.");
            }
        } catch (Exception e) {
            log.error("시설 점검 이력 상세 AJAX 조회 실패. mgmtOfcNo={}, facChkHstryNo={}", mgmtOfcNo, facChkHstryNo, e);

            result.put("success", false);
            result.put("message", "시설 점검 이력 상세 조회 중 오류가 발생했습니다.");
        }

        return result;
    }

    /**
     * 시설 선택 모달 서버 검색
     *
     * 검색 조건
     * - 시설유형
     * - 동
     * - 사용여부
     * - 위치
     * - 시설명/시설번호 통합검색
     */
    @ResponseBody
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/facility/search/{mgmtOfcNo}")
    public Map<String, Object> selectFacilitySearchList(
            @PathVariable String mgmtOfcNo,
            @RequestParam(required = false, defaultValue = "") String facilityTyCd,
            @RequestParam(required = false, defaultValue = "") String dongNo,
            @RequestParam(required = false, defaultValue = "") String facilityUseYn,
            @RequestParam(required = false, defaultValue = "") String facilityLocCn,
            @RequestParam(required = false, defaultValue = "") String facilitySearchWord
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            /* 시설 선택 모달 검색 조건 VO */
            FacilityCheckHstryVO searchVO = new FacilityCheckHstryVO();
            searchVO.setMgmtOfcNo(mgmtOfcNo);
            searchVO.setFacilityTyCd(facilityTyCd);
            searchVO.setDongNo(dongNo);
            searchVO.setFacilityUseYn(facilityUseYn);
            searchVO.setFacilityLocCn(facilityLocCn);
            searchVO.setFacilitySearchWord(facilitySearchWord);

            /* 조건 기준 시설 목록 조회 */
            List<FacilityCheckHstryVO> facilityList =
                    facilityCheckService.selectFacilitySearchList(searchVO);

            /* JSON 응답 데이터 */
            result.put("success", true);
            result.put("facilityList", facilityList);
        } catch (Exception e) {
            log.error("시설 선택 모달 검색 실패. mgmtOfcNo={}", mgmtOfcNo, e);

            result.put("success", false);
            result.put("message", "시설 목록 조회 중 오류가 발생했습니다.");
        }

        return result;
    }

    /**
     * 협력업체 선택 모달 서버 검색
     *
     * 검색 조건
     * - 업종
     * - 사용여부
     * - 담당자명
     * - 업체명/업체번호/사업자번호 통합검색
     *
     * 주의
     * - 이 메서드는 다음 단계에서 Service, ServiceImpl, Mapper, XML에도 동일하게 추가해야 함
     */
    @ResponseBody
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/partner/search/{mgmtOfcNo}")
    public Map<String, Object> selectPartnerSearchList(
            @PathVariable String mgmtOfcNo,
            @RequestParam(required = false, defaultValue = "") String bizTyNm,
            @RequestParam(required = false, defaultValue = "") String partnerUseYn,
            @RequestParam(required = false, defaultValue = "") String picNm,
            @RequestParam(required = false, defaultValue = "") String partnerSearchWord
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            /* 협력업체 선택 모달 검색 조건 VO */
            FacilityCheckHstryVO searchVO = new FacilityCheckHstryVO();
            searchVO.setMgmtOfcNo(mgmtOfcNo);
            searchVO.setBizTyNm(bizTyNm);
            searchVO.setPartnerUseYn(partnerUseYn);
            searchVO.setPicNm(picNm);
            searchVO.setPartnerSearchWord(partnerSearchWord);

            /* 조건 기준 협력업체 목록 조회 */
            List<FacilityCheckHstryVO> partnerList =
                    facilityCheckService.selectPartnerSearchList(searchVO);

            /* JSON 응답 데이터 */
            result.put("success", true);
            result.put("partnerList", partnerList);
        } catch (Exception e) {
            log.error("협력업체 선택 모달 검색 실패. mgmtOfcNo={}", mgmtOfcNo, e);

            result.put("success", false);
            result.put("message", "협력업체 목록 조회 중 오류가 발생했습니다.");
        }

        return result;
    }
}