package kr.or.ddit.domain.apt.mgmtOffice.bill.service;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.BillVO;

import java.util.List;

public interface IBillIssueService {

    List<BillVO> selectBillDongList(String aptCmplexNo);

    PaginationInfoVO<BillVO> selectBillIssueList(PaginationInfoVO<BillVO> pagingVO);

    BillVO selectBillIssueDetail(String aptCmplexNo, String billNo);
}
