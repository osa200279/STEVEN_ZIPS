package kr.or.ddit.domain.central.admin.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.domain.central.admin.vo.SubAdminSearchVO;
import kr.or.ddit.domain.central.admin.vo.SubAdminVO;

/**
 * Mapper란?
 * → Java 메서드와 MyBatis XML SQL을 연결하는 인터페이스.
 * 왜 사용?
 * → Service에서 SQL을 직접 작성하지 않고 DB 작업을 분리하기 위해 사용한다.
 */
@Mapper
public interface ISubAdminMapper {

    List<SubAdminVO> selectRequestList(SubAdminSearchVO searchVO);
    List<SubAdminVO> selectAccountList(SubAdminSearchVO searchVO);

    SubAdminVO selectRequest(String rqstNo);
    SubAdminVO selectAccount(String userNo);

    int countMemberByUserId(String userId);

    int insertRequest(SubAdminVO vo);
    int updateRequest(SubAdminVO vo);
    int approveRequest(@Param("rqstNo") String rqstNo, @Param("aprvId") String aprvId, @Param("userNo") String userNo);
    int rejectRequest(@Param("rqstNo") String rqstNo, @Param("aprvId") String aprvId, @Param("rjctRsnCn") String rjctRsnCn);
    int deleteRequest(String rqstNo);

    int insertMemberForManager(SubAdminVO vo);
    int insertAuthForManager(String userNo);
    int insertManager(SubAdminVO vo);

    int updateAccountUseYn(@Param("userNo") String userNo, @Param("userYn") String userYn);

    int deleteManager(String userNo);
    int deleteAuth(String userNo);
    int deleteMember(String userNo);

    String selectMgmtOfcNoByApt(String aptCmplexNo);
}
