package kr.or.ddit.domain.member.resident.service;

import kr.or.ddit.common.api.google.service.GoogleDriveService;
import kr.or.ddit.common.file.mapper.IAttachFileMapper;
import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.domain.member.resident.mapper.IVhclMapper;
import kr.or.ddit.domain.member.resident.vo.RsidVhclVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

@Service
@Transactional
@Slf4j
public class ResidentVhclServiceImpl implements IResidentVhclService {

    @Autowired
    IVhclMapper vhclMapper;

    @Autowired
    GoogleDriveService googleDriveService;

    @Autowired
    IAttachFileMapper attachFileMapper;


    @Override
    public List<RsidVhclVO> selectMyVhclList(String userNo, String aptCmplexNo) {

        return vhclMapper.selectMyVhclList(userNo,aptCmplexNo);
    }

    public boolean isExtraRequired(String userNo, String aptCmplexNo, String hoNo) {

        int freeCnt = vhclMapper.selectFreePkgCnt(aptCmplexNo);

        int currentCnt = vhclMapper.countMyVhcl(userNo, hoNo);

        return currentCnt >= freeCnt;
    }

    public void deleteVhcl(String rsidVhclNo, String userNo) {

        vhclMapper.deleteVhcl(rsidVhclNo,userNo);
    }

    @Transactional
    public void registerVhcl(
            String userNo,
            String aptCmplexNo,
            String vhclNm,
            String vhclNo,
            String dong,
            String ho,
            boolean isExtra,
            MultipartFile file
    ) throws IOException {

        //HO_NO 조합
        String hoNo = aptCmplexNo + "_" + dong + "_" + ho;

        //차량번호 중복 체크
        if (vhclMapper.existsVhclNo(vhclNo)>0) {
            throw new RuntimeException("이미 등록된 차량번호입니다.");
        }

        //상태 결정
        String status = isExtra ? "WAIT" : "APRV";

        //파일 처리
        Long fileGroupNo = null;

        if (file != null && !file.isEmpty()) {

            fileGroupNo = attachFileMapper.getSeqFileGroupNo();
            String uuid = UUID.randomUUID().toString().replace("-","");
            String path = "resident/vhcl/"+userNo;
            String savedFileName = uuid + "_" + file.getOriginalFilename();

            String googleId = googleDriveService.uploadFile(file,path,savedFileName);

            //AttachFileVO 생성
            AttachFileVO fileVO = AttachFileVO.fileSettings(
                    file
                    ,fileGroupNo
                    ,"vhcl"
                    ,savedFileName
                    ,googleId
                    ,path
                    ,1
            );

            attachFileMapper.insertAttachFile(fileVO);
        }

        // 차량 VO
        RsidVhclVO vhcl = new RsidVhclVO();
        vhcl.setUserNo(userNo);
        vhcl.setVhclNm(vhclNm);
        vhcl.setVhclNo(vhclNo);
        vhcl.setHoNo(hoNo);
        vhcl.setVhclSttsCd(status);
        if(fileGroupNo != null) {
            vhcl.setVhclFileNo(String.valueOf(fileGroupNo));
        }
        //insert 진행!
        vhclMapper.insertVhcl(vhcl);
    }

}
