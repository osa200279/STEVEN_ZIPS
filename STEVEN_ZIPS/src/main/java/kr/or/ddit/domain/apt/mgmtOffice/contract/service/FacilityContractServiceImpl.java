package kr.or.ddit.domain.apt.mgmtOffice.contract.service;

import kr.or.ddit.domain.apt.mgmtOffice.contract.mapper.IFacilityContractMapper;
import kr.or.ddit.domain.apt.mgmtOffice.contract.vo.FacilityContractVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.HashMap;
import java.util.Map;

/**
 * 시설 계약 Service 구현체
 * - 계약 화면 조회
 * - 계약 등록/수정
 * - 재계약 등록
 * - 검침 설정 저장
 */
@Service
@RequiredArgsConstructor
public class FacilityContractServiceImpl implements IFacilityContractService {

    /** 시설 계약 Mapper */
    private final IFacilityContractMapper contractMapper;

    /**
     * 계약 화면 데이터 조회
     */
    @Override
    public Map<String, Object> selectContractPageData(String mgmtOfcNo, Map<String, Object> searchMap) {
        // 단지번호 조회
        String aptCmplexNo = contractMapper.selectAptCmplexNoByMgmtOfcNo(mgmtOfcNo);

        // 조회 조건 구성
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.putAll(searchMap);
        paramMap.put("mgmtOfcNo", mgmtOfcNo);
        paramMap.put("aptCmplexNo", aptCmplexNo);

        // 화면 데이터 구성
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("search", paramMap);
        resultMap.put("stats", contractMapper.selectContractStats(paramMap));
        resultMap.put("contractList", contractMapper.selectContractList(paramMap));
        resultMap.put("expiringList", contractMapper.selectExpiringContractList(paramMap));
        resultMap.put("facilityList", contractMapper.selectFacilitySelectList(aptCmplexNo));
        resultMap.put("partnerList", contractMapper.selectPartnerSelectList(aptCmplexNo));
        resultMap.put("bidTypeList", contractMapper.selectBidTypeCodeList());
        resultMap.put("statusList", contractMapper.selectContractStatusCodeList());

        return resultMap;
    }

    /**
     * 계약 등록
     */
    @Override
    @Transactional
    public int insertContract(String mgmtOfcNo, FacilityContractVO contractVO) {
        // 기본값 검증
        validateContract(contractVO);

        // 계약 등록
        return contractMapper.insertContract(contractVO);
    }

    /**
     * 계약 수정
     */
    @Override
    @Transactional
    public int updateContract(String mgmtOfcNo, FacilityContractVO contractVO) {
        // 계약번호 검증
        if (!StringUtils.hasText(contractVO.getContNo())) {
            throw new IllegalArgumentException("계약번호가 없습니다.");
        }

        // 기본값 검증
        validateContract(contractVO);

        // 계약 수정
        return contractMapper.updateContract(contractVO);
    }

    /**
     * 재계약 등록
     */
    @Override
    @Transactional
    public int insertRenewContract(String mgmtOfcNo, FacilityContractVO contractVO) {
        // 기존 계약을 수정하지 않고 새 계약으로 등록
        validateContract(contractVO);
        return contractMapper.insertContract(contractVO);
    }

    /**
     * 검침 설정 저장
     */
    @Override
    @Transactional
    public int saveUtilityProvider(String mgmtOfcNo, FacilityContractVO contractVO) {
        // 단지번호 조회
        String aptCmplexNo = contractMapper.selectAptCmplexNoByMgmtOfcNo(mgmtOfcNo);
        contractVO.setAptCmplexNo(aptCmplexNo);

        // 기본값 검증
        if (!StringUtils.hasText(contractVO.getContNo())) {
            throw new IllegalArgumentException("계약번호가 없습니다.");
        }
        if (!StringUtils.hasText(contractVO.getPartnerNo())) {
            throw new IllegalArgumentException("협력업체번호가 없습니다.");
        }
        if (!StringUtils.hasText(contractVO.getCsvIdntfKey())) {
            throw new IllegalArgumentException("CSV 식별키를 입력해주세요.");
        }
        if (!StringUtils.hasText(contractVO.getExtCustNo())) {
            throw new IllegalArgumentException("외부 고객번호를 입력해주세요.");
        }

        // 기존 설정 수정 또는 신규 설정 등록
        if (StringUtils.hasText(contractVO.getUtilityProviderNo())) {
            return contractMapper.updateUtilityProvider(contractVO);
        }

        return contractMapper.insertUtilityProvider(contractVO);
    }

    /**
     * 계약 기본값 검증
     */
    private void validateContract(FacilityContractVO contractVO) {
        // 시설번호 검증
        if (!StringUtils.hasText(contractVO.getFacilityNo())) {
            throw new IllegalArgumentException("시설을 선택해주세요.");
        }

        // 협력업체번호 검증
        if (!StringUtils.hasText(contractVO.getPartnerNo())) {
            throw new IllegalArgumentException("협력업체를 선택해주세요.");
        }

        // 계약명 검증
        if (!StringUtils.hasText(contractVO.getContNm())) {
            throw new IllegalArgumentException("계약명을 입력해주세요.");
        }

        // 입찰유형 검증
        if (!StringUtils.hasText(contractVO.getBidTyCd())) {
            throw new IllegalArgumentException("입찰유형을 선택해주세요.");
        }
    }
}
