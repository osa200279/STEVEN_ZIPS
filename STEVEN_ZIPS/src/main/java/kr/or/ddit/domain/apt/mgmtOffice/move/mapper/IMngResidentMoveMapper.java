package kr.or.ddit.domain.apt.mgmtOffice.move.mapper;

import kr.or.ddit.domain.apt.mgmtOffice.move.dto.MngResidentMoveSearchDTO;
import kr.or.ddit.domain.apt.mgmtOffice.move.vo.MngResidentMoveVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface IMngResidentMoveMapper {

    List<MngResidentMoveVO> selectResidentMoveList(MngResidentMoveSearchDTO searchDTO);

    MngResidentMoveVO selectResidentMoveDetail(
            @Param("mgmtOfcNo") String mgmtOfcNo,
            @Param("userNo") String userNo
    );

    int countResidentMoveByUserNo(@Param("userNo") String userNo);

    int insertResidentMove(MngResidentMoveVO vo);

    int updateResidentMove(MngResidentMoveVO vo);
}
