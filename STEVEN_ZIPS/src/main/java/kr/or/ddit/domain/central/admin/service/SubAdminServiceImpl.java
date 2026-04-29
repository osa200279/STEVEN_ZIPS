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
    public int insertRequest(SubAdminVO vo) {
        return mapper.insertRequest(vo);
    }

    @Override
    public int updateRequest(SubAdminVO vo) {
        return mapper.updateRequest(vo);
    }

    @Override
    public int deleteRequest(String rqstNo) {
        return mapper.deleteRequest(rqstNo);
    }

    /**
     * 승인 처리
     * @Transactional이란?
     * → 여러 SQL을 하나의 작업 단위로 묶는 기능.
     * 왜 사용?
     * → MEMBER 생성은 됐는데 MANAGER 생성이 실패하면 데이터가 꼬인다.
     *   그래서 중간에 하나라도 실패하면 전체를 rollback 하기 위해 사용한다.
     */
    @Override
    @Transactional
    public int approveRequest(String rqstNo, String aprvId) {
        SubAdminVO rqst = mapper.selectRequest(rqstNo);
        if (rqst == null) {
            return 0;
        }

        // 이미 승인되어 USER_NO가 연결된 신청 건은 중복 계정 생성을 막는다.
        if (StringUtils.hasText(rqst.getUserNo())) {
            return 0;
        }

        if (mapper.countMemberByUserId(rqst.getRqstLoginId()) > 0) {
            throw new IllegalStateException("이미 사용 중인 로그인 아이디입니다: " + rqst.getRqstLoginId());
        }

        String mgmtOfcNo = mapper.selectMgmtOfcNoByApt(rqst.getAptCmplexNo());
        if (!StringUtils.hasText(mgmtOfcNo)) {
            throw new IllegalStateException("해당 단지에 연결된 관리사무소가 없습니다. MGMT_OFFICE 데이터를 먼저 등록하세요.");
        }
        rqst.setMgmtOfcNo(mgmtOfcNo);

        mapper.insertMemberForManager(rqst);     // 로그인 사용자 생성
        mapper.insertAuthForManager(rqst.getUserNo()); // 권한 생성
        mapper.insertManager(rqst);              // 단지 관리자 정보 생성

        return mapper.approveRequest(rqstNo, aprvId, rqst.getUserNo());
    }

    @Override
    @Transactional
    public int rejectRequest(String rqstNo, String aprvId, String rjctRsnCn) {
        return mapper.rejectRequest(rqstNo, aprvId, rjctRsnCn);
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
