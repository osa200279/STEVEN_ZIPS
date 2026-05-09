package kr.or.ddit.domain.member.resident.service;

import kr.or.ddit.domain.member.resident.vo.VisitRegisterDTO;

public interface IResidentVstVhclService {
    void registerVisit(VisitRegisterDTO dto, String userNo);
}
