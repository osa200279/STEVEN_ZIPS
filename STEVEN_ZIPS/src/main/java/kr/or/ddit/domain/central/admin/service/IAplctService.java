package kr.or.ddit.domain.central.admin.service;

import kr.or.ddit.domain.central.admin.dto.AplctDTO;

import java.util.List;

public interface IAplctService {

    List<AplctDTO> selectAplctList();

    int approveAplct(List<String> aplctNos, String aplctSttsCd);
}
