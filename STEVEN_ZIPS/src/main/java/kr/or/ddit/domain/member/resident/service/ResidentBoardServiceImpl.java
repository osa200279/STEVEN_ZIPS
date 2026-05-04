package kr.or.ddit.domain.member.resident.service;

import kr.or.ddit.domain.member.resident.mapper.IResidentBoardMapper;
import kr.or.ddit.domain.member.resident.vo.RsidBoardVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ResidentBoardServiceImpl implements IResidentBoardService {

    private final IResidentBoardMapper mapper;

    @Override
    public void insertBoardFree(RsidBoardVO rsidBoardVO) {
        mapper.insertBoardFree(rsidBoardVO);
    }

    @Override
    public List<RsidBoardVO> boardFreeList(RsidBoardVO rsidBoardVO) {
        return mapper.boardFreeList(rsidBoardVO);
    }
}
