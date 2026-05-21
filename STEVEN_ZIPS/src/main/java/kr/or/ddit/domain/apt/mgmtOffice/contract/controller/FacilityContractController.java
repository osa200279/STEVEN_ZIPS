package kr.or.ddit.domain.apt.mgmtOffice.contract.controller;

import kr.or.ddit.domain.apt.mgmtOffice.common.service.IManagerModelService;
import kr.or.ddit.domain.apt.mgmtOffice.contract.service.IFacilityContractService;
import kr.or.ddit.domain.apt.mgmtOffice.contract.vo.FacilityContractDTO;
import kr.or.ddit.domain.apt.mgmtOffice.contract.vo.FacilityContractSearchVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 시설 계약 관리 Controller
 *
 * 기준
 * - EmployeeController 패턴을 따른다.
 * - 클래스 권한: ROLE_MNGR
 * - 조회 권한: authService.hasAccess
 * - 등록/수정 권한: authService.canMgmtCrud
 * - 화면 반환 메서드: IManagerModelService.addManagerViewModel(...) 호출
 */
@Slf4j
@Controller
@PreAuthorize("hasRole('MNGR')")
@RequestMapping("/manager/facility/contract")
public class FacilityContractController {

    @Autowired
    private IFacilityContractService facilityContractService;

    @Autowired
    private IManagerModelService managerModelService;

    /**
     * 계약 목록 화면
     *
     * JSP
     * - /WEB-INF/views/apt/mgmtOffice/contract/mngr_contract_list.jsp
     *
     * 필요한 model
     * - mgmtOfcNo
     * - search
     * - contractList
     * - contractSummary
     * - manager 공통 model 값
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/list/{mgmtOfcNo}")
    public String contractList(
            @PathVariable String mgmtOfcNo,
            @ModelAttribute("search") FacilityContractSearchVO search,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        // 관리사무소 화면 공통 model 값 세팅
        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);

        // 검색 조건에 관리사무소 번호 세팅
        search.setMgmtOfcNo(mgmtOfcNo);

        // 계약 목록, 현황 카드 조회
        model.addAttribute("contractList", facilityContractService.selectContractList(search));
        model.addAttribute("contractSummary", facilityContractService.selectContractSummary(search));
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);

        return "apt/mgmtOffice/contract/mngr_contract_list";
    }

    /**
     * 계약 등록 폼 화면
     *
     * JSP
     * - /WEB-INF/views/apt/mgmtOffice/contract/mngr_contract_form.jsp
     *
     * 필요한 model
     * - mode = insert
     * - contract
     * - partnerList
     * - facilityList
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @GetMapping("/form/{mgmtOfcNo}")
    public String contractInsertForm(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        // 관리사무소 화면 공통 model 값 세팅
        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);

        // 등록 화면 기본값
        FacilityContractDTO contract = new FacilityContractDTO();
        contract.setContTargetCd("FACILITY");

        // DB 아카이브에 확정되지 않은 코드값은 화면에서 선택하게 두고 기본값만 최소화
        contract.setContSttsCd("ING");

        // 폼 공통 model
        model.addAttribute("mode", "insert");
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        model.addAttribute("contract", contract);
        model.addAttribute("partnerList", facilityContractService.selectContractPartnerList(mgmtOfcNo));
        model.addAttribute("facilityList", facilityContractService.selectContractFacilityList(mgmtOfcNo));

        return "apt/mgmtOffice/contract/mngr_contract_form";
    }

    /**
     * 계약 수정 폼 화면
     *
     * JSP
     * - /WEB-INF/views/apt/mgmtOffice/contract/mngr_contract_form.jsp
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @GetMapping("/form/{mgmtOfcNo}/{contNo}")
    public String contractUpdateForm(
            @PathVariable String mgmtOfcNo,
            @PathVariable String contNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        // 관리사무소 화면 공통 model 값 세팅
        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);

        // 계약 상세 조회
        FacilityContractDTO contract = facilityContractService.selectContractDetail(mgmtOfcNo, contNo);

        // 폼 공통 model
        model.addAttribute("mode", "update");
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        model.addAttribute("contract", contract);
        model.addAttribute("partnerList", facilityContractService.selectContractPartnerList(mgmtOfcNo));
        model.addAttribute("facilityList", facilityContractService.selectContractFacilityList(mgmtOfcNo));

        return "apt/mgmtOffice/contract/mngr_contract_form";
    }

    /**
     * 계약 상세 조회
     *
     * 사용처
     * - 목록 JSP 상세 모달
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/detail/{mgmtOfcNo}/{contNo}")
    @ResponseBody
    public Map<String, Object> contractDetail(
            @PathVariable String mgmtOfcNo,
            @PathVariable String contNo
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            // 계약 상세 조회
            FacilityContractDTO contract = facilityContractService.selectContractDetail(mgmtOfcNo, contNo);

            result.put("success", true);
            result.put("contract", contract);
        } catch (Exception e) {
            log.error("계약 상세 조회 오류", e);
            result.put("success", false);
            result.put("message", "계약 상세 조회 중 오류가 발생했습니다.");
        }

        return result;
    }

    /**
     * 계약 등록 처리
     *
     * form enctype
     * - multipart/form-data
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/insert/{mgmtOfcNo}")
    public String contractInsert(
            @PathVariable String mgmtOfcNo,
            @ModelAttribute FacilityContractDTO contract,
            @RequestParam(value = "contractFiles", required = false) List<MultipartFile> contractFiles
    ) {
        // 관리사무소 번호 세팅
        contract.setMgmtOfcNo(mgmtOfcNo);

        // 계약 등록
        facilityContractService.insertContract(contract, contractFiles);

        return "redirect:/manager/facility/contract/list/" + mgmtOfcNo;
    }

    /**
     * 계약 수정 처리
     *
     * 주의
     * - ATTACH_FILE에는 FILE_NO가 없고 FILE_SAVE_UUID가 식별값이다.
     * - JSP 삭제 체크박스 name도 deleteFileSaveUuidList로 맞추는 것을 권장한다.
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/update/{mgmtOfcNo}")
    public String contractUpdate(
            @PathVariable String mgmtOfcNo,
            @ModelAttribute FacilityContractDTO contract,
            @RequestParam(value = "contractFiles", required = false) List<MultipartFile> contractFiles,
            @RequestParam(value = "deleteFileSaveUuidList", required = false) List<String> deleteFileSaveUuidList
    ) {
        // 관리사무소 번호 세팅
        contract.setMgmtOfcNo(mgmtOfcNo);

        // 계약 수정
        facilityContractService.updateContract(contract, contractFiles, deleteFileSaveUuidList);

        return "redirect:/manager/facility/contract/list/" + mgmtOfcNo;
    }
}
