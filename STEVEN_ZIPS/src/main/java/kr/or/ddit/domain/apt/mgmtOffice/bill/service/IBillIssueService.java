package kr.or.ddit.domain.apt.mgmtOffice.bill.service;

import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.BillVO;

import java.util.List;

public interface IBillIssueService {
    List<BillVO> selectBillIssueList(BillVO searchVO);

    BillVO selectBillIssueDetail(String aptCmplexNo, String billNo);
}
