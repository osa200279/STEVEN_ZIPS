package kr.or.ddit.domain.central.rentCtrt.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface IRentCtrtMapper {

    int insertRentCtrt(@Param("param") List<Map<String, Object>> param);

    int insertCtrtMgr(@Param("param") List<Map<String, Object>> qualifiedList, @Param("manager") String manager);

    String getNextRentCtrtSeq();

    List<Map<String, Object>> selectCtrt(@Param("startRow") int startRow,@Param("endRow") int endRow);

    int selectCtrtCount(@Param("userNo") String userNo);

    @SuppressWarnings("MyBatisMapperMethod") // 인텔리제이 마이바티스 검사 무시
    Map<String, Object> selectCtrtDashboard();
}
