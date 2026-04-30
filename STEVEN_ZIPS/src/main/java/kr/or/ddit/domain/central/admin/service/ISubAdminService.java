package kr.or.ddit.domain.central.admin.service;

import java.util.List;

import kr.or.ddit.domain.central.admin.mapper.ISubAdminMapper;
import kr.or.ddit.domain.central.admin.vo.SubAdminSearchVO;
import kr.or.ddit.domain.central.admin.vo.SubAdminVO;
import org.springframework.transaction.annotation.Transactional;

/**
 * Service란?
 * → Controller와 Mapper 사이에서 업무 로직을 처리하는 계층.
 * 왜 사용?
 * → 승인 시 MEMBER/AUTH/MANAGER를 동시에 생성하는 작업처럼 여러 DB 작업을 하나의 업무로 묶기 위해 사용한다.
 */
public interface ISubAdminService {

    List<SubAdminVO> getRequestList(SubAdminSearchVO searchVO);
    List<SubAdminVO> getAccountList(SubAdminSearchVO searchVO);
    SubAdminVO getAccount(String userNo);

    int updateRequest(SubAdminVO vo);
    int deleteRequest(String rqstNo);


    int approveRequest(String rqstNo, String aprvId);
    int rejectRequest(String rqstNo, String aprvId, String rjctRsnCn);

    /* 계정 사용/미사용 */
    int updateAccountUseYn(String userNo, String userYn);
    int deleteAccount(String userNo);

    /*
         승인완료된 신청 건을 실제 단지 관리자 계정 목록에 추가
     */
    int addApprovedAccount(String rqstNo);


}
