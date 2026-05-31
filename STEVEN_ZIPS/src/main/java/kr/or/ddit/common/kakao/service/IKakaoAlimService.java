package kr.or.ddit.common.kakao.service;

import kr.or.ddit.common.kakao.vo.KakaoAlimVO;

import java.util.List;

public interface IKakaoAlimService {

    void sendReservationApproved(String userNo, String facilityNm, String rsvtDttm, String linkUrl);

    void sendReservationRejected(String userNo, String facilityNm, String reason, String linkUrl);

    void sendResidentApproved(String userNo, String linkUrl);

    List<KakaoAlimVO> getMyAlimList(String userNo);

    void readAlim(String alimNo, String userNo);
}