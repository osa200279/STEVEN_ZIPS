package kr.or.ddit.domain.central.service;

import kr.or.ddit.common.api.google.service.GoogleDriveService;
import kr.or.ddit.common.file.mapper.IAttachFileMapper;
import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.domain.central.mapper.IContractUserMapper;
import kr.or.ddit.domain.central.vo.ContractUserVO;
import kr.or.ddit.domain.central.vo.RentCtrtVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Slf4j
@Service
public class ContractUserServiceImpl implements IContractUserService {

    @Autowired
    private IContractUserMapper contractUserMapper;

    @Override
    public List<Map<String, Object>> selectAplctList(String userNo) {
        return contractUserMapper.selectAplctList(userNo);
    }

    @Override
    public void cancelContract(String aplctNo) {
        contractUserMapper.cancelContract(aplctNo);
    }

    @Autowired
    private GoogleDriveService googleDriveService;

    @Autowired
    private IAttachFileMapper iAttachFileMapper;

    @Transactional
    @Override
    public void insertContractDoc(MultipartFile[] contractDocFile, List<String> docTypeList, String userNo) throws IOException {
        // 1. userNo로 rentCtrtNo 조회
        String rentCtrtNo = contractUserMapper.selectRentCtrtNo(userNo);

        for (int i = 0; i < contractDocFile.length; i++) {
            MultipartFile file = contractDocFile[i];
            if (file != null && !file.isEmpty()) {
                // 2. 파일명 만들기
                String uuid = UUID.randomUUID().toString().replace("-", "");
                String savedFileName = uuid + "_" + file.getOriginalFilename();
                // 3. 저장 경로 설정
                String folderPath = "contract/doc/" + userNo;
                String fullPath = folderPath + "/" + savedFileName;
                // 4. 구글 드라이브 업로드
                String googleId = googleDriveService.uploadFile(file, folderPath, savedFileName);
                long seq = iAttachFileMapper.getSeqFileGroupNo();
                AttachFileVO attachFileVO = AttachFileVO.fileSettings(
                        file, seq, "contract_doc", savedFileName, googleId, fullPath, 1
                );
                // 5. 파일 정보 DB 저장
                iAttachFileMapper.insertAttachFile(attachFileVO);

                // 6. SbmsnDoc insert
                ContractUserVO contractUserVO = new ContractUserVO();
                contractUserVO.setSbmsnDocTyCd(docTypeList.get(i));
                contractUserVO.setSbmsnDocSttsCd("SUBMIT");
                contractUserVO.setAtchFileId(String.valueOf(attachFileVO.getFileGroupNo()));
                contractUserVO.setRentCtrtNo(rentCtrtNo);
                contractUserMapper.insertContractDoc(contractUserVO);
            }
        }
    }

    @Override
    public List<ContractUserVO> selectContractDoc(String userNo) {
        return contractUserMapper.selectContractDoc(userNo);
    }

    @Transactional
    @Override
    public void insertRentCtrt(RentCtrtVO rentCtrtVO) {
        log.info("aptCmplexNo: {}", rentCtrtVO.getAptCmplexNo());
        // 단지번호로 매물번호 조회
        String rentLstgNo = contractUserMapper.selectRentLstgNo(rentCtrtVO.getAptCmplexNo());
        log.info("rentLstgNo: {}", rentLstgNo);
        rentCtrtVO.setRentLstgNo(rentLstgNo);
        // ctrt_id는 rentCtrtNo와 동일하게 세팅 (selectKey 실행 후)
        contractUserMapper.insertRentCtrtVO(rentCtrtVO);
        rentCtrtVO.setCtrtId(rentCtrtVO.getRentCtrtNo());
    }

    @Transactional
    @Override
    public void updateInqCnt(String annNo) {
        contractUserMapper.updateInqCnt(annNo);
    }

    @Override
    public List<Map<String, Object>> selectExcluseAreaDetail(String aptCmplexNo) {
        return contractUserMapper.selectExcluseAreaDetail(aptCmplexNo);
    }

    @Transactional
    @Override
    public void insertAplct(Map<String, Object> params) {
        log.info("params: {}", params);
        String hoTyNo = contractUserMapper.selectHoTyNo(params);
        log.info("hoTyNo: {}", hoTyNo);
        params.put("hoTyNo", hoTyNo);
        contractUserMapper.insertAplct(params);
    }


}