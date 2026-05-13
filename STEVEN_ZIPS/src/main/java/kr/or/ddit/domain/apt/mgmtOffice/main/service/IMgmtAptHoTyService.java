package kr.or.ddit.domain.apt.mgmtOffice.main.service;

import kr.or.ddit.domain.apt.apiApartment.vo.AptHoTyVO;

import java.util.List;

public interface IMgmtAptHoTyService {
    List<AptHoTyVO> selectHoTypeList(String mgmtOfcNo);
}
