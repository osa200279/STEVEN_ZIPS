package kr.or.ddit.domain.apt.mgmtOffice.main.service;

import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.domain.apt.apiApartment.vo.AptHoTyVO;
import kr.or.ddit.domain.apt.main.service.IAptComplexService;
import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import kr.or.ddit.domain.apt.mgmtOffice.main.mapper.IMgmtAptHoTyMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

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

    @Override
    public void insertHoType(
            String mgmtOfcNo,
            AptHoTyVO aptHoTyVO,
            MultipartFile imageFile
    ) {

        // 1. 단지 조회
        AptComplexVO complex =
                aptComplexService.selectMgmtOfcNoAptComplex(mgmtOfcNo);

        if(complex == null){
            throw new RuntimeException("단지 정보가 없습니다.");
        }

        // 2. 단지번호 세팅
        aptHoTyVO.setAptCmplexNo(
                complex.getAptCmplexNo()
        );

        // 3. 이미지 업로드
/*        if(imageFile != null && !imageFile.isEmpty()){

            AttachFileVO attachFileVO =
                    attachFileService.uploadSingleFile(
                            imageFile,
                            "apt-ho-type"
                    );

            aptHoTyVO.setImageFileNo(
                    attachFileVO.getFileGroupNo()
            );
        }

        // 4. insert
        hoTyMapper.insertHoType(aptHoTyVO);*/

    }


}
