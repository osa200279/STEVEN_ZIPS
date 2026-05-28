package kr.or.ddit.domain.apt.mgmtOffice.bill.mapper;

import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.MeterChargeVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface IMeterChargeMapper {

    // 세대별 검침 사용량 조회
    List<MeterChargeVO> selectMeterChargeList( @Param("aptCmplexNo") String aptCmplexNo,
                                               @Param("billYm") String billYm);


    int mergeMeterHistory(String aptCmplexNo, String billYm, MeterChargeVO meter);
}
