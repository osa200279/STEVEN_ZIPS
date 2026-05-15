package kr.or.ddit.domain.apt.mgmtOffice.board.service;

import kr.or.ddit.domain.apt.mgmtOffice.board.dto.mngrRegidentNoticeDTO;
import kr.or.ddit.domain.apt.mgmtOffice.board.mapper.ImngrRegidentNoticeMapper;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import java.util.List;

@Service
@RequiredArgsConstructor
public class mngrRegidentNoticeServiceImpl implements ImngrRegidentNoticeService {

    private final ImngrRegidentNoticeMapper mapper;

    @Override
    public int selectNoticeCount(mngrRegidentNoticeDTO dto) {
        return mapper.selectNoticeCount(dto);
    }

    @Override
    public List<mngrRegidentNoticeDTO> selectNoticeList(mngrRegidentNoticeDTO dto) {
        return mapper.selectNoticeList(dto);
    }

    @Override
    public mngrRegidentNoticeDTO selectNoticeDetail(String annNo) {
        return mapper.selectNoticeDetail(annNo);
    }

    @Override
    public int insertNotice(mngrRegidentNoticeDTO dto) {
        /*
         * 체크박스 미선택 시 null 방지.
         */
        if(dto.getTopFixYn() == null) {
            dto.setTopFixYn("N");
        }
        return mapper.insertNotice(dto);
    }

    @Override
    public int updateNotice(mngrRegidentNoticeDTO dto) {
        if(dto.getTopFixYn() == null) {
            dto.setTopFixYn("N");
        }
        return mapper.updateNotice(dto);
    }

    @Override
    public int deleteNotice(String annNo) {
        return mapper.deleteNotice(annNo);
    }

    @Override
    public void addManagerViewModel(Model model, CustomUser customUser, String mgmtOfcNo) {

        String aptCmplexNo = mapper.selectAptCmplexNoByMgmtOfcNo(mgmtOfcNo);
        String boardNo = mapper.selectNoticeBoardNoByAptCmplexNo(aptCmplexNo);

        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        model.addAttribute("aptCmplexNo", aptCmplexNo);
        model.addAttribute("boardNo", boardNo);
        model.addAttribute("loginUserId", customUser.getMember().getUserId());

        /*
         * boardNo
         * → 공지글이 어느 게시판 소속인지 저장하는 값.
         * 왜 필요?
         * → 입주민 공지 조회 SQL이 board_no로 연결해서 가져오기 때문.
         */
    }
}