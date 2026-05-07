package kr.or.ddit.domain.apt.complaint.mapper;

import kr.or.ddit.domain.apt.complaint.vo.CvplHstryVO;
import kr.or.ddit.domain.apt.complaint.vo.CvplVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ICvplMapper {
    int insertCvplApply(CvplVO cvplVO);

//    List<CvplHstryVO> selectCvplHstryList(@Param("aptCmplexNo") String aptCmplexNo,@Param("userNo") String userNo);

    int insertCvplHstry(CvplHstryVO cvplHstryVO);
}
