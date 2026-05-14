package kr.or.ddit.domain.member.resident.service;

import kr.or.ddit.domain.member.resident.dto.ResidentNoticeBoardDTO;
import kr.or.ddit.domain.member.resident.mapper.IResidentNoticeBoardMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ResidentNoticeBoardServiceImpl implements IResidentNoticeBoardService {

    private final IResidentNoticeBoardMapper residentBoardNoticeMapper;

    @Override
    public int selectResidentBoardNoticeCount(ResidentNoticeBoardDTO searchDTO) {
        return residentBoardNoticeMapper.selectResidentBoardNoticeCount(searchDTO);
    }

    @Override
    public List<ResidentNoticeBoardDTO> selectResidentBoardNoticeList(ResidentNoticeBoardDTO searchDTO) {
        return residentBoardNoticeMapper.selectResidentBoardNoticeList(searchDTO);
    }

    @Override
    @Transactional
    public ResidentNoticeBoardDTO selectResidentBoardNoticeDetail(ResidentNoticeBoardDTO searchDTO) {

        /*
         * @Transactional
         * → 조회수 증가 + 상세조회가 하나의 작업처럼 처리되게 함.
         * 왜 사용?
         * → 중간에 오류가 나면 DB 상태가 어긋나는 것을 방지하기 위해.
         */
        residentBoardNoticeMapper.updateResidentBoardNoticeInqCnt(searchDTO);

        return residentBoardNoticeMapper.selectResidentBoardNoticeDetail(searchDTO);
    }
}