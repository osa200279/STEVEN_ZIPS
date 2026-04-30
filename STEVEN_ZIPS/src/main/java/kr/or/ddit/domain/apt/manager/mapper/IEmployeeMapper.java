package kr.or.ddit.domain.apt.manager.mapper;

import java.util.List;

import kr.or.ddit.domain.apt.manager.vo.ManagerVO;
import kr.or.ddit.domain.apt.manager.vo.MemberSearchVO;
import kr.or.ddit.domain.apt.manager.vo.MngrRqstVO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface IEmployeeMapper {

    // 재직 직원 목록
    List<ManagerVO> selectManagerList(String mgmtOfcNo);

    // 재직 직원 직무 수정
    int updateManagerDuty(ManagerVO vo);

    // 재직 직원 비활성화
    int deactivateMember(String userNo);

    // 요청 목록
    List<MngrRqstVO> selectRequestList(String mgmtOfcNo);

    // 요청 등록
    int insertRequest(MngrRqstVO vo);

    // 요청 수정
    int updateRequest(MngrRqstVO vo);

    // 요청 취소
    int cancelRequest(MngrRqstVO vo);

 /*   // 회원 검색
    List<MemberSearchVO> searchMember(String keyword);
*/
    // 로그인 소장 정보
    ManagerVO selectLoginManagerInfo(String userNo);
}