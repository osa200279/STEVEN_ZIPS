package kr.or.ddit.domain.apt.mgmtOffice.main.service;

import kr.or.ddit.domain.apt.apiApartment.vo.AptHoTyVO;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface IMgmtAptHoTyService {
    List<AptHoTyVO> selectHoTypeList(String mgmtOfcNo);

    void insertHoType(String mgmtOfcNo, AptHoTyVO aptHoTyVO, MultipartFile imageFile);
}
