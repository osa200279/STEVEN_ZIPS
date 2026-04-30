package kr.or.ddit.domain.central.board.mapper;

import kr.or.ddit.domain.central.board.vo.NoticeVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface INoticeMapper {


    List<NoticeVO> selectNoticeList();

    NoticeVO selectNoticeDetail(String annNo);
}

