package kr.or.ddit.domain.member.resident.service;

import kr.or.ddit.domain.member.resident.vo.RsidBoardVO;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface IResidentBoardService {


    void insertBoardFree(RsidBoardVO rsidBoardVO);

    List<RsidBoardVO> boardFreeList(RsidBoardVO rsidBoardVO);
}
