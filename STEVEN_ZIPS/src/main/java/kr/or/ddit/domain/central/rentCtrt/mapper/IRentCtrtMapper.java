package kr.or.ddit.domain.central.rentCtrt.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.Map;

@Mapper
public interface IRentCtrtMapper {
    int insertRentCtrt(Map<String, Object> param);
}
