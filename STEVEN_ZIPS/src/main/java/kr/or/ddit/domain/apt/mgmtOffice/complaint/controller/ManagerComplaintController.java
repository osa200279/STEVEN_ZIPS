package kr.or.ddit.domain.apt.mgmtOffice.complaint.controller;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.main.service.IAptComplexService;
import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import kr.or.ddit.domain.apt.mgmtOffice.complaint.dto.ManagerComplaintDTO;
import kr.or.ddit.domain.apt.mgmtOffice.complaint.service.ManagerComplaintService;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/manager/complex")
@Slf4j
@RequiredArgsConstructor
public class ManagerComplaintController {

    private final IAptComplexService aptComplexService;

    private final ManagerComplaintService managerComplaintService;

    /**
     * 관리사무소 민원 접수 현황 민원 목록
     * 검색 필터링 및 페이징 처리
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/complaintList/{mgmtOfcNo}")
    public ResponseEntity<Map<String, Object>> selectComplaintList(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser principal,
            @RequestParam(defaultValue = "1") int curPage,
            @RequestParam(required = false) String cvplTyCd,
            @RequestParam(required = false) String cvplSttsCd,
            @RequestParam(required = false, defaultValue = "") String keyword
            ) {

        Map<String, Object> result = new HashMap<>();

        // 단지번호 조회
        AptComplexVO aptComplexVO = aptComplexService.selectMgmtOfcNoAptComplex(mgmtOfcNo);
        String aptCmplexNo = aptComplexVO.getAptCmplexNo();

        // 페이징 + 검색조건 세팅
        PaginationInfoVO<ManagerComplaintDTO> page = new PaginationInfoVO<>(10, 5);

        ManagerComplaintDTO searchDTO = new ManagerComplaintDTO();
        searchDTO.setAptCmplexNo(aptCmplexNo);
        searchDTO.setCvplTyCd(cvplTyCd);
        searchDTO.setCvplSttsCd(cvplSttsCd);
        page.setSearchVO(searchDTO);
        page.setSearchWord(keyword);
        page.setCurrentPage(curPage);

        // 건수 조회
        int totalRecord = managerComplaintService.selectComplaintCount(page);
        page.setTotalRecord(totalRecord);
        page.setCurrentPage(curPage);

        // 목록 조회
        List<ManagerComplaintDTO> list = managerComplaintService.selectComplaintList(page);
        page.setDataList(list);

        result.put("list", list);
        result.put("page", page);

        return ResponseEntity.ok(result);
    }

}



