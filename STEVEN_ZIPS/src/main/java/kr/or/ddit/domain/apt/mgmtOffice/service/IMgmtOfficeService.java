package kr.or.ddit.domain.apt.mgmtOffice.service;

import kr.or.ddit.domain.apt.mgmtOffice.vo.MgmtOfficeVO;

public interface IMgmtOfficeService {
    MgmtOfficeVO selectMgmtOfficeByManagerUserNo(String userId);
}
