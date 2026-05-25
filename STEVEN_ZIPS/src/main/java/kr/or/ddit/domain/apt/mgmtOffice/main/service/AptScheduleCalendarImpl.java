package kr.or.ddit.domain.apt.mgmtOffice.main.service;

import kr.or.ddit.domain.apt.mgmtOffice.main.mapper.IAptScheduleCalendarMapper;
import kr.or.ddit.domain.apt.mgmtOffice.main.vo.AptScheduleCalendarDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.YearMonth;
import java.util.List;

/**
 * 단지 일정 캘린더 Service 구현체
 * 구현체란? 인터페이스에 선언한 기능을 실제로 동작하게 만드는 클래스입니다.
 */
@Service
@RequiredArgsConstructor
public class AptScheduleCalendarImpl implements IAptScheduleCalendarService {

    private final IAptScheduleCalendarMapper aptScheduleCalendarMapper;

    @Override
    public List<AptScheduleCalendarDTO> selectScheduleCalendarList(AptScheduleCalendarDTO searchDTO) {
        setSearchDefault(searchDTO);
        return aptScheduleCalendarMapper.selectScheduleCalendarList(searchDTO);
    }

    @Override
    public AptScheduleCalendarDTO selectScheduleCalendarStat(AptScheduleCalendarDTO searchDTO) {
        setSearchDefault(searchDTO);
        AptScheduleCalendarDTO statDTO = aptScheduleCalendarMapper.selectScheduleCalendarStat(searchDTO);
        return statDTO == null ? new AptScheduleCalendarDTO() : statDTO;
    }

    @Override
    public List<AptScheduleCalendarDTO> selectManagerEmployeeList(String mgmtOfcNo) {
        return aptScheduleCalendarMapper.selectManagerEmployeeList(mgmtOfcNo);
    }

    @Override
    @Transactional
    public int insertVacationSchedule(AptScheduleCalendarDTO aptScheduleCalendarDTO) {
        /*
         * @Transactional이란? SQL 여러 개를 하나의 작업 단위로 묶는 기능입니다.
         * 왜 사용? 중간에 오류가 나면 전체 작업을 취소해서 DB 데이터가 꼬이지 않게 하기 위해 사용합니다.
         */
        if (aptScheduleCalendarDTO.getScheduleNo() == null || aptScheduleCalendarDTO.getScheduleNo().isBlank()) {
            aptScheduleCalendarDTO.setScheduleNo(aptScheduleCalendarMapper.selectNextVacationScheduleNo());
        }
        return aptScheduleCalendarMapper.insertVacationSchedule(aptScheduleCalendarDTO);
    }

    @Override
    @Transactional
    public int deleteVacationSchedule(AptScheduleCalendarDTO aptScheduleCalendarDTO) {
        return aptScheduleCalendarMapper.deleteVacationSchedule(aptScheduleCalendarDTO);
    }

    /** 월 검색 시작일/종료일 기본값 세팅 */
    private void setSearchDefault(AptScheduleCalendarDTO searchDTO) {
        if (searchDTO.getAptCmplexNo() == null || searchDTO.getAptCmplexNo().isBlank()) {
            String aptCmplexNo = aptScheduleCalendarMapper.selectAptCmplexNoByMgmtOfcNo(searchDTO.getMgmtOfcNo());
            searchDTO.setAptCmplexNo(aptCmplexNo);
        }

        if (searchDTO.getMonthStartDt() == null || searchDTO.getMonthStartDt().isBlank()
                || searchDTO.getMonthEndDt() == null || searchDTO.getMonthEndDt().isBlank()) {
            YearMonth thisMonth = YearMonth.from(LocalDate.now());
            searchDTO.setMonthStartDt(thisMonth.atDay(1).toString());
            searchDTO.setMonthEndDt(thisMonth.atEndOfMonth().toString());
        }
    }
}
