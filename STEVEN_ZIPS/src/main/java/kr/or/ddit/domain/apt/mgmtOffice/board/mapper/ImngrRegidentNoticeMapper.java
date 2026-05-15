package kr.or.ddit.domain.apt.mgmtOffice.board.mapper;

import kr.or.ddit.domain.apt.mgmtOffice.board.dto.mngrRegidentNoticeDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ImngrRegidentNoticeMapper {

    public int selectNoticeCount(mngrRegidentNoticeDTO dto);

    public List<mngrRegidentNoticeDTO> selectNoticeList(mngrRegidentNoticeDTO dto);

    public mngrRegidentNoticeDTO selectNoticeDetail(String annNo);

    public int insertNotice(mngrRegidentNoticeDTO dto);

    public int updateNotice(mngrRegidentNoticeDTO dto);

    public int deleteNotice(String annNo);

    String selectAptCmplexNoByMgmtOfcNo(String mgmtOfcNo);

    String selectNoticeBoardNoByAptCmplexNo(String aptCmplexNo);
}