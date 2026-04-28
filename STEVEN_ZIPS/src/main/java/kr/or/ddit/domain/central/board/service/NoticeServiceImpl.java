package kr.or.ddit.domain.central.board.service;

import kr.or.ddit.domain.central.board.mapper.INoticeMapper;
import kr.or.ddit.domain.central.board.vo.NoticeVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Slf4j
@Service
public class NoticeServiceImpl  implements INoticeService {

    @Autowired
    private INoticeMapper noticeMapper;

    @Override
    public List<NoticeVO> getNoticeList() {

        return noticeMapper.selectNoticeList();
    }
}
