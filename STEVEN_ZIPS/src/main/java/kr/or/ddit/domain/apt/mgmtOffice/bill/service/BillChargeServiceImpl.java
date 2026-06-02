package kr.or.ddit.domain.apt.mgmtOffice.bill.service;

import kr.or.ddit.domain.apt.mgmtOffice.bill.mapper.IBillChargeMapper;
import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.BillDetailVO;
import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.BillVO;
import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.ExpenseVO;
import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.MeterChargeVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.sql.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Slf4j
@Service
public class BillChargeServiceImpl implements IBillChargeService {

    @Autowired
    private IBillChargeMapper billChargeMapper;

    @Autowired
    private IMeterChargeService meterChargeService;

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

        int householdCount = houseList == null ? 0 : houseList.size();

        long totalExpenseAmt = 0L;

        if (expenseSummaryList != null) {
            for (ExpenseVO expense : expenseSummaryList) {
                    totalExpenseAmt += expense.getExpenseAmt();
            }
        }

        /*
         * 검침요금 계산 목록 조회
         * - ELC/WTR/GAS 세대별 계산금액이 들어온다.
         * - 미리보기에서는 총 검침요금과 평균 예상금액만 계산한다.
         */
        List<MeterChargeVO> meterChargeList =
                meterChargeService.selectCalculatedMeterChargeList(aptCmplexNo, billYm);

        long totalMeterChargeAmt = 0L;

        if (meterChargeList != null) {
            for (MeterChargeVO meter : meterChargeList) {
                if (meter.getChargeAmt() != null) {
                    totalMeterChargeAmt += meter.getChargeAmt();
                }
            }
        }

        long expectedPerHouseAmt = 0L;
        long expectedAvgMeterAmt = 0L;
        long expectedAvgTotalAmt = 0L;

        if (householdCount > 0) {
            expectedPerHouseAmt = totalExpenseAmt / householdCount;
            expectedAvgMeterAmt = totalMeterChargeAmt / householdCount;
            expectedAvgTotalAmt = (totalExpenseAmt + totalMeterChargeAmt) / householdCount;
        }

        Map<String, Object> result = new HashMap<>();
        result.put("billYm", billYm);
        result.put("expenseYr", expenseYr);
        result.put("expenseMm", expenseMm);
        result.put("alreadyChargedCount", alreadyChargedCount);
        result.put("householdCount", householdCount);

        // 공용 지출 합계
        result.put("totalExpenseAmt", totalExpenseAmt);

        // 검침요금 합계
        result.put("totalMeterChargeAmt", totalMeterChargeAmt);

        // 기존 화면 호환용: 공용관리비 세대당 예상금액
        result.put("expectedPerHouseAmt", expectedPerHouseAmt);

        // 추가 미리보기용
        result.put("expectedAvgMeterAmt", expectedAvgMeterAmt);
        result.put("expectedAvgTotalAmt", expectedAvgTotalAmt);

        result.put("expenseSummaryList", expenseSummaryList);
        result.put("meterChargeCount", meterChargeList == null ? 0 : meterChargeList.size());

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

        /*
         * 4. 해당 월 검침요금 계산 목록 조회
         * - MeterChargeService에서 단가와 chargeAmt 계산이 끝난 상태로 가져온다.
         * - hoNo 기준으로 묶어서 세대별 BILL 생성 시 합산한다.
         */
        List<MeterChargeVO> meterChargeList =
                meterChargeService.selectCalculatedMeterChargeList(aptCmplexNo, billYm);

        Map<String, List<MeterChargeVO>> meterChargeMap = new HashMap<>();

        if (meterChargeList != null && !meterChargeList.isEmpty()) {
            meterChargeMap = meterChargeList.stream()
                    .filter(meter -> meter.getHoNo() != null)
                    .collect(Collectors.groupingBy(MeterChargeVO::getHoNo));
        }

        int billInsertCount = 0;
        int detailInsertCount = 0;
        long totalBillAmount = 0L;
        long totalExpenseShareAmount = 0L;
        long totalMeterChargeAmount = 0L;

        // 5. 세대별 BILL 생성
        for (BillVO house : houseList) {

            long billTotAmt = 0L;

            /*
             * BILL_DETAIL은 BILL_NO가 필요하다.
             * 하지만 BILL_TOT_AMT 계산을 먼저 해야 하므로
             * 상세 항목들을 임시 리스트에 담아두고,
             * BILL insert 후 billNo를 넣어서 상세 insert 한다.
             */
            List<BillDetailVO> detailList = new ArrayList<>();

            // 5-1. 공용 지출 항목별 세대 부담액 계산
            for (ExpenseVO expense : expenseSummaryList) {
                long expenseAmt = expense.getExpenseAmt();
                long itemAmt = expenseAmt / householdCount;

                billTotAmt += itemAmt;
                totalExpenseShareAmount += itemAmt;

                BillDetailVO detailVO = new BillDetailVO();
                detailVO.setBillItemCd(expense.getExpenseCd());
                detailVO.setBillItemAmt(itemAmt);
                detailVO.setAtchFileId(null);

                detailList.add(detailVO);
            }

            // 5-2. 세대별 검침요금 ELC/WTR/GAS 추가
            List<MeterChargeVO> houseMeterChargeList = meterChargeMap.get(house.getHoNo());

            if (houseMeterChargeList != null && !houseMeterChargeList.isEmpty()) {
                for (MeterChargeVO meter : houseMeterChargeList) {
                    long meterAmt = meter.getChargeAmt() == null ? 0L : meter.getChargeAmt();

                    billTotAmt += meterAmt;
                    totalMeterChargeAmount += meterAmt;

                    BillDetailVO meterDetailVO = new BillDetailVO();
                    meterDetailVO.setBillItemCd(meter.getBillItemCd());   // ELC, WTR, GAS
                    meterDetailVO.setBillItemAmt(meterAmt);
                    meterDetailVO.setAtchFileId(null);

                    detailList.add(meterDetailVO);
                }
            }

            // 5-3. BILL insert
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

            // 공용관리비 + 세대별 검침요금
            billVO.setBillTotAmt(billTotAmt);

            billChargeMapper.insertBill(billVO);
            billInsertCount++;

            totalBillAmount += billTotAmt;

            // selectKey로 생성된 BILL_NO
            String billNo = billVO.getBillNo();

            if (billNo == null || billNo.isBlank()) {
                throw new IllegalStateException("관리비 고지서 번호 생성에 실패했습니다.");
            }

            // 5-4. BILL_DETAIL insert
            for (BillDetailVO detailVO : detailList) {
                detailVO.setBillNo(billNo);

                billChargeMapper.insertBillDetail(detailVO);
                detailInsertCount++;
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("billYm", billYm);
        result.put("householdCount", householdCount);
        result.put("billInsertCount", billInsertCount);
        result.put("detailInsertCount", detailInsertCount);

        // 결과 확인용 추가
        result.put("totalBillAmount", totalBillAmount);
        result.put("totalExpenseShareAmount", totalExpenseShareAmount);
        result.put("totalMeterChargeAmount", totalMeterChargeAmount);
        result.put("meterChargeCount", meterChargeList == null ? 0 : meterChargeList.size());

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