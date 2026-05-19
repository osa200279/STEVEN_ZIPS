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

    /**
     * 관리사무소 공지사항 등록
     * @author 김보라
     * @param dto 등록할 공지사항 정보
     * @return 등록 처리 건수
     */
    int insertNotice(MngrRegidentNoticeDTO dto);
}