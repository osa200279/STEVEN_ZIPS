package kr.or.ddit.domain.apt.mgmtOffice.main.service;

import kr.or.ddit.domain.apt.apiApartment.vo.AptHoTyVO;
import kr.or.ddit.domain.apt.main.service.IAptComplexService;
import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import kr.or.ddit.domain.apt.mgmtOffice.main.mapper.IMgmtAptHoTyMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MgmtAptHoTyServiceImpl implements IMgmtAptHoTyService {

    @Autowired
    IAptComplexService aptComplexService;

    @Autowired
    IMgmtAptHoTyMapper hoTyMapper;

    @Override
    public List<AptHoTyVO> selectHoTypeList(String mgmtOfcNo) {

        AptComplexVO complex =
                aptComplexService.selectMgmtOfcNoAptComplex(mgmtOfcNo);

        if(complex == null){
            return List.of();
        }

        return hoTyMapper.selectHoTypeList(
                complex.getAptCmplexNo()
        );
    }

}
