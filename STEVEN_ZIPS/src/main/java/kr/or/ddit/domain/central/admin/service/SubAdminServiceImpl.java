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
        승인 처리용 로직

        중요:
        여기서는 AUTH를 ROLE_MNGR로 바꾸지 않는다.
         → AUTH를 바로 ROLE_MNGR로 바꾸면 아래 '단지 관리자 계정 목록'에 즉시 나타난다.
         다운로드 아이콘을 눌렀을 때만 아래 목록으로 이동해야 함.

        현재 프로세스:
        - MANAGER 테이블에는 이미 관리소장/관리자 정보가 존재한다.
        - MNGR_RQST.USER_NO는 MANAGER.USER_NO를 FK로 참조한다.
        - 따라서 승인 시 관리사무소를 새로 찾거나 MANAGER에 INSERT하지 않는다.
        - 승인 시 해야 할 일은 AUTH 권한 변경 + MNGR_RQST 상태 변경이다.
    */

        SubAdminVO rqst = mapper.selectRequest(rqstNo);

        if (rqst == null) {
            throw new IllegalStateException("신청 정보를 찾을 수 없습니다.");
        }

        if (!StringUtils.hasText(rqst.getUserNo())) {
            throw new IllegalStateException("단지관리자 생성요청(MNGR_RQST)테이블에 USER_NO가 없습니다.");
        }

        if ("OK".equalsIgnoreCase(rqst.getRqstSttsCd())) {
            throw new IllegalStateException("이미 승인완료된 신청입니다.");
        }

    /*
        MNGR_RQST 상태만 OK로 변경
    */
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
        다운로드 아이콘 클릭 처리

        역할:
        → 승인완료된 신청 건만 실제 ROLE_MNGR 권한으로 변경한다.
        → 이때부터 아래 '단지 관리자 계정 목록 및 상태'에 표시된다.
    */
        SubAdminVO rqst = mapper.selectRequest(rqstNo);

        if (rqst == null) {
            throw new IllegalStateException("신청 정보를 찾을 수 없습니다.");
        }

        if (!"OK".equalsIgnoreCase(rqst.getRqstSttsCd())) {
            throw new IllegalStateException("승인완료 상태인 신청만 계정 목록에 추가할 수 있습니다.");
        }

        if (!StringUtils.hasText(rqst.getUserNo())) {
            throw new IllegalStateException("USER_NO가 없습니다.");
        }
        /*
        AUTH란?
        → 사용자 권한 저장 테이블.
        여기서 ROLE_MNGR로 바뀌면 아래 계정 목록 조회 조건에 포함된다.
         */
        mapper.updateAuthToManager(rqst.getUserNo());

        return mapper.updateAccountDsplyYn(rqstNo);
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
        /*
         * 논리삭제란?
         * → DB 데이터를 실제 DELETE로 지우지 않고,
         *   사용 여부값만 N으로 바꿔 화면에서 숨기는 방식.
         *
         * 왜 사용?
         * → 계정 이력, 승인 이력, FK 관계 데이터를 보존하기 위해 사용한다.
         *
         * 여기서는 MEMBER 테이블의 USER_YN을 'N'으로 변경한다.
         */
        return mapper.updateAccountUseYn(userNo, "N");
    }
}
