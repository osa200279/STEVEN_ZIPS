package kr.or.ddit.domain.apt.mgmtOffice.survey.mapper;

import kr.or.ddit.domain.apt.mgmtOffice.survey.dto.MngSurveyDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface IMngSurveyMapper {


    void insertSurvey(MngSurveyDTO dto);

    List<MngSurveyDTO> selectSurveyList(String mgmtOfcNo);
}
