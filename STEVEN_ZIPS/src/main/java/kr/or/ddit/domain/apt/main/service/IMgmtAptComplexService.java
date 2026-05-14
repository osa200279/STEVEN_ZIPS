package kr.or.ddit.domain.apt.main.service;

import kr.or.ddit.domain.apt.main.vo.ComplexEditDTO;

public interface IMgmtAptComplexService {

   ComplexEditDTO.DetailResponse getComplexDetail(String mgmtOfcNo);

   void updateComplex(String mgmtOfcNo, ComplexEditDTO.SaveRequest request);
}
