package kr.or.ddit.domain.central.sales.mapper;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface IReactSalesMapper {
    List<String> selectBuildingList(String aptCmplexNo);
}
