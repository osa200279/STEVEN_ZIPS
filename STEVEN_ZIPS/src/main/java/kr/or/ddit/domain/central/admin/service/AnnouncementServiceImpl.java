package kr.or.ddit.domain.central.admin.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.domain.central.admin.dto.AnnouncementDTO;
import kr.or.ddit.domain.central.admin.mapper.AnnouncementMapper;
import kr.or.ddit.domain.central.admin.service.IAnnouncementService;
import lombok.RequiredArgsConstructor;

/**
 * 공고 관리 Service 구현체
 *
 */
@Service
@RequiredArgsConstructor
public class AnnouncementServiceImpl implements IAnnouncementService {

    private final AnnouncementMapper announcementMapper;

    @Override
    public List<AnnouncementDTO> selectAnnouncementList(AnnouncementDTO searchVO) {
        return announcementMapper.selectAnnouncementList(searchVO);
    }

    @Override
    public AnnouncementDTO selectAnnouncement(String annNo) {
        return announcementMapper.selectAnnouncement(annNo);
    }

    @Override
    @Transactional
    public int insertAnnouncement(AnnouncementDTO announcementDTO) {
        return announcementMapper.insertAnnouncement(announcementDTO);
    }

    @Override
    @Transactional
    public int updateAnnouncement(AnnouncementDTO announcementDTO) {
        return announcementMapper.updateAnnouncement(announcementDTO);
    }

    @Override
    @Transactional
    public int deleteAnnouncement(String annNo) {
        return announcementMapper.deleteAnnouncement(annNo);
    }

    @Override
    public List<AnnouncementDTO> selectAptComplexList() {
        return announcementMapper.selectAptComplexList();
    }
}