package kr.or.ddit.domain.apt.mgmtOffice.meter.service;

import kr.or.ddit.domain.apt.mgmtOffice.meter.vo.MeterHstryVO;
import kr.or.ddit.domain.apt.mgmtOffice.meter.vo.UtilityProviderVO;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

/**
 * 검침 이력 Service 인터페이스
 */
public interface IMeterHstryService {

    /** 검침 이력 목록 조회 */
    List<MeterHstryVO> selectMeterHstryList(Map<String, Object> paramMap);

    /** 공급/검침 설정 목록 조회 */
    List<UtilityProviderVO> selectUtilityProviderList(String mgmtOfcNo);

    /** 검침결과 공통코드 목록 조회 */
    List<Map<String, Object>> selectMeterRsltCodeList();

    /** 검침 CSV 업로드 처리 */
    int uploadMeterCsv(String mgmtOfcNo, String utilityProviderNo, MultipartFile csvFile, String uploadUserNo) throws Exception;

    /** 검침 이력 단건 상세 조회 */
    MeterHstryVO selectMeterHstryDetail(String meterHstryNo);

    /** 검침 이력 수정 */
    int updateMeterHstry(MeterHstryVO meterHstryVO);
}
