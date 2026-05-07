package kr.or.ddit.domain.apt.manager.service;

import kr.or.ddit.domain.apt.manager.vo.MgmtOfficeVO;

public interface IMgmtOfficeService {
    MgmtOfficeVO selectMgmtOfficeByManagerUserNo(String userId);
}
