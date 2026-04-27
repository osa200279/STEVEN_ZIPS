package kr.or.ddit.domain.central.contract.service;

import kr.or.ddit.common.api.google.service.GoogleDriveService;
import kr.or.ddit.common.file.mapper.IAttachFileMapper;
import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.domain.central.contract.mapper.ContractMapper;
import kr.or.ddit.domain.central.contract.vo.ContractVO;
import kr.or.ddit.domain.central.contract.vo.PaginationInfoVO;
import kr.or.ddit.domain.central.contract.vo.RentContractVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ContractServiceImpl implements ContractService {

    private final ContractMapper mapper;
    private final GoogleDriveService googleDriveService;
    private final IAttachFileMapper attachFileMapper;

    @Override
    public void insertContract(RentContractVO vo, MultipartFile[] files) throws Exception {
        // 1. 계약 INSERT
        mapper.insertContract(vo);

        // 2. 파일 업로드
        String[] cats = {"계약서", "신분증", "추가서류"};
        String folderPath = "contract/" + vo.getRentCtrtNo();

        for (int i = 0; i < files.length; i++) {
            if (files[i] != null && !files[i].isEmpty()) {
                String uuid = UUID.randomUUID().toString().replace("-", "");
                String savedFileName = uuid + "_" + files[i].getOriginalFilename();

                String googleId = googleDriveService.uploadFile(files[i], folderPath, savedFileName);

                long seq = attachFileMapper.seqNextVal();
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
    public ContractVO selectContractDeatil(String ctrtNo) {
        return mapper.selectContractDetail(ctrtNo);
    }


}
