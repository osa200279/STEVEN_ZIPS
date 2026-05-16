package kr.or.ddit.domain.central.mapper;

import kr.or.ddit.domain.central.admin.dto.AnnouncementDTO;
import kr.or.ddit.domain.central.vo.ContractUserVO;
import kr.or.ddit.domain.central.vo.RentCtrtVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface IContractUserMapper {

    String selectRentCtrtNo(String userNo);

    void insertContractDoc(ContractUserVO contractUserVO);
    

    // 지금 안씀
    void insertRentCtrtVO(RentCtrtVO rentCtrtVO);

    // 지금 안씀
    String selectRentLstgNo(String aptCmplexNo);

    void updateInqCnt(String annNo);

    // 경고임 무시해도됨
    List<Map<String, Object>> selectExcluseAreaDetail(String aptCmplexNo);

    void insertAplct(Map<String, Object> params);

    String selectHoTyNo(Map<String, Object> params);

    // 경고임 무시해도됨
    List<Map<String, Object>> selectAplctList(String userNo);

    void cancelContract(String aplctNo);

    // 경고임 무시해도됨
    Map<String, Object> selectOneContractHistoryDetail(String aplctNo);

    // 경고임 무시해도됨
    List<Map<String, Object>> selectSbmsnDocList(String aplctNo);

    int selectAplctcount(Map<String, Object> params);


    // 경고임 무시해도됨
    List<Map<String, Object>> selectAplctDocList(String aplctNo);
}
