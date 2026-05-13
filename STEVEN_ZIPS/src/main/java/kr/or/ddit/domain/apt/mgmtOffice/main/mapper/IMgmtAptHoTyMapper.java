package kr.or.ddit.domain.apt.mgmtOffice.main.mapper;

import kr.or.ddit.domain.apt.apiApartment.vo.AptHoTyVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface IMgmtAptHoTyMapper {
    List<AptHoTyVO> selectHoTypeList(String aptCmplexNo);
}
