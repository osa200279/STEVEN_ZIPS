package kr.or.ddit.domain.member.resident.service;

import kr.or.ddit.domain.member.resident.mapper.IVstVhclMapper;
import kr.or.ddit.domain.member.resident.vo.VisitRegisterDTO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.SimpleDateFormat;

@Service
@Transactional
@Slf4j
public class ResidentVstVhclServiceImpl implements IResidentVstVhclService{

    @Autowired
    IVstVhclMapper vstVhclMapper;

    @Override
    public void registerVisit(VisitRegisterDTO dto, String userNo) {
        String visitDateTime = dto.getVisitDate() + " "
                + dto.getVisitHour() + ":00";

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd HH:mm:ss");

    }
}
