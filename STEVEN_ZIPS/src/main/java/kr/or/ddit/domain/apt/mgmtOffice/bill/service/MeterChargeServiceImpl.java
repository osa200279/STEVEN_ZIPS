package kr.or.ddit.domain.apt.mgmtOffice.bill.service;

import kr.or.ddit.domain.apt.mgmtOffice.bill.mapper.IMeterChargeMapper;
import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.MeterChargeVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class MeterChargeServiceImpl implements IMeterChargeService{

    @Autowired
    private IMeterChargeMapper meterChargeMapper;

    // 단가 기준. 필요하면 나중에 DB화 가능
    private static final Long ELECTRIC_UNIT_PRICE = 130L;
    private static final Long WATER_UNIT_PRICE = 900L;
    private static final Long GAS_UNIT_PRICE = 1100L;

    @Override
    public Map<String, Object> selectMeterChargeList(String aptCmplexNo, String billYm) {
        List<MeterChargeVO> list = selectCalculatedMeterChargeList(aptCmplexNo, billYm);

        long electricTotal = 0L;
        long waterTotal = 0L;
        long gasTotal = 0L;
        long grandTotal = 0L;

        long electricUsageTotal = 0L;
        long waterUsageTotal = 0L;
        long gasUsageTotal = 0L;

        for (MeterChargeVO meter : list) {
            Long chargeAmt = meter.getChargeAmt() == null ? 0L : meter.getChargeAmt();
            Long usageVal = meter.getUsageVal() == null ? 0L : meter.getUsageVal();

            if ("ELC".equals(meter.getBillItemCd())) {
                electricTotal += chargeAmt;
                electricUsageTotal += usageVal;
            } else if ("WTR".equals(meter.getBillItemCd())) {
                waterTotal += chargeAmt;
                waterUsageTotal += usageVal;
            } else if ("GAS".equals(meter.getBillItemCd())) {
                gasTotal += chargeAmt;
                gasUsageTotal += usageVal;
            }

            grandTotal += chargeAmt;
        }

        Map<String, Object> result = new HashMap<>();
        result.put("list", list);

        result.put("electricTotal", electricTotal);
        result.put("waterTotal", waterTotal);
        result.put("gasTotal", gasTotal);
        result.put("grandTotal", grandTotal);

        result.put("electricUsageTotal", electricUsageTotal);
        result.put("waterUsageTotal", waterUsageTotal);
        result.put("gasUsageTotal", gasUsageTotal);

        result.put("electricUnitPrice", ELECTRIC_UNIT_PRICE);
        result.put("waterUnitPrice", WATER_UNIT_PRICE);
        result.put("gasUnitPrice", GAS_UNIT_PRICE);

        return result;
    }

    public List<MeterChargeVO> selectCalculatedMeterChargeList(String aptCmplexNo, String billYm) {
        List<MeterChargeVO> list = meterChargeMapper.selectMeterChargeList(aptCmplexNo, billYm);

        for (MeterChargeVO meter : list) {
            long usageVal = meter.getUsageVal() == null ? 0L : meter.getUsageVal();
            long unitPrice = getUnitPrice(meter.getBillItemCd());
            long chargeAmt = usageVal * unitPrice;

            meter.setUnitPrice(unitPrice);
            meter.setChargeAmt(chargeAmt);
        }

        return list;
    }

    private long getUnitPrice(String billItemCd) {
        if ("ELC".equals(billItemCd)) {
            return ELECTRIC_UNIT_PRICE;
        }

        if ("WTR".equals(billItemCd)) {
            return WATER_UNIT_PRICE;
        }

        if ("GAS".equals(billItemCd)) {
            return GAS_UNIT_PRICE;
        }

        return 0L;
    }
}
