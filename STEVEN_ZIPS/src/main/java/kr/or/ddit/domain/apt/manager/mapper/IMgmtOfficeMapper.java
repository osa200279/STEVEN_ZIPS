package kr.or.ddit.domain.apt.manager.mapper;

import kr.or.ddit.domain.apt.manager.vo.MgmtOfficeVO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface IMgmtOfficeMapper {

    MgmtOfficeVO selectMgmtOfficeByManagerUserNo(String userNo);

    MgmtOfficeVO selectOneMgmtOffice(String aptCmplexNo);
}
