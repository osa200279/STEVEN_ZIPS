package kr.or.ddit.domain.apiApartment.mapper;


import kr.or.ddit.domain.apiApartment.vo.AptComplexEntity;
import kr.or.ddit.domain.apiApartment.vo.AptInfraEntity;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;


@Mapper
public interface IAptApiMapper {


    List<String> selectMapoLawdCdList();

    void insertInfraBatch(List<AptInfraEntity> list);

    void insertAptBatch(List<AptComplexEntity> list);
}
