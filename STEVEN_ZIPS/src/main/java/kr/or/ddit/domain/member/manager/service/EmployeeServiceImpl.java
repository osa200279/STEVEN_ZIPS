package kr.or.ddit.domain.member.manager.service;

import java.util.List;

import kr.or.ddit.domain.member.manager.mapper.IEmployeeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.domain.member.manager.vo.ManagerVO;
import kr.or.ddit.domain.member.manager.vo.MngrRqstVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class EmployeeServiceImpl implements IEmployeeService {

    @Autowired
    private IEmployeeMapper employeeMapper;

    // 재직 직원 목록
    @Override
    public List<ManagerVO> getManagerList(String mgmtOfcNo) {
        return employeeMapper.selectManagerList(mgmtOfcNo);
    }

    // 재직 직원 직무 수정
    @Override
    public boolean updateManagerDuty(ManagerVO vo) {
        return employeeMapper.updateManagerDuty(vo) > 0;
    }

    // 재직 직원 비활성화
    @Override
    public boolean deactivateMember(String userNo) {
        return employeeMapper.deactivateMember(userNo) > 0;
    }

    // 요청 목록
    @Override
    public List<MngrRqstVO> getRequestList(String mgmtOfcNo) {
        return employeeMapper.selectRequestList(mgmtOfcNo);
    }

    // 요청 등록
    @Override
    public boolean insertRequest(MngrRqstVO vo) {
        return employeeMapper.insertRequest(vo) > 0;
    }

    // 요청 수정
    @Override
    public boolean updateRequest(MngrRqstVO vo) {
        return employeeMapper.updateRequest(vo) > 0;
    }

    // 요청 취소
    @Override
    public boolean cancelRequest(MngrRqstVO vo) {
        return employeeMapper.cancelRequest(vo) > 0;
    }

    /*// 회원 검색
    @Override
    public List<MemberSearchVO> searchMember(String keyword) {
        return employeeMapper.searchMember(keyword);
    }*/

    // 로그인 소장 정보
    @Override
    public ManagerVO getLoginManagerInfo(String userNo) {
        return employeeMapper.selectLoginManagerInfo(userNo);
    }
}