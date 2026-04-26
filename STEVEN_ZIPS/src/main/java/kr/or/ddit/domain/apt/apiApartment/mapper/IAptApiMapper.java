package kr.or.ddit.domain.apt.apiApartment.mapper;


import kr.or.ddit.domain.apt.apiApartment.vo.AptComplexEntity;
import kr.or.ddit.domain.apt.apiApartment.vo.AptInfraEntity;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;


@Mapper
public interface IAptApiMapper {


    List<String> selectMapoLawdCdList();

    void insertAptOne(AptComplexEntity apt);

    void insertInfraOne(AptInfraEntity infra);
}
