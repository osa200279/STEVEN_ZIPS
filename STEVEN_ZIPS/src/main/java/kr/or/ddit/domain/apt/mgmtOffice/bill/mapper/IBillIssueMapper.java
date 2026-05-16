package kr.or.ddit.domain.apt.mgmtOffice.bill.mapper;

import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.BillDetailVO;
import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.BillVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface IBillIssueMapper {

    // 고지서 목록 조회
    List<BillVO> selectBillIssueList(BillVO billVO);

    // 고지서 상세 마스터 조회
    BillVO selectBillIssueDetail(@Param("aptCmplexNo") String aptCmplexNo,
                                 @Param("billNo") String billNo);

    // 고지서 상세 항목 조회
    List<BillDetailVO> selectBillDetailList(String billNo);
}
