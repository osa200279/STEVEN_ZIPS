package kr.or.ddit.domain.apt.complaint.mapper;

import kr.or.ddit.domain.apt.complaint.vo.CvplVO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ICvplMapper {
    int insertCvplApply(CvplVO cvplVO);
}
