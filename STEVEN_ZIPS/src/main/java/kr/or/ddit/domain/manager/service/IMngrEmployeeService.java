package kr.or.ddit.domain.manager.service;

import java.util.List;

import kr.or.ddit.domain.apt.manager.vo.MngrRqstVO;
import kr.or.ddit.domain.manager.vo.ManagerVO;

public interface IMngrEmployeeService {

    // 재직 직원 목록 조회
    public List<ManagerVO> selectManagerList();

    // 계정 생성 요청 목록 조회
    public List<MngrRqstVO> selectRequestList();

    // 재직 직원 상세 조회
    public ManagerVO selectManagerDetail(String userNo);

    // 계정 생성 요청 상세 조회
    public MngrRqstVO selectRequestDetail(String rqstNo);

    // 계정 생성 요청 등록
    public int insertRequest(MngrRqstVO mngrRqstVO);

    // 계정 생성 요청 수정
    public int updateRequest(MngrRqstVO mngrRqstVO);

    // 계정 생성 요청 취소
    public int cancelRequest(MngrRqstVO mngrRqstVO);

    // 재직 직원 정보 수정
    public int updateManager(ManagerVO managerVO);

    // 재직 직원 계정 비활성화
    public int deactivateManager(ManagerVO managerVO);
}
