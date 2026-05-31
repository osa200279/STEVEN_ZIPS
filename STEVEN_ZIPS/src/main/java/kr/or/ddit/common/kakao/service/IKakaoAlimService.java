package kr.or.ddit.common.kakao.service;

import kr.or.ddit.common.kakao.vo.KakaoAlimVO;

import java.util.List;

public interface IKakaoAlimService {

    /**
     * 예약 승인 알림
     */
    void sendReservationApproved(
            String userNo,
            String facilityNm,
            String rsvtDttm,
            String linkUrl
    );

    /**
     * 예약 거절 알림
     */
    void sendReservationRejected(
            String userNo,
            String facilityNm,
            String reason,
            String linkUrl
    );

    /**
     * 예약 신청 완료 알림
     */
    void sendReservationRequested(
            String userNo,
            String facilityNm,
            String rsvtDttm,
            String linkUrl
    );

    /**
     * 예약 취소 완료 알림
     */
    void sendReservationCancelled(
            String userNo,
            String facilityNm,
            String rsvtDttm,
            String linkUrl
    );

    /**
     * 입주 승인 알림
     */
    void sendResidentApproved(String userNo, String linkUrl);

    /**
     * 내 알림 목록 조회
     */
    List<KakaoAlimVO> getMyAlimList(String userNo);

    /**
     * 알림 읽음 처리
     */
    void readAlim(String alimNo, String userNo);



}