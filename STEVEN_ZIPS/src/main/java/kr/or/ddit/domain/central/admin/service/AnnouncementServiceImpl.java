package kr.or.ddit.domain.central.admin.serviceImpl;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.domain.central.admin.mapper.AnnouncementMapper;
import kr.or.ddit.domain.central.admin.service.IAnnouncementService;
import kr.or.ddit.domain.central.admin.vo.AnnouncementVO;
import lombok.RequiredArgsConstructor;

/**
 * 공고 관리 Service 구현체
 *
 * Service란?
 * → Controller와 Mapper 사이에서 업무 로직을 처리하는 계층.
 */
@Service
@RequiredArgsConstructor
public class AnnouncementServiceImpl implements IAnnouncementService {

    private final AnnouncementMapper announcementMapper;

    @Override
    public List<AnnouncementVO> selectAnnouncementList(AnnouncementVO searchVO) {
        return announcementMapper.selectAnnouncementList(searchVO);
    }

    @Override
    public AnnouncementVO selectAnnouncement(String annNo) {
        return announcementMapper.selectAnnouncement(annNo);
    }

    @Override
    @Transactional
    public int insertAnnouncement(AnnouncementVO announcementVO) {
        return announcementMapper.insertAnnouncement(announcementVO);
    }

    @Override
    @Transactional
    public int updateAnnouncement(AnnouncementVO announcementVO) {
        return announcementMapper.updateAnnouncement(announcementVO);
    }

    @Override
    @Transactional
    public int deleteAnnouncement(String annNo) {
        return announcementMapper.deleteAnnouncement(annNo);
    }
}