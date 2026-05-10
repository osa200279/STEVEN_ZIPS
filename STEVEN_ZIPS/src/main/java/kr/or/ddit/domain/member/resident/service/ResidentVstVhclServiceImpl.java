package kr.or.ddit.domain.member.resident.service;

import kr.or.ddit.domain.member.resident.mapper.IVstVhclMapper;
import kr.or.ddit.domain.member.resident.vo.MyAptVO;
import kr.or.ddit.domain.member.resident.vo.ResidentVO;
import kr.or.ddit.domain.member.resident.vo.VisitRegisterDTO;
import kr.or.ddit.domain.member.resident.vo.VstVhclRsvtVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.SimpleDateFormat;
import java.util.Date;

@Service
@Transactional
@Slf4j
public class ResidentVstVhclServiceImpl implements IResidentVstVhclService{

    @Autowired
    IVstVhclMapper vstVhclMapper;

    @Override
    public void registerVisit(
            VisitRegisterDTO dto
            ,CustomUser principal ) {

        try {

            String visitDateTime =
                    dto.getVisitDate()
                            + " "
                            + dto.getVisitHour()
                            + ":00";

            SimpleDateFormat sdf =
                    new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

            Date vstYmd = sdf.parse(visitDateTime);

            ResidentVO resident =
                    (ResidentVO) principal.getMember();

            MyAptVO myApt =
                    resident.getMyAptList().get(0);

            String hoNo =
                    myApt.getAptCmplexNo()
                            + "_"
                            + myApt.getDongNm()
                            + "_"
                            + myApt.getHo();

            VstVhclRsvtVO vo =
                    new VstVhclRsvtVO();

            vo.setVstVhclTyCd(dto.getVstVhclTyCd());
            vo.setVstVhclNo(dto.getVstVhclNo());
            vo.setVstrNm(dto.getVstrNm());

            vo.setVstYmd(vstYmd);

            vo.setStayHr(dto.getStayHr());

            vo.setVstSttsCd("WAIT");

            vo.setVstPrpsCn(dto.getVstPrpsCn());

            vo.setUserNo(resident.getUserNo());

            vo.setHoNo(hoNo);

/*            vstVhclMapper.insertVisitReservation(vo);*/

        } catch (Exception e) {

            log.error("방문예약 등록 실패", e);

            throw new RuntimeException("방문예약 등록 실패");
        }
    }
}
