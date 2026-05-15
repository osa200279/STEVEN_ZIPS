package kr.or.ddit.domain.apt.mgmtOffice.board.service;

import kr.or.ddit.domain.apt.mgmtOffice.board.dto.mngrRegidentNoticeDTO;
import kr.or.ddit.domain.member.vo.CustomUser;
import org.springframework.ui.Model;

import java.util.List;

public interface ImngrRegidentNoticeService {

    public int selectNoticeCount(mngrRegidentNoticeDTO dto);

    public List<mngrRegidentNoticeDTO> selectNoticeList(mngrRegidentNoticeDTO dto);

    public mngrRegidentNoticeDTO selectNoticeDetail(String annNo);

    public int insertNotice(mngrRegidentNoticeDTO dto);

    public int updateNotice(mngrRegidentNoticeDTO dto);

    public int deleteNotice(String annNo);

    void addManagerViewModel(Model model, CustomUser customUser, String mgmtOfcNo);

}