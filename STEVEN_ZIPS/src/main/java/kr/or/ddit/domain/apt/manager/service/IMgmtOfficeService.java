package kr.or.ddit.domain.apt.manager.service;

import kr.or.ddit.domain.apt.manager.vo.MgmtOfficeVO;

public interface IMgmtOfficeService {
    public MgmtOfficeVO selectMgmtOfficeByManagerUserNo(String userId);
}
