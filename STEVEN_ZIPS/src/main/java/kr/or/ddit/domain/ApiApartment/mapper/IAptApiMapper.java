package kr.or.ddit.domain.ApiApartment.mapper;


import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface IAptApiMapper {


    List<String> selectMapoLawdCdList();
}
