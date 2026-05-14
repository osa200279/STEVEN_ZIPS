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

    List<ContractUserVO> selectContractDoc(String userNo);

    void insertRentCtrtVO(RentCtrtVO rentCtrtVO);

    String selectRentLstgNo(String aptCmplexNo);

    void updateInqCnt(String annNo);

    List<Map<String, Object>> selectExcluseAreaDetail(String aptCmplexNo);

    void insertAplct(Map<String, Object> params);

    String selectHoTyNo(Map<String, Object> params);

    List<Map<String, Object>> selectAplctList(String userNo);

    void cancelContract(String aplctNo);

    AnnouncementDTO selectOneContractHistoryDetail(String aplctNo);
}
