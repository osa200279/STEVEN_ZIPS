package kr.or.ddit.domain.member.manager.service;

import java.util.List;

import kr.or.ddit.domain.member.manager.vo.ManagerVO;
import kr.or.ddit.domain.member.manager.vo.MngrRqstVO;

public interface IEmployeeService {

    // 재직 직원
    List<ManagerVO> getManagerList(String mgmtOfcNo);
    boolean updateManagerDuty(ManagerVO vo);
    boolean deactivateMember(String userNo);

    // 계정 생성 요청
    List<MngrRqstVO> getRequestList(String mgmtOfcNo);
    boolean insertRequest(MngrRqstVO vo);
    boolean updateRequest(MngrRqstVO vo);
    boolean cancelRequest(MngrRqstVO vo);

/*    // 회원 검색
    List<MemberSearchVO> searchMember(String keyword);*/

    // 로그인 소장 정보
    ManagerVO getLoginManagerInfo(String userNo);
}