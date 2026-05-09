package kr.or.ddit.domain.apt.board.free.service;

import kr.or.ddit.common.api.google.service.GoogleDriveService;
import kr.or.ddit.common.file.mapper.IAttachFileMapper;
import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.board.free.mapper.IResidentBoardMapper;
import kr.or.ddit.domain.apt.board.free.vo.RsidBoardCommentVO;
import kr.or.ddit.domain.apt.board.free.vo.RsidBoardVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ResidentBoardServiceImpl implements IResidentBoardService {

    private final IResidentBoardMapper mapper;
    private final GoogleDriveService googleDriveService;
    private final IAttachFileMapper iAttachFileMapper;

    @Override
    public List<RsidBoardCommentVO> boardFreeComment(String postNo) {
        return mapper.boardFreeComment(postNo);
    }

    @Transactional
    @Override
    public int updateBoardComment(RsidBoardCommentVO rsidBoardCommentVO) {
        return mapper.updateBoardComment(rsidBoardCommentVO);
    }

    @Transactional
    @Override
    public int deleteBoardComment(String cmtNo) {
        return mapper.deleteBoardComment(cmtNo);
    }

    @Override
    public int insertSubComment(RsidBoardCommentVO rsidBoardCommentVO) {
        return mapper.insertSubComment(rsidBoardCommentVO);
    }

    @Transactional
    @Override
    public int insertBoardComment(RsidBoardCommentVO rsidBoardCommentVO) {
        return mapper.insertBoardComment(rsidBoardCommentVO);
    }

    @Transactional
    @Override
    public int deleteBoardFree(String postNo) {
        return mapper.deleteBoardFree(postNo);
    }

    @Transactional
    @Override
    public int updateBoardFree(RsidBoardVO rsidBoardVO) {
        return mapper.updateBoardFree(rsidBoardVO);
    }

    @Override
    public void updateInqCnt(String postNo) {
        mapper.updateInqCnt(postNo);
    }

    @Override
    public List<RsidBoardVO> boardFreeList(PaginationInfoVO<RsidBoardVO> pagingVO) {
        return mapper.boardFreeList(pagingVO);
    }

    @Override
    public RsidBoardVO selectOneBoardFree(RsidBoardVO rsidBoardVO) {
        return mapper.selectOneBoardFree(rsidBoardVO);
    }

    @Transactional
    public void insertBoardFree(RsidBoardVO rsidBoardVO, MultipartFile attachFile) throws IOException {

        // 파일 처리
        if (attachFile != null && !attachFile.isEmpty()) {
            String originalFilename = attachFile.getOriginalFilename();
            String uuid = UUID.randomUUID().toString().replace("-", "");
            String savedFileName = uuid + "_" + originalFilename;

            String folderPath = "board/free/" + rsidBoardVO.getWrtrId();
            String fullPath = folderPath + "/" + savedFileName;

            String googleId = googleDriveService.uploadFile(attachFile, folderPath, savedFileName);

            long seq = iAttachFileMapper.getSeqFileGroupNo();
            AttachFileVO attachFileVO = AttachFileVO.fileSettings(
                    attachFile, seq, "board_free", savedFileName, googleId, fullPath, 1
            );
            iAttachFileMapper.insertAttachFile(attachFileVO);

            rsidBoardVO.setAtchFileId(attachFileVO.getFileGroupNo() + "_" + savedFileName);
        }

        mapper.insertBoardFree(rsidBoardVO);
    }



    @Override
    public int selectBoardFreeCount(PaginationInfoVO<RsidBoardVO> pagingVO) {
        return mapper.selectBoardFreeCount(pagingVO);
    }

}
