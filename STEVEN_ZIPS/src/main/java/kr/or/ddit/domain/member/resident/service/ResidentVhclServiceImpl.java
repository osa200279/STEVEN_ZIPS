package kr.or.ddit.domain.member.resident.service;

import kr.or.ddit.common.api.google.service.GoogleDriveService;
import kr.or.ddit.common.file.mapper.IAttachFileMapper;
import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.domain.member.resident.mapper.IResidentMapper;
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
    IResidentMapper residentMapper;

    @Autowired
    GoogleDriveService googleDriveService;

    @Autowired
    IAttachFileMapper attachFileMapper;


    @Override
    public List<RsidVhclVO> selectMyVhclList(String userNo, String aptCmplexNo) {

        return residentMapper.selectMyVhclList(userNo,aptCmplexNo);
    }

    public int countMyVhcl(String userNo, String hoNo) {
        return residentMapper.countMyVhcl(userNo, hoNo);
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

        long start = System.currentTimeMillis();

        log.info("===== 차량 등록 시작 =====");
        log.info("userNo: {}", userNo);

        // 1️⃣ HO_NO 조합
        String hoNo = aptCmplexNo + "_" + dong + "_" + ho;

        // 2️⃣ 차량번호 중복 체크
        long t1 = System.currentTimeMillis();
        if (residentMapper.existsVhclNo(vhclNo) > 0) {
            throw new RuntimeException("이미 등록된 차량번호입니다.");
        }
        log.info("중복 체크 시간: {} ms", (System.currentTimeMillis() - t1));

        // 3️⃣ 상태 결정
        String status = isExtra ? "WAIT" : "APRV";

        // 4️⃣ 파일 처리
        Long fileGroupNo = null;

        if (file != null && !file.isEmpty()) {

            long t2 = System.currentTimeMillis();

            fileGroupNo = attachFileMapper.getSeqFileGroupNo();
            String uuid = UUID.randomUUID().toString().replace("-", "");
            String path = "resident/vhcl/" + userNo;
            String savedFileName = uuid + "_" + file.getOriginalFilename();

            String googleId = googleDriveService.uploadFile(file, path, savedFileName);

            log.info("구글 업로드 시간: {} ms", (System.currentTimeMillis() - t2));

            long t3 = System.currentTimeMillis();

            AttachFileVO fileVO = AttachFileVO.fileSettings(
                    file,
                    fileGroupNo,
                    "vhcl",
                    savedFileName,
                    googleId,
                    path,
                    1
            );

            attachFileMapper.insertAttachFile(fileVO);

            log.info("파일 DB 저장 시간: {} ms", (System.currentTimeMillis() - t3));
        }

        // 5️⃣ 차량 VO
        RsidVhclVO vhcl = new RsidVhclVO();
        vhcl.setUserNo(userNo);
        vhcl.setVhclNm(vhclNm);
        vhcl.setVhclNo(vhclNo);
        vhcl.setHoNo(hoNo);
        vhcl.setVhclSttsCd(status);

        if (fileGroupNo != null) {
            vhcl.setVhclFileNo(String.valueOf(fileGroupNo));
        }

        // 6️⃣ 차량 insert
        long t4 = System.currentTimeMillis();
        residentMapper.insertVhcl(vhcl);
        log.info("차량 insert 시간: {} ms", (System.currentTimeMillis() - t4));

        log.info("===== 총 처리 시간: {} ms =====", (System.currentTimeMillis() - start));
    }
}
