package kr.or.ddit.domain.apt.mgmtOffice.bill.service;

import kr.or.ddit.domain.apt.mgmtOffice.bill.mapper.IBillChargeMapper;
import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.BillDetailVO;
import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.BillVO;
import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.ExpenseVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
public class BillChargeServiceImpl implements IBillChargeService {

    @Autowired
    private IBillChargeMapper billChargeMapper;

    /**
     * 관리비 부과 전 미리보기
     * @Author 이윤진
     * @param aptCmplexNo
     * @param billYm
     * @return
     */
    @Override
    public Map<String, Object> previewBillCharge(String aptCmplexNo, String billYm) {

        validateBillYm(billYm);

        int expenseYr = Integer.parseInt(billYm.substring(0, 4));
        int expenseMm = Integer.parseInt(billYm.substring(4, 6));

        int alreadyChargedCount =
                billChargeMapper.selectBillChargeExistsCount(aptCmplexNo, billYm);

        List<BillVO> houseList =
                billChargeMapper.selectBillTargetHouseList(aptCmplexNo);

        List<ExpenseVO> expenseSummaryList =
                billChargeMapper.selectExpenseSummaryForCharge(aptCmplexNo, expenseYr, expenseMm);

        int householdCount = houseList.size();

        long totalExpenseAmt = 0L;

        for (ExpenseVO expense : expenseSummaryList) {
            totalExpenseAmt += expense.getExpenseAmt();
        }

        long expectedPerHouseAmt = 0L;

        if (householdCount > 0) {
            expectedPerHouseAmt = totalExpenseAmt / householdCount;
        }

        Map<String, Object> result = new HashMap<>();
        result.put("billYm", billYm);
        result.put("expenseYr", expenseYr);
        result.put("expenseMm", expenseMm);
        result.put("alreadyChargedCount", alreadyChargedCount);
        result.put("householdCount", householdCount);
        result.put("totalExpenseAmt", totalExpenseAmt);
        result.put("expectedPerHouseAmt", expectedPerHouseAmt);
        result.put("expenseSummaryList", expenseSummaryList);

        return result;
    }

    @Transactional
    @Override
    public Map<String, Object> executeBillCharge(String aptCmplexNo, String billYm, String dueDt) {
        validateBillYm(billYm);
        validateDueDt(dueDt);

        int expenseYr = Integer.parseInt(billYm.substring(0, 4));
        int expenseMm = Integer.parseInt(billYm.substring(4, 6));

        // 1. 이미 해당 월 관리비가 부과되었는지 확인
        int alreadyChargedCount =
                billChargeMapper.selectBillChargeExistsCount(aptCmplexNo, billYm);

        if (alreadyChargedCount > 0) {
            throw new IllegalStateException("이미 해당 월 관리비가 부과되어 있습니다.");
        }

        // 2. 부과 대상 세대 조회
        List<BillVO> houseList =
                billChargeMapper.selectBillTargetHouseList(aptCmplexNo);

        if (houseList == null || houseList.isEmpty()) {
            throw new IllegalStateException("부과 대상 세대가 없습니다.");
        }

        // 3. 해당 월 지출 항목 합계 조회
        List<ExpenseVO> expenseSummaryList =
                billChargeMapper.selectExpenseSummaryForCharge(aptCmplexNo, expenseYr, expenseMm);

        if (expenseSummaryList == null || expenseSummaryList.isEmpty()) {
            throw new IllegalStateException("해당 월 지출 내역이 없습니다.");
        }

        int householdCount = houseList.size();

        int billInsertCount = 0;
        int detailInsertCount = 0;

        // 4. 세대별 BILL 생성
        for (BillVO house : houseList) {

            long billTotAmt = 0L;

            BillVO billVO = new BillVO();
            billVO.setHoNo(house.getHoNo());
            billVO.setBillYm(billYm);
            billVO.setDueDt(Date.valueOf(dueDt));

            // 관리비 부과 직후 상태: READY = 고지완료/고지됨
            billVO.setPymtSttsCd("READY");

            // 납부금액은 아직 없음
            billVO.setPymtAmt(null);
            billVO.setPymtDt(null);

            // 기본 연체요율 3%
            billVO.setLateFeeRt(new BigDecimal("0.0300"));
            billVO.setLateFeeAmt(0L);

            // 항목별 세대 부담액 합산
            for (ExpenseVO expense : expenseSummaryList) {
                long itemAmt = expense.getExpenseAmt() / householdCount;
                billTotAmt += itemAmt;
            }

            billVO.setBillTotAmt(billTotAmt);

            // BILL insert
            billChargeMapper.insertBill(billVO);
            billInsertCount++;

            // selectKey로 생성된 BILL_NO
            String billNo = billVO.getBillNo();

            // 5. BILL_DETAIL insert
            for (ExpenseVO expense : expenseSummaryList) {

                long itemAmt = expense.getExpenseAmt() / householdCount;

                BillDetailVO detailVO = new BillDetailVO();
                detailVO.setBillNo(billNo);
                detailVO.setBillItemCd(expense.getExpenseCd());
                detailVO.setBillItemAmt(itemAmt);
                detailVO.setAtchFileId(null);

                billChargeMapper.insertBillDetail(detailVO);
                detailInsertCount++;
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("billYm", billYm);
        result.put("householdCount", householdCount);
        result.put("billInsertCount", billInsertCount);
        result.put("detailInsertCount", detailInsertCount);

        return result;
    }

    private void validateBillYm(String billYm) {
        if (billYm == null || !billYm.matches("\\d{6}")) {
            throw new IllegalArgumentException("관리년월은 YYYYMM 형식이어야 합니다.");
        }

        int month = Integer.parseInt(billYm.substring(4, 6));

        if (month < 1 || month > 12) {
            throw new IllegalArgumentException("관리월은 01월부터 12월 사이여야 합니다.");
        }
    }

    private void validateDueDt(String dueDt) {
        if (dueDt == null || !dueDt.matches("\\d{4}-\\d{2}-\\d{2}")) {
            throw new IllegalArgumentException("납부기한은 YYYY-MM-DD 형식이어야 합니다.");
        }
    }
}
