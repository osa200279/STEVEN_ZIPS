package kr.or.ddit.domain.central.admin.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.domain.central.admin.vo.AnnouncementVO;

@Mapper
public interface AnnouncementMapper {

    List<AnnouncementVO> selectAnnouncementList(AnnouncementVO searchVO);

    AnnouncementVO selectAnnouncement(String annNo);

    int insertAnnouncement(AnnouncementVO announcementVO);

    int updateAnnouncement(AnnouncementVO announcementVO);

    int deleteAnnouncement(String annNo);
}