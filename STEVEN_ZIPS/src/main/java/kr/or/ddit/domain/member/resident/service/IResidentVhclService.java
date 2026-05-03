package kr.or.ddit.domain.member.resident.service;

import kr.or.ddit.domain.member.resident.vo.RsidVhclVO;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface IResidentVhclService {
    List<RsidVhclVO> selectMyVhclList(String userNo, String aptCmplexNo);

    void registerVhcl(RsidVhclVO vo, MultipartFile file);

    void requestExtraVhcl(RsidVhclVO vo, MultipartFile file);
}
