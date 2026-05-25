package kr.or.ddit.domain.apt.mgmtOffice.main.service;

import kr.or.ddit.domain.apt.mgmtOffice.main.vo.AptScheduleCalendarDTO;

import java.util.List;

/**
 * 단지 일정 캘린더 Service 인터페이스
 * Service란? Controller와 Mapper 사이에서 업무 규칙을 처리하는 계층입니다.
 * 왜 사용? Controller는 요청/응답만 담당하고, 실제 업무 처리는 Service로 분리하기 위해 사용합니다.
 */
public interface IAptScheduleCalendarService {

    /** 월간 캘린더 일정 목록 조회 */
    List<AptScheduleCalendarDTO> selectScheduleCalendarList(AptScheduleCalendarDTO searchDTO);

    /** 일정 통계 조회 */
    AptScheduleCalendarDTO selectScheduleCalendarStat(AptScheduleCalendarDTO searchDTO);

    /** 관리사무소 직원 목록 조회 */
    List<AptScheduleCalendarDTO> selectManagerEmployeeList(String mgmtOfcNo);

    /** 직원 휴가 등록 */
    int insertVacationSchedule(AptScheduleCalendarDTO aptScheduleCalendarDTO);

    /** 직원 휴가 삭제 */
    int deleteVacationSchedule(AptScheduleCalendarDTO aptScheduleCalendarDTO);
}
