package kr.or.ddit.domain.central.admin.service;

import java.util.List;

import kr.or.ddit.domain.central.admin.dto.AnnouncementDTO;

/**
 * 공고 관리 Service 인터페이스
 *
 */
public interface IAnnouncementService {

    List<AnnouncementDTO> selectAnnouncementList(AnnouncementDTO searchVO);

    AnnouncementDTO selectAnnouncement(String annNo);

    int insertAnnouncement(AnnouncementDTO announcementDTO);

    int updateAnnouncement(AnnouncementDTO announcementDTO);

    int deleteAnnouncement(String annNo);

    /*
      단지 목록 조회
    */
    List<AnnouncementDTO> selectAptComplexList();

}