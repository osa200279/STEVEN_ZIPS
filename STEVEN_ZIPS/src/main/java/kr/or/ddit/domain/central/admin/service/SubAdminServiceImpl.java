package kr.or.ddit.domain.central.admin.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import kr.or.ddit.domain.central.admin.mapper.ISubAdminMapper;
import kr.or.ddit.domain.central.admin.vo.SubAdminSearchVO;
import kr.or.ddit.domain.central.admin.vo.SubAdminVO;
import lombok.RequiredArgsConstructor;

/**
 * @Service란?
 * → 스프링이 업무 처리 클래스로 인식해서 Bean으로 등록하게 하는 어노테이션.
 * Bean이란?
 * → 스프링이 직접 생성하고 관리하는 객체.
 */
@Service
@RequiredArgsConstructor
public class SubAdminServiceImpl implements ISubAdminService {

    private final ISubAdminMapper mapper;

    @Override
    public List<SubAdminVO> getRequestList(SubAdminSearchVO searchVO) {
        return mapper.selectRequestList(searchVO);
    }

    @Override
    public List<SubAdminVO> getAccountList(SubAdminSearchVO searchVO) {
        return mapper.selectAccountList(searchVO);
    }

    @Override
    public SubAdminVO getAccount(String userNo) {
        return mapper.selectAccount(userNo);
    }

    @Override
    public int updateRequest(SubAdminVO vo) {
        return mapper.updateRequest(vo);
    }

    @Override
    public int deleteRequest(String rqstNo) {
        return mapper.deleteRequest(rqstNo);
    }

    @Override
    @Transactional
    public int approveRequest(String rqstNo, String aprvId) {
    /*
        승인 처리 흐름

        → 기존 신청 조회
        → AUTH 권한만 ROLE_MNGR로 UPDATE
        → MNGR_RQST 상태 UPDATE
    */

        SubAdminVO rqst = mapper.selectRequest(rqstNo);

        if (rqst == null) {
            throw new IllegalStateException("신청 정보를 찾을 수 없습니다.");
        }

        if (!StringUtils.hasText(rqst.getUserNo())) {
            throw new IllegalStateException("신청 정보에 USER_NO가 없습니다. MNGR_RQST.USER_NO를 먼저 연결해야 합니다.");
        }

        if ("ok".equalsIgnoreCase(rqst.getRqstSttsCd())) {
            throw new IllegalStateException("이미 승인완료된 신청입니다.");
        }

        String mgmtOfcNo = mapper.selectMgmtOfcNoByApt(rqst.getAptCmplexNo());

        if (!StringUtils.hasText(mgmtOfcNo)) {
            throw new IllegalStateException("해당 단지에 연결된 관리사무소가 없습니다.");
        }

        rqst.setMgmtOfcNo(mgmtOfcNo);

        // AUTH는 INSERT가 아니라 UPDATE
        mapper.updateAuthToManager(rqst.getUserNo());

        return mapper.approveRequest(
                rqstNo,
                aprvId,
                rqst.getUserNo(),
                "단지 관리자 권한 승인 처리"
        );
    }

    @Override
    @Transactional
    public int addApprovedAccount(String rqstNo) {
    /*
        addApprovedAccount는 approveRequest와 기능이 겹친다.

        실무적으로는 승인 버튼 하나에서
        AUTH UPDATE + MANAGER INSERT + MNGR_RQST UPDATE를 끝내는 것이 맞다.
    */
        return approveRequest(rqstNo, "central_admin");
    }

    @Override
    @Transactional
    public int rejectRequest(String rqstNo, String aprvId, String rjctRsnCn) {
    /*
        반려는 계정을 만들지 않는다.
        MNGR_RQST 상태만 reject로 변경한다.
    */
        return mapper.rejectRequest(
                rqstNo,
                aprvId,
                rjctRsnCn,
                "단지 관리자 권한 신청 반려 처리"
        );
    }

    @Override
    public int updateAccountUseYn(String userNo, String userYn) {
        return mapper.updateAccountUseYn(userNo, userYn);
    }

    @Override
    @Transactional
    public int deleteAccount(String userNo) {
        // FK란? 외래키. 다른 테이블이 참조하는 데이터.
        // 왜 자식부터 삭제? MANAGER/AUTH가 MEMBER를 참조하므로 MEMBER를 먼저 지우면 FK 오류가 난다.
        mapper.deleteManager(userNo);
        mapper.deleteAuth(userNo);
        return mapper.deleteMember(userNo);
    }
}
