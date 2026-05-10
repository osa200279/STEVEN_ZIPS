package kr.or.ddit.domain.member.resident.service;

import kr.or.ddit.domain.member.resident.vo.VisitRegisterDTO;
import kr.or.ddit.domain.member.vo.CustomUser;

import java.security.Principal;

public interface IResidentVstVhclService {
    void registerVisit(VisitRegisterDTO dto, CustomUser principal );
}
