package kr.or.ddit.domain.apt.mgmtOffice.service;

import kr.or.ddit.domain.apt.mgmtOffice.mapper.IMgmtOfficeMapper;
import kr.or.ddit.domain.apt.mgmtOffice.vo.MgmtOfficeVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MgmtOfficeServiceImpl implements IMgmtOfficeService {

    @Autowired
    private IMgmtOfficeMapper mgmtOfficeMapper;

    @Override
    public MgmtOfficeVO selectMgmtOfficeByManagerUserNo(String userId) {
        return mgmtOfficeMapper.selectMgmtOfficeByManagerUserNo(userId);
    }
}
