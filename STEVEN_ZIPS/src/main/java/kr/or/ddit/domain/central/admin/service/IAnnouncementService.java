package kr.or.ddit.domain.central.admin.service;

import java.util.List;

import kr.or.ddit.domain.central.admin.vo.AnnouncementVO;

public interface IAnnouncementService {

    List<AnnouncementVO> selectAnnouncementList(AnnouncementVO searchVO);

    AnnouncementVO selectAnnouncement(String annNo);

    int insertAnnouncement(AnnouncementVO announcementVO);

    int updateAnnouncement(AnnouncementVO announcementVO);

    int deleteAnnouncement(String annNo);
}