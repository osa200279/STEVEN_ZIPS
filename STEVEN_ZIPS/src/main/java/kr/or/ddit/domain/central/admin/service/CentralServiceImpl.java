package kr.or.ddit.domain.central.admin.service;

import kr.or.ddit.common.api.google.service.GoogleDriveService;
import kr.or.ddit.common.file.mapper.IAttachFileMapper;
import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.central.admin.mapper.CentralMapper;
import kr.or.ddit.domain.central.admin.vo.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class CentralServiceImpl implements CentralService {


    private final CentralMapper mapper;


    @Override
    public int selectContractDocCount(PaginationInfoVO<ContractDocVO> pagingVO) {
        return mapper.selectContractDocCount(pagingVO);
    }

    @Override
    public List<ContractDocVO> selectContractDocList(PaginationInfoVO<ContractDocVO> pagingVO) {
        return mapper.selectContractDocList(pagingVO);
    }


    private final GoogleDriveService googleDriveService;
    private final IAttachFileMapper attachFileMapper;

    @Override
    public void insertContract(RentContractVO vo, MultipartFile[] files) throws Exception {

        // 1. 계약 INSERT
        mapper.insertContract(vo);

        // 2. 파일 업로드
        String[] cats = {"계약서", "신분증", "추가서류"};
        String folderPath = "contract/" + vo.getRentCtrtNo();

        long seq = attachFileMapper.getSeqFileGroupNo();
        String uuid = UUID.randomUUID().toString().replace("-", "");
        
        for (int i = 0; i < files.length; i++) {
            if (files[i] != null && !files[i].isEmpty()) {
                String savedFileName = uuid + "_" + files[i].getOriginalFilename();

                String googleId = googleDriveService.uploadFile(files[i], folderPath, savedFileName);

                AttachFileVO attachFile = AttachFileVO.fileSettings(
                        files[i], seq, cats[i], savedFileName, googleId, folderPath, i + 1
                );
                attachFileMapper.insertAttachFile(attachFile);
            }
        }
    }

    @Override
    public int selectContractCount(PaginationInfoVO<ContractVO> pagingVO) {
        return mapper.selectContractCount(pagingVO);
    }

    @Override
    public List<ContractVO> selectContractList(PaginationInfoVO<ContractVO> pagingVO) {
        return mapper.selectContractList(pagingVO);
    }

    @Override
    public ContractVO selectOneContract(String ctrtNo) {
        return mapper.selectOneContract(ctrtNo);
    }

    @Override
    public void updateContract(RentContractVO vo, MultipartFile[] files) throws Exception {
        mapper.updateContract(vo);

        String[] cats = {"계약서", "신분증", "추가서류"};
        String folderPath = "contract/" + vo.getRentCtrtNo();

        long seq = attachFileMapper.getSeqFileGroupNo();
        String uuid = UUID.randomUUID().toString().replace("-", "");

        for (int i = 0; i < files.length; i++) {
            if (files[i] != null && !files[i].isEmpty()) {

                String savedFileName = uuid + "_" + files[i].getOriginalFilename();

                String googleId = googleDriveService.uploadFile(files[i], folderPath, savedFileName);

                AttachFileVO attachFile = AttachFileVO.fileSettings(
                        files[i], seq, cats[i], savedFileName, googleId, folderPath, i + 1
                );
                attachFileMapper.insertAttachFile(attachFile);
            }
        }
    }

    @Override
    public void contractModifyStatus(String rentCtrtNo, String status) {
        mapper.contractModifyStatus(rentCtrtNo, status);
    }

    @Override
    public void insertContractForm(ContractFormVO contractFormVO, MultipartFile formFile) throws IOException {
        // 4. DB 시퀀스 채번 및 VO 생성
        long seq = attachFileMapper.getSeqFileGroupNo();

        // 2. 파일명 및 경로 생성 (로직 시연)
        contractFormVO.setFileNo(String.valueOf(seq));

        mapper.contractFormInsert(contractFormVO);

        String ContractNo = contractFormVO.getFrmNo();

        String uuid = UUID.randomUUID().toString().replace("-", "");
        String savedFileName = uuid + "_" + formFile.getOriginalFilename();
        String folderPath = "contract/" + "contractNo_"+ ContractNo;


        // 3. 구글 업로드 실행
        String googleId = googleDriveService.uploadFile(formFile, folderPath, savedFileName);

        AttachFileVO attachFile = AttachFileVO.fileSettings(
                formFile, seq, "서식", savedFileName, googleId, folderPath, 1
        );

        attachFileMapper.insertAttachFile(attachFile);


    }

    @Override
    public void deleteContractForm(String frmNo) {
        mapper.contractFormDelete(frmNo);
    }

    @Override
    public ContractFormVO selectOneContractForm(String frmNo) {
        return mapper.selectOneContractForm(frmNo);
    }

    @Override
    public void contractFormUpdate(ContractFormVO contractFormVO) {
        mapper.contractFormUpdate(contractFormVO);
    }

    @Override
    public List<ContractAptVO> contractForm(Model model) {
        return mapper.contractForm(model);
    }

    @Override
    public int selectContractFormCount(PaginationInfoVO<ContractFormVO> pagingVO) {
        return mapper.selectContractFormCount(pagingVO);
    }

    @Override
    public List<ContractFormVO> selectContractFormList(PaginationInfoVO<ContractFormVO> pagingVO) {
        return mapper.SelectContractFormList(pagingVO);
    }





}
