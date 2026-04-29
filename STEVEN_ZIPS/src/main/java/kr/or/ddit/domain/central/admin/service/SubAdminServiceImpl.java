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


    @Override
    @Transactional
    public int approveRequest(String rqstNo, String aprvId) {
    /*
        승인 버튼 클릭 시 실행되는 메서드.

        지금 구조에서는 승인 버튼을 누르면
        MEMBER, AUTH, MANAGER에 바로 등록되도록 처리한다.
    */

        SubAdminVO rqst = mapper.selectRequest(rqstNo);

        if (rqst == null) {
            throw new IllegalStateException("신청 정보를 찾을 수 없습니다.");
        }

        // 이미 승인되어 USER_NO가 있으면 중복 생성 방지
        if (StringUtils.hasText(rqst.getUserNo())) {
            return 0;
        }

        // MEMBER.USER_ID 중복 방지
        if (mapper.countMemberByUserId(rqst.getRqstLoginId()) > 0) {
            throw new IllegalStateException("이미 사용 중인 로그인 아이디입니다: " + rqst.getRqstLoginId());
        }

        // 신청 단지에 연결된 관리사무소 번호 조회
        String mgmtOfcNo = mapper.selectMgmtOfcNoByApt(rqst.getAptCmplexNo());

        if (!StringUtils.hasText(mgmtOfcNo)) {
            throw new IllegalStateException("해당 단지에 연결된 관리사무소가 없습니다.");
        }

        rqst.setMgmtOfcNo(mgmtOfcNo);

        mapper.insertMemberForManager(rqst);
        mapper.insertAuthForManager(rqst.getUserNo());
        mapper.insertManager(rqst);

        return mapper.approveRequest(rqstNo, aprvId, rqst.getUserNo());
    }

    @Override
    @Transactional
    public int addApprovedAccount(String rqstNo) {
    /*
        승인완료 상태의 신청 건을 실제 계정 목록에 반영하는 메서드.

        처리 흐름:
        1. 신청 정보 조회
        2. MEMBER 생성 여부 확인
        3. AUTH 권한 등록
        4. MANAGER 등록
        5. 신청 상태 승인완료 처리
    */

        SubAdminVO rqst = mapper.selectRequest(rqstNo);

        if (rqst == null) {
            throw new IllegalStateException("신청 정보를 찾을 수 없습니다.");
        }

    /*
        이미 USER_NO가 있으면 이미 MEMBER가 생성된 상태로 판단.
        중복 insert 방지용.
    */
        if (StringUtils.hasText(rqst.getUserNo())) {
            return 0;
        }

        if (mapper.countMemberByUserId(rqst.getRqstLoginId()) > 0) {
            throw new IllegalStateException("이미 사용 중인 로그인 아이디입니다: " + rqst.getRqstLoginId());
        }

        String mgmtOfcNo = mapper.selectMgmtOfcNoByApt(rqst.getAptCmplexNo());

        if (!StringUtils.hasText(mgmtOfcNo)) {
            throw new IllegalStateException("해당 단지에 연결된 관리사무소가 없습니다.");
        }

        rqst.setMgmtOfcNo(mgmtOfcNo);

        mapper.insertMemberForManager(rqst);
        mapper.insertAuthForManager(rqst.getUserNo());
        mapper.insertManager(rqst);

        return mapper.approveRequest(rqstNo, "central_admin", rqst.getUserNo());
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
