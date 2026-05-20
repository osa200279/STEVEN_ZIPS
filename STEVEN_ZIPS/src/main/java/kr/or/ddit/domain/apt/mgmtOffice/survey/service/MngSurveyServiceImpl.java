package kr.or.ddit.domain.apt.mgmtOffice.survey.service;

import kr.or.ddit.domain.apt.mgmtOffice.survey.dto.MngSurveyDTO;
import kr.or.ddit.domain.apt.mgmtOffice.survey.mapper.IMngSurveyMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Service;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class MngSurveyServiceImpl implements IMngSurveyService {


    private final IMngSurveyMapper iMngSurveyMapper;


    @Override
    public void registerSurvey(MngSurveyDTO dto) {

        log.info("dto : {}", dto);

        iMngSurveyMapper.insertSurvey(dto);
    }

    @Override
    public List<MngSurveyDTO> selectSurveyList(String mgmtOfcNo) {
        return iMngSurveyMapper.selectSurveyList(mgmtOfcNo);
    }

    @Override
    public MngSurveyDTO selectSurveyDetail(String surveyNo) {

        return iMngSurveyMapper
                .selectSurveyDetail(surveyNo);
    }

    @Override
    public void updateSurvey(
            MngSurveyDTO dto
    ) {

        iMngSurveyMapper.updateSurvey(dto);
    }

    @Override
    public void deleteSurvey(
            String surveyNo
    ) {

        iMngSurveyMapper.deleteSurvey(surveyNo);
    }

    @Override
    public Map<String, Object> selectSurveyResult(
            String surveyNo
    ) {

        Map<String, Object> survey =
                iMngSurveyMapper.selectSurveyResult(surveyNo);

        List<Map<String, Object>> resultList =
                iMngSurveyMapper.selectSurveyResultList(surveyNo);

        survey.put("resultList", resultList);

        System.out.println("survey = " + survey);
        System.out.println("resultList = " + resultList);

        return survey;
    }



    @Override
    public String selectMySurveyResponse(
            String surveyNo,
            String userNo
    ) {

        return iMngSurveyMapper
                .selectMySurveyResponse(
                        surveyNo,
                        userNo
                );
    }

    @Override
    public void insertSurveyResponse(
            String surveyNo,
            String response,
            String userNo

    ) {

        iMngSurveyMapper.insertSurveyResponse(
                surveyNo,
                response,
                userNo
        );

        try {

            ObjectMapper objectMapper =
                    new ObjectMapper();

            List<Map<String, Object>> answerList =
                    objectMapper.readValue(
                            response,
                            new TypeReference<List<Map<String, Object>>>() {}
                    );

            System.out.println("answerList = " + answerList);

            for(Map<String, Object> answer : answerList){

                String qitemNm =
                        "Q" + answer.get("questionNo");

                String ansrCn =
                        String.valueOf(answer.get("answer"));

                System.out.println("qitemNm = " + qitemNm);
                System.out.println("ansrCn = " + ansrCn);

                int exists =
                        iMngSurveyMapper.existsSurveyResult(
                                surveyNo,
                                qitemNm,
                                ansrCn
                        );

                if(exists > 0){

                    iMngSurveyMapper.updateSurveyResultCount(
                            surveyNo,
                            qitemNm,
                            ansrCn
                    );

                } else {

                    iMngSurveyMapper.insertSurveyResult(
                            surveyNo,
                            qitemNm,
                            ansrCn
                    );
                }
            }

        } catch (Exception e){

            e.printStackTrace();
        }
    }

    @Override
    public boolean existsSurveyResponse(
            String surveyNo,
            String userNo
    ) {

        return iMngSurveyMapper.existsSurveyResponse(
                surveyNo,
                userNo
        ) > 0;
    }

    @Override
    public List<MngSurveyDTO> selectSurveyTypeList(
            String type
    ) {

        return iMngSurveyMapper
                .selectSurveyTypeList(type);
    }

    @Override
    public List<Map<String, Object>> selectSurveyStatistics(
            String surveyNo
    ) {

        return iMngSurveyMapper
                .selectSurveyStatistics(surveyNo);
    }
}
