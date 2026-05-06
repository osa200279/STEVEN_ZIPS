package kr.or.ddit.domain.central.admin.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.domain.central.admin.vo.AnnouncementVO;

/**
 * 공고 관리 Mapper
 *
 */
@Mapper
public interface AnnouncementMapper {

    /**
     * 공고 목록 조회
     */
    List<AnnouncementVO> selectAnnouncementList(AnnouncementVO searchVO);

    /**
     * 공고 상세 조회
     */
    AnnouncementVO selectAnnouncement(String annNo);

    /**
     * 공고 등록
     */
    int insertAnnouncement(AnnouncementVO announcementVO);

    /**
     * 공고 수정
     */
    int updateAnnouncement(AnnouncementVO announcementVO);

    /**
     * 공고 삭제
     * 실제 DELETE가 아니라 DEL_YN = 'Y'로 숨김 처리한다.
     */
    int deleteAnnouncement(String annNo);
}