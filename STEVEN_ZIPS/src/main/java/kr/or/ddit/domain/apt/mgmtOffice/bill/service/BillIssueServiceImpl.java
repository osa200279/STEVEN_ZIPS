package kr.or.ddit.domain.apt.mgmtOffice.bill.service;

import kr.or.ddit.domain.apt.mgmtOffice.bill.mapper.IBillIssueMapper;
import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.BillDetailVO;
import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.BillVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BillIssueServiceImpl implements IBillIssueService{

    @Autowired
    private IBillIssueMapper billIssueMapper;

    @Override
    public List<BillVO> selectBillIssueList(BillVO billVO) {
        return billIssueMapper.selectBillIssueList(billVO);
    }

    @Override
    public BillVO selectBillIssueDetail(String aptCmplexNo, String billNo) {
        BillVO billVO = billIssueMapper.selectBillIssueDetail(aptCmplexNo, billNo);

        if (billVO == null) {
            throw new IllegalArgumentException("고지서 정보를 찾을 수 없습니다.");
        }

        List<BillDetailVO> detailList = billIssueMapper.selectBillDetailList(billNo);
        billVO.setDetailList(detailList);

        return billVO;
    }
}
