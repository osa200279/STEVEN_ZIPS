package kr.or.ddit.domain.central.rentCtrt.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.security.core.parameters.P;

import java.util.List;
import java.util.Map;

@Mapper
public interface IRentCtrtMapper {

    int insertRentCtrt(@Param("param") List<Map<String, Object>> param);

    int insertCtrtMgr(@Param("param") List<Map<String, Object>> qualifiedList, @Param("manager") String manager);

    String getNextRentCtrtSeq();

    List<Map<String, Object>> selectCtrt(String userNo);
}
