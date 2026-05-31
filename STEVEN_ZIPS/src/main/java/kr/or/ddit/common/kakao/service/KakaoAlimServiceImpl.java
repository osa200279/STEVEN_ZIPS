package kr.or.ddit.common.kakao.service;

import kr.or.ddit.common.kakao.mapper.IKakaoAlimMapper;
import kr.or.ddit.common.kakao.vo.KakaoAlimVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 카카오 스타일 알림 서비스
 *
 * Service란?
 * 실제 업무 로직을 처리하는 계층입니다.
 *
 * 왜 사용?
 * Controller가 DB 저장 방법을 직접 알지 않게 분리하기 위해 사용합니다.
 */
@Service
@RequiredArgsConstructor
public class KakaoAlimServiceImpl implements IKakaoAlimService {

    private final IKakaoAlimMapper mapper;

    @Override
    @Transactional
    public void sendReservationApproved(String userNo, String facilityNm, String rsvtDttm, String linkUrl) {
        KakaoAlimVO vo = new KakaoAlimVO();

        vo.setAlimNo(mapper.selectNextAlimNo());
        vo.setUserNo(userNo);
        vo.setAlimTyCd("RSVT_APPROVED");
        vo.setAlimTtl("편의시설 예약 승인");
        vo.setAlimCn("[STEVEN_ZIPS]\n" + facilityNm + " 예약이 승인되었습니다.\n예약일시: " + rsvtDttm);
        vo.setLinkUrl(linkUrl);
        vo.setRgtrId("SYSTEM");

        mapper.insertKakaoAlim(vo);
    }

    @Override
    @Transactional
    public void sendReservationRejected(String userNo, String facilityNm, String reason, String linkUrl) {
        KakaoAlimVO vo = new KakaoAlimVO();

        vo.setAlimNo(mapper.selectNextAlimNo());
        vo.setUserNo(userNo);
        vo.setAlimTyCd("RSVT_REJECTED");
        vo.setAlimTtl("편의시설 예약 거절");
        vo.setAlimCn("[STEVEN_ZIPS]\n" + facilityNm + " 예약이 거절되었습니다.\n사유: " + reason);
        vo.setLinkUrl(linkUrl);
        vo.setRgtrId("SYSTEM");

        mapper.insertKakaoAlim(vo);
    }

    @Override
    @Transactional
    public void sendResidentApproved(String userNo, String linkUrl) {
        KakaoAlimVO vo = new KakaoAlimVO();

        vo.setAlimNo(mapper.selectNextAlimNo());
        vo.setUserNo(userNo);
        vo.setAlimTyCd("RESIDENT_APPROVED");
        vo.setAlimTtl("입주 승인 완료");
        vo.setAlimCn("[STEVEN_ZIPS]\n입주 신청이 승인되었습니다.\n입주민 서비스를 이용하실 수 있습니다.");
        vo.setLinkUrl(linkUrl);
        vo.setRgtrId("SYSTEM");

        mapper.insertKakaoAlim(vo);
    }

    @Override
    public List<KakaoAlimVO> getMyAlimList(String userNo) {
        return mapper.selectMyKakaoAlimList(userNo);
    }

    @Override
    @Transactional
    public void readAlim(String alimNo, String userNo) {
        mapper.updateReadYn(alimNo, userNo);
    }
}