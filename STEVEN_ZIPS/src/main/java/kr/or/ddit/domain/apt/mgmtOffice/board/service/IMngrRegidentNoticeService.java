package kr.or.ddit.domain.apt.mgmtOffice.board.service;

import kr.or.ddit.domain.apt.mgmtOffice.board.dto.MngrRegidentNoticeDTO;
import kr.or.ddit.domain.member.vo.CustomUser;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface IMngrRegidentNoticeService {

    int selectNoticeCount(MngrRegidentNoticeDTO dto);

    List<MngrRegidentNoticeDTO> selectNoticeList(MngrRegidentNoticeDTO dto);

    MngrRegidentNoticeDTO selectNoticeDetail(MngrRegidentNoticeDTO dto);

    int insertNotice(MngrRegidentNoticeDTO dto, MultipartFile uploadFile) throws Exception;

    int updateNotice(MngrRegidentNoticeDTO dto);

    int deleteNotice(MngrRegidentNoticeDTO dto);

    void addManagerViewModel(Model model, CustomUser customUser, String mgmtOfcNo);

    void setManagerNoticeBaseInfo(
            MngrRegidentNoticeDTO dto,
            CustomUser customUser,
            String mgmtOfcNo
    );
}