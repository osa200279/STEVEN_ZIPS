package kr.or.ddit.common.sms.service;

import kr.or.ddit.common.sms.dto.SmsSendRequest;

/**
 * SMS 발송 서비스
 *
 * Service란?
 * 문자 발송과 발송 이력 저장 등의 비즈니스 로직을 처리하는 계층입니다.
 */
public interface ISmsService {

    /** SMS 발송 */
    void sendSms(SmsSendRequest request);

    /** 입주 승인 완료 문자 발송 */
    void sendResidentApproved(String userNo, String rgtrId);

    /** 예약 승인 완료 문자 발송 */
    void sendReservationApproved(
            String userNo,
            String facilityNm,
            String rsvtDttm,
            String rgtrId
    );

    /** 예약 거절 문자 발송 */
    void sendReservationRejected(
            String userNo,
            String facilityNm,
            String reason,
            String rgtrId
    );

//    /** 시설 점검 안내 문자 발송 */
//    void sendFacilityInspection(...);
//
//    /** 관리비 납부 안내 문자 발송 */
//    void sendMaintenanceFeeNotice(...);
//
//    /** 계약 만료 안내 문자 발송 */
//    void sendContractExpireNotice(...);

}