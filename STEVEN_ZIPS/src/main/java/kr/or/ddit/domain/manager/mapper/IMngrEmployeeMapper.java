package kr.or.ddit.domain.manager.mapper;

import kr.or.ddit.domain.apt.manager.vo.ManagerVO;
import kr.or.ddit.domain.apt.manager.vo.MngrRqstVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface IMngrEmployeeMapper {


    public List<ManagerVO> selectManagerList();
    public List<MngrRqstVO> selectRequestList();
    public ManagerVO selectManagerDetail(String userNo);

    public MngrRqstVO selectRequestDetail(String rqstNo);
    public int insertRequest(MngrRqstVO mngrRqstVO);
    public int updateRequest(MngrRqstVO mngrRqstVO);
    public int cancelRequest(MngrRqstVO mngrRqstVO);

    // MANAGER 테이블 수정
    public int updateManager(ManagerVO managerVO);

    // MEMBER 테이블 수정
    public int updateManagerMember(ManagerVO managerVO);

    // 재직 직원 계정 비활성화
    public int deactivateManager(ManagerVO managerVO);

}
