package kr.or.ddit.domain.central.admin.service;

import java.util.List;

import kr.or.ddit.domain.central.admin.vo.SubAdminSearchVO;
import kr.or.ddit.domain.central.admin.vo.SubAdminVO;

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

    int insertRequest(SubAdminVO vo);
    int updateRequest(SubAdminVO vo);
    int deleteRequest(String rqstNo);

    int approveRequest(String rqstNo, String aprvId);
    int rejectRequest(String rqstNo, String aprvId, String rjctRsnCn);

    int updateAccountUseYn(String userNo, String userYn);
    int deleteAccount(String userNo);
}
