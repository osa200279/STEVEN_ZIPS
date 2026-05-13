package kr.or.ddit.domain.apt.mgmtOffice.main.controller;

import kr.or.ddit.domain.apt.main.service.IAptComplexService;
import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import kr.or.ddit.domain.apt.mgmtOffice.main.mapper.IMgmtOfficeMapper;
import kr.or.ddit.domain.apt.mgmtOffice.main.vo.MgmtOfficeVO;
import kr.or.ddit.domain.apt.mgmtOffice.main.vo.ManagerPaginationVO;
import kr.or.ddit.domain.apt.mgmtOffice.common.service.IManagerModelService;
import kr.or.ddit.domain.apt.mgmtOffice.facility.service.IFacilityService;
import kr.or.ddit.domain.member.manager.vo.MngrVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/manager")
@PreAuthorize("hasRole('MNGR')")  // 계층 구조상 ADMIN도 통과
@RequiredArgsConstructor
public class ManagerMainController {

    // 관리사무소 목록 조회용 Mapper
    private final IMgmtOfficeMapper mgmtOfficeMapper;

    // ADMIN/MNGR 접근 기준 및 화면 공통 모델 처리
    private final IManagerModelService managerAccessService;
    private final IFacilityService facilityService;

    @Autowired
    private IAptComplexService aptComplexService;

    // ──/manager/main 진입─────────────────────────────────────
    // ADMIN은 관리사무소 선택 모달 표시
    // MNGR은 본인 관리사무소 번호가 붙은 대시보드로 이동
    @GetMapping("/main")
    public String managerMain(
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        boolean admin = managerAccessService.isAdmin(customUser);

        if (admin) {
            managerAccessService.addManagerViewModel(model, customUser, null);
            return "apt/mgmtOffice/office";
        }

        MemberVO member = customUser.getMember();

        if (member instanceof MngrVO) {
            MngrVO loginMngr = (MngrVO) member;
            return "redirect:/manager/main/" + loginMngr.getMgmtOfcNo();
        }

        return "apt/mgmtOffice/office";
    }

    // 관리사무소 번호 기준 대시보드
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/main/{mgmtOfcNo}")
    public String managerDashboard(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);
        return "apt/mgmtOffice/office";
    }

    // ── ADMIN 전용 API ────────────────────────────────────────

    // ADMIN 관리사무소 선택 모달 목록 조회
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/admin-mgmt-ofc/list")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getAdminMgmtOfcList(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(required = false) String searchWord,
            @RequestParam(required = false) String sidoNm,
            @RequestParam(required = false) String sigunguNm
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            // 모달 페이징 기준 생성
            ManagerPaginationVO<MgmtOfficeVO> pagingVO = new ManagerPaginationVO<>(8, 5);

            // 현재 페이지 기준 row 계산
            pagingVO.setCurrentPage(page);

            // 검색/지역 필터 조건 세팅
            pagingVO.setSearchWord(searchWord);
            pagingVO.setSidoNm(sidoNm);
            pagingVO.setSigunguNm(sigunguNm);

            // 전체 건수 조회
            int totalRecord = mgmtOfficeMapper.selectAdminMgmtOfficeCount(pagingVO);
            pagingVO.setTotalRecord(totalRecord);

            // 현재 페이지 목록 조회
            List<MgmtOfficeVO> list = mgmtOfficeMapper.selectAdminMgmtOfficeList(pagingVO);
            pagingVO.setDataList(list);

            // 모달 목록/페이징 응답
            result.put("list", pagingVO.getDataList());
            result.put("pagingHTML", pagingVO.getPagingHTML());
            result.put("currentPage", pagingVO.getCurrentPage());
            result.put("totalPage", pagingVO.getTotalPage());
            result.put("totalRecord", pagingVO.getTotalRecord());

        } catch (Exception e) {
            // 조회 실패 시 빈 목록 반환
            result.put("list", new ArrayList<>());
            result.put("pagingHTML", "");
            result.put("message", e.getMessage());
        }

        return ResponseEntity.ok(result);
    }

    // 관리사무소 선택 완료
    // 세션 저장 없이 선택한 관리사무소 번호만 반환
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/admin-mgmt-ofc/select")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> selectAdminMgmtOfc(
            @RequestBody Map<String, String> body
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            String mgmtOfcNo = body.get("mgmtOfcNo");

            if (mgmtOfcNo == null || mgmtOfcNo.isBlank()) {
                result.put("success", false);
                result.put("message", "관리사무소를 선택해 주세요.");
                return ResponseEntity.ok(result);
            }

            result.put("success", true);
            result.put("mgmtOfcNo", mgmtOfcNo);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return ResponseEntity.ok(result);
    }
        //시도 목록 조회 API
        @PreAuthorize("hasRole('ADMIN')")
        @GetMapping("/admin-mgmt-ofc/sido/list")
        @ResponseBody
        public List<String> getAdminMgmtOfcSidoList() {
            return mgmtOfficeMapper.selectAdminMgmtOfficeSidoList();
        }
        //시군구 목록 조회 API
        @PreAuthorize("hasRole('ADMIN')")
        @GetMapping("/admin-mgmt-ofc/sigungu/list")
        @ResponseBody
        public List<String> getAdminMgmtOfcSigunguList(
                @RequestParam String sidoNm
        ) {
            return mgmtOfficeMapper.selectAdminMgmtOfficeSigunguList(sidoNm);
        }


    // ── 화면 이동 매핑 ────────────────────────────────────────
    // 대시보드를 제외한 관리사무소 화면은 모두 mgmtOfcNo를 주소에 포함

    // 직원 계정 관리
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/employee/account/{mgmtOfcNo}")
    public String employeeAccount(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        // JSP 표시용 기본값 세팅
        // - 관리자 여부, 관리사무소 번호, 로그인 사용자명
        // - 관리사무소명, 단지명
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);
        return "apt/mgmtOffice/employee/mngr_account";
    }

    // 휴가 일정
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/vacation/{mgmtOfcNo}")
    public String vacation(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);
        return "apt/mgmtOffice/employee/vacation";
    }

    // 입주민 목록
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/resident/list/{mgmtOfcNo}")
    public String residentList(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        //////////////


        /////////////////
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);
        return "apt/mgmtOffice/mngr_resident_list";
    }

    // 입주민 승인
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/resident/auth/{mgmtOfcNo}")
    public String residentAuth(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);
        return "apt/mgmtOffice/mngr_resident_auth";
    }

    // 전출입 관리
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/resident/moveList/{mgmtOfcNo}")
    public String moveList(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);
        return "apt/mgmtOffice/mngr_resident_moveList";
    }

    // 입주민 자동 처리
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/resident/auto/{mgmtOfcNo}")
    public String residentAuto(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);
        return "redirect:/manager/resident/auto/list/" + mgmtOfcNo;
    }

    // 방문 차량 자동 처리
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/visit/auto/{mgmtOfcNo}")
    public String visitAuto(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);
        return "apt/mgmtOffice/mngr_visit_auto";
    }

//    // 시설 목록
//    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
//    @GetMapping("facility/facilityList/{mgmtOfcNo}")
//    public String facilityList(
//            @PathVariable String mgmtOfcNo,
//            @AuthenticationPrincipal CustomUser customUser,
//            Model model
//    ) {
//        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);
//        model.addAttribute("dongList", facilityService.selectDongList(mgmtOfcNo));
//        return "apt/mgmtOffice/facility/mngr_facility_list";
//    }

    // 공용 시설
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/publicFacilityList/{mgmtOfcNo}")
    public String publicFacilityList(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);
        return "apt/mgmtOffice/mngr_public_facility";
    }

    // 검침 기록
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/meterReading/{mgmtOfcNo}")
    public String meterReading(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);
        return "apt/mgmtOffice/mngr_meterReading";
    }

    // 시설 점검 이력
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/checkHistory/{mgmtOfcNo}")
    public String checkHistory(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);
        return "apt/mgmtOffice/mngr_facility_history";
    }

    // 작업 일정
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/facility/workCalendar/{mgmtOfcNo}")
    public String workCalendar(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);
        return "apt/mgmtOffice/mngr_facility_workCalendar";
    }

    // 협력업체
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/facility/partnerList/{mgmtOfcNo}")
    public String partnerList(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);
        return "apt/mgmtOffice/mngr_partner_list";
    }

    // 관리비 부과
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/bill/charge/{mgmtOfcNo}")
    public String billCharge(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);
        return "apt/mgmtOffice/mngr_billCharge";
    }

    // 고지서 발행
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/bill/issue/{mgmtOfcNo}")
    public String billIssue(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);
        return "apt/mgmtOffice/mngr_billIssue";
    }

    // 관리비 항목 요약
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/bill/item-summary/{mgmtOfcNo}")
    public String billItemSummary(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);
        return "apt/mgmtOffice/mngr_billItemSummary";
    }

    // 연체 관리
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/account/arrears/{mgmtOfcNo}")
    public String accountArrears(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);
        return "apt/mgmtOffice/mngr_accountArrears";
    }


    // 단지 정보 수정페이지
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping({"/complex/buildingLayOut/{mgmtOfcNo}"})
    public String complexEdit(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {

        // mgmtOfcNo 로 아파트 정보 가져오는 메서드
        AptComplexVO aptComplexVO = aptComplexService.selectMgmtOfcNoAptComplex(mgmtOfcNo);

        model.addAttribute("complex",aptComplexVO);
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);

        return "apt/mgmtOffice/mngr_building_layout_edit";
    }

    // 단지 정보 수정페이지
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping({"/complex/edit/{mgmtOfcNo}"})
    public String complexEditt(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {

        // mgmtOfcNo 로 아파트 정보 가져오는 메서드
        AptComplexVO aptComplexVO = aptComplexService.selectMgmtOfcNoAptComplex(mgmtOfcNo);

        model.addAttribute("complex",aptComplexVO);
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);
        System.out.println("mgmtOfcNo = " + mgmtOfcNo);
        System.out.println("aptComplexVO = " + aptComplexVO);


        return "apt/mgmtOffice/mngr_complex_edit";
    }

}
