package kr.or.ddit.domain.central.admin.mapper;

import kr.or.ddit.domain.central.admin.dto.AplctDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface IAplctMapper {

    List<AplctDTO> selectAplctList();

    int updateAplctStatus(@Param("aplctNos") List<String> aplctNos, @Param("aplctSttsCd") String aplctSttsCd);
}
