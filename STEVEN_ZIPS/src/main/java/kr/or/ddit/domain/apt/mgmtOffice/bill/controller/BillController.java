package kr.or.ddit.domain.apt.mgmtOffice.bill.controller;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.main.service.IAptComplexService;
import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import kr.or.ddit.domain.apt.mgmtOffice.bill.service.IBillChargeService;
import kr.or.ddit.domain.apt.mgmtOffice.bill.service.IBillIssueService;
import kr.or.ddit.domain.apt.mgmtOffice.bill.service.IMeterChargeService;
import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.BillVO;
import kr.or.ddit.domain.apt.mgmtOffice.common.service.IManagerModelService;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/manager")
@PreAuthorize("hasRole('MNGR')")  // 계층 구조상 ADMIN도 통과
@RequiredArgsConstructor
public class BillController {

    // ADMIN/MNGR 접근 기준 및 화면 공통 모델 처리
    @Autowired
    private IManagerModelService managerAccessService;

    @Autowired
    private IAptComplexService aptComplexService;

    @Autowired
    private IBillChargeService billChargeService;

    @Autowired
    private IBillIssueService billIssueService;

    @Autowired
    private IMeterChargeService meterChargeService;

    /**
     * @Author 이윤진
     * @param mgmtOfcNo 관리사무소번호
     * @param customUser
     * @param model
     * @return 관리비부과 화면
     */

    // 관리비 부과
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/bill/charge/{mgmtOfcNo}")
    public String billCharge(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);
        return "apt/mgmtOffice/bill/mngr_billCharge";
    }

    /**
     * 관리비 부과 미리보기
     *
     * 요청 예시:
     * GET /manager/bill/charge/preview/4?billYm=202605
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/bill/charge/preview/{mgmtOfcNo}")
    public ResponseEntity<Map<String, Object>> previewBillCharge(
            @PathVariable String mgmtOfcNo,
            @RequestParam String billYm,
            @AuthenticationPrincipal CustomUser customUser
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            AptComplexVO aptComplexVO = aptComplexService.selectMgmtOfcNoAptComplex(mgmtOfcNo);

            if (aptComplexVO == null) {
                result.put("success", false);
                result.put("message", "관리사무소에 연결된 아파트 단지 정보가 없습니다.");
                return ResponseEntity.ok(result);
            }

            Map<String, Object> preview =
                    billChargeService.previewBillCharge(aptComplexVO.getAptCmplexNo(), billYm);

            result.put("success", true);
            result.putAll(preview);

        } catch (Exception e) {
            log.error("관리비 부과 미리보기 실패", e);
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return ResponseEntity.ok(result);
    }

    /**
     * 관리비 부과 실행
     *
     * 요청 예시:
     * POST /manager/bill/charge/execute/4
     *
     * 요청 JSON:
     * {
     *   "billYm": "202605",
     *   "dueDt": "2026-06-10"
     * }
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @PostMapping("/bill/charge/execute/{mgmtOfcNo}")
    public ResponseEntity<Map<String, Object>> executeBillCharge(
            @PathVariable String mgmtOfcNo,
            @RequestBody Map<String, String> body,
            @AuthenticationPrincipal CustomUser customUser
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            String billYm = body.get("billYm");
            String dueDt = body.get("dueDt");

            AptComplexVO aptComplexVO = aptComplexService.selectMgmtOfcNoAptComplex(mgmtOfcNo);

            if (aptComplexVO == null) {
                result.put("success", false);
                result.put("message", "관리사무소에 연결된 아파트 단지 정보가 없습니다.");
                return ResponseEntity.ok(result);
            }

            Map<String, Object> chargeResult =
                    billChargeService.executeBillCharge(aptComplexVO.getAptCmplexNo(), billYm, dueDt);

            result.put("success", true);
            result.put("message", "관리비 부과가 완료되었습니다.");
            result.putAll(chargeResult);

        } catch (Exception e) {
            log.error("관리비 부과 실패", e);
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return ResponseEntity.ok(result);
    }

    /**
     * 검침요금 계산 화면
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/bill/meter-charge/{mgmtOfcNo}")
    public String meterChargePage(
            @PathVariable String mgmtOfcNo,
            Model model,
            Authentication authentication
    ) {
        CustomUser customUser = (CustomUser) authentication.getPrincipal();

        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);

        return "apt/mgmtOffice/bill/mngr_meterCharge";
    }

    /**
     * 검침요금 계산 목록 조회
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/bill/meter-charge/list/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> selectMeterChargeList(
            @PathVariable String mgmtOfcNo,
            @RequestParam String billYm
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            AptComplexVO aptComplexVO = aptComplexService.selectMgmtOfcNoAptComplex(mgmtOfcNo);

            if (aptComplexVO == null) {
                result.put("success", false);
                result.put("message", "관리사무소에 연결된 아파트 단지 정보가 없습니다.");
                return ResponseEntity.ok(result);
            }

            Map<String, Object> data = meterChargeService.selectMeterChargeList(
                    aptComplexVO.getAptCmplexNo(),
                    billYm
            );

            result.put("success", true);
            result.putAll(data);
            result.put("aptCmplexNo", aptComplexVO.getAptCmplexNo());
            result.put("billYm", billYm);

        } catch (Exception e) {
            log.error("검침요금 계산 조회 실패", e);
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return ResponseEntity.ok(result);
    }

    // 고지서 등록
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

    // 고지서 동 목록 조회
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/bill/issue/dong-list/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> selectBillDongList(
            @PathVariable String mgmtOfcNo
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            AptComplexVO aptComplexVO = aptComplexService.selectMgmtOfcNoAptComplex(mgmtOfcNo);

            if (aptComplexVO == null) {
                result.put("success", false);
                result.put("message", "관리사무소에 연결된 아파트 단지 정보가 없습니다.");
                return ResponseEntity.ok(result);
            }

            List<BillVO> dongList =
                    billIssueService.selectBillDongList(aptComplexVO.getAptCmplexNo());

            result.put("success", true);
            result.put("dongList", dongList);

        } catch (Exception e) {
            log.error("고지서 동 목록 조회 실패", e);
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return ResponseEntity.ok(result);
    }

    // 고지서 목록 조회
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/bill/issue/list/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> selectBillIssueList(
            @PathVariable String mgmtOfcNo,
            @RequestParam(required = false) String billYm,
            @RequestParam(required = false) String pymtSttsCd,
            @RequestParam(required = false) String dongNo,
            @RequestParam(required = false) String ho,
            @RequestParam(defaultValue = "1") int currentPage
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            AptComplexVO aptComplexVO = aptComplexService.selectMgmtOfcNoAptComplex(mgmtOfcNo);

            if (aptComplexVO == null) {
                result.put("success", false);
                result.put("message", "관리사무소에 연결된 아파트 단지 정보가 없습니다.");
                return ResponseEntity.ok(result);
            }

            BillVO searchVO = new BillVO();
            searchVO.setAptCmplexNo(aptComplexVO.getAptCmplexNo());
            searchVO.setBillYm(billYm);
            searchVO.setPymtSttsCd(pymtSttsCd);
            searchVO.setDongNo(dongNo);
            searchVO.setHo(ho);

            PaginationInfoVO<BillVO> pagingVO = new PaginationInfoVO<>(10, 5);
            pagingVO.setSearchVO(searchVO);
            pagingVO.setCurrentPage(currentPage);

            pagingVO = billIssueService.selectBillIssueList(pagingVO);


            long pageTotalAmount = 0L;
            if (pagingVO.getDataList() != null) {
                for (BillVO billVO : pagingVO.getDataList()) {
                    if (billVO.getBillTotAmt() != null) {
                        pageTotalAmount += billVO.getBillTotAmt();
                    }
                }
            }

            result.put("success", true);
            result.put("list", pagingVO.getDataList());
            result.put("totalCount", pagingVO.getTotalRecord());
            result.put("totalPage", pagingVO.getTotalPage());
            result.put("currentPage", pagingVO.getCurrentPage());
            result.put("startPage", pagingVO.getStartPage());
            result.put("endPage", pagingVO.getEndPage());
            result.put("screenSize", pagingVO.getScreenSize());
            result.put("pagingHTML", pagingVO.getPagingHTML());
            result.put("pageTotalAmount", pageTotalAmount);

        } catch (Exception e) {
            log.error("고지서 목록 조회 실패", e);
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return ResponseEntity.ok(result);
    }

    // 고지서 상세 조회
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/bill/issue/detail/{mgmtOfcNo}/{billNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> selectBillIssueDetail(
            @PathVariable String mgmtOfcNo,
            @PathVariable String billNo
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            AptComplexVO aptComplexVO = aptComplexService.selectMgmtOfcNoAptComplex(mgmtOfcNo);

            if (aptComplexVO == null) {
                result.put("success", false);
                result.put("message", "관리사무소에 연결된 아파트 단지 정보가 없습니다.");
                return ResponseEntity.ok(result);
            }

            BillVO billVO = billIssueService.selectBillIssueDetail(
                    aptComplexVO.getAptCmplexNo(),
                    billNo
            );

            result.put("success", true);
            result.put("bill", billVO);

        } catch (Exception e) {
            log.error("고지서 상세 조회 실패", e);
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return ResponseEntity.ok(result);
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
}
