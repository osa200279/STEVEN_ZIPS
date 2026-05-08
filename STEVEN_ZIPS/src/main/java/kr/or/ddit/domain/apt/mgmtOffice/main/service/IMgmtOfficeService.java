package kr.or.ddit.domain.apt.mgmtOffice.main.service;

import kr.or.ddit.domain.apt.mgmtOffice.main.vo.MgmtOfficeVO;

public interface IMgmtOfficeService {
    MgmtOfficeVO selectMgmtOfficeByManagerUserNo(String userId);
}
