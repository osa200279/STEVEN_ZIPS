package kr.or.ddit.domain.manager.service;

import kr.or.ddit.domain.manager.mapper.IMngrEmployeeMapper;
import kr.or.ddit.domain.manager.vo.ManagerVO;
import kr.or.ddit.domain.manager.vo.MngrRqstVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MngrEmployeeServiceImpl implements IMngrEmployeeService {

    @Autowired
    private IMngrEmployeeMapper mapper;

    // 재직 직원 목록 조회
    @Override
    public List<ManagerVO> selectManagerList() {
        return mapper.selectManagerList();
    }

    // 계정 생성 요청 목록 조회
    @Override
    public List<MngrRqstVO> selectRequestList() {
        return mapper.selectRequestList();
    }

    // 재직 직원 상세 조회
    @Override
    public ManagerVO selectManagerDetail(String userNo) {
        return mapper.selectManagerDetail(userNo);
    }

    // 계정 생성 요청 상세 조회
    @Override
    public MngrRqstVO selectRequestDetail(String rqstNo) {
        return mapper.selectRequestDetail(rqstNo);
    }

    // 계정 생성 요청 등록
    @Override
    public int insertRequest(MngrRqstVO mngrRqstVO) {
        return mapper.insertRequest(mngrRqstVO);
    }

    // 계정 생성 요청 수정
    @Override
    public int updateRequest(MngrRqstVO mngrRqstVO) {
        return mapper.updateRequest(mngrRqstVO);
    }

    // 계정 생성 요청 취소
    @Override
    public int cancelRequest(MngrRqstVO mngrRqstVO) {
        return mapper.cancelRequest(mngrRqstVO);
    }

    // 재직 직원 정보 수정
    @Override
    public int updateManager(ManagerVO managerVO) {
        int result = 0;

        result += mapper.updateManager(managerVO);
        result += mapper.updateManagerMember(managerVO);

        return result;
    }

    // 재직 직원 계정 비활성화
    @Override
    public int deactivateManager(ManagerVO managerVO) {
        return mapper.deactivateManager(managerVO);
    }
}
