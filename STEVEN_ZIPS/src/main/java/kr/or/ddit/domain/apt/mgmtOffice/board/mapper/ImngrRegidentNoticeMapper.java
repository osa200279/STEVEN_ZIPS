package kr.or.ddit.domain.apt.mgmtOffice.board.mapper;

import kr.or.ddit.domain.apt.mgmtOffice.board.dto.MngrRegidentNoticeDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface ImngrRegidentNoticeMapper {

    int selectNoticeCount(MngrRegidentNoticeDTO dto);

    List<MngrRegidentNoticeDTO> selectNoticeList(MngrRegidentNoticeDTO dto);

    MngrRegidentNoticeDTO selectNoticeDetail(MngrRegidentNoticeDTO dto);

    int insertNotice(MngrRegidentNoticeDTO dto);

    int selectAttachFileGroupNo();

    int insertAttachFile(MngrRegidentNoticeDTO fileDTO);

    int updateNotice(MngrRegidentNoticeDTO dto);

    int deleteNotice(MngrRegidentNoticeDTO dto);

    String selectAptCmplexNoByMgmtOfcNo(String mgmtOfcNo);

    String selectNoticeBoardNoByAptCmplexNo(String aptCmplexNo);

    String selectNoticeWriterName(Map<String, Object> paramMap);

    int updateNoticeAttachFileId(MngrRegidentNoticeDTO dto);

    /*
     * 공지사항 첨부파일 목록 조회
     */
    List<MngrRegidentNoticeDTO> selectNoticeAttachFileList(MngrRegidentNoticeDTO dto);

    int deleteAttachFileByGoogleId(String googleId);





}