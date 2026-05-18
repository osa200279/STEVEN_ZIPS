package kr.or.ddit.domain.apt.mgmtOffice.board.service;

import kr.or.ddit.domain.apt.mgmtOffice.board.dto.MngrRegidentNoticeDTO;
import kr.or.ddit.domain.apt.mgmtOffice.board.mapper.ImngrRegidentNoticeMapper;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class MngrRegidentNoticeServiceImpl implements IMngrRegidentNoticeService {

    private final ImngrRegidentNoticeMapper mapper;

    @Value("${file.upload.path:C:/upload/notice}")
    private String uploadPath;

    @Override
    public int selectNoticeCount(MngrRegidentNoticeDTO dto) {
        return mapper.selectNoticeCount(dto);
    }

    @Override
    public List<MngrRegidentNoticeDTO> selectNoticeList(MngrRegidentNoticeDTO dto) {
        return mapper.selectNoticeList(dto);
    }

    @Override
    public MngrRegidentNoticeDTO selectNoticeDetail(MngrRegidentNoticeDTO dto) {
        return mapper.selectNoticeDetail(dto);
    }

    @Override
    @Transactional
    public int insertNotice(MngrRegidentNoticeDTO dto, MultipartFile uploadFile) throws Exception {

        if (dto.getTopFixYn() == null) {
            dto.setTopFixYn("N");
        }

        if (uploadFile != null && !uploadFile.isEmpty()) {

            int fileGroupNo = mapper.selectAttachFileGroupNo();

            String originalName = uploadFile.getOriginalFilename();
            String uuid = UUID.randomUUID().toString();

            String ext = "";
            if (originalName != null && originalName.lastIndexOf(".") > -1) {
                ext = originalName.substring(originalName.lastIndexOf(".") + 1);
            }

            File dir = new File(uploadPath);
            if (!dir.exists()) {
                dir.mkdirs();
            }

            String saveFileName = uuid + "." + ext;
            File saveFile = new File(dir, saveFileName);

            uploadFile.transferTo(saveFile);

            MngrRegidentNoticeDTO fileDTO = new MngrRegidentNoticeDTO();
            fileDTO.setAtchFileId(String.valueOf(fileGroupNo));
            fileDTO.setFileOgName(originalName);
            fileDTO.setFileSaveUuid(uuid);
            fileDTO.setFilePath(uploadPath);
            fileDTO.setFileExt(ext);
            fileDTO.setFileSize(uploadFile.getSize());
            fileDTO.setMimeType(uploadFile.getContentType());

            mapper.insertAttachFile(fileDTO);

            dto.setAtchFileId(String.valueOf(fileGroupNo));
        }

        return mapper.insertNotice(dto);
    }

    @Override
    public int updateNotice(MngrRegidentNoticeDTO dto) {
        if (dto.getTopFixYn() == null) {
            dto.setTopFixYn("N");
        }

        return mapper.updateNotice(dto);
    }

    @Override
    public int deleteNotice(MngrRegidentNoticeDTO dto) {
        return mapper.deleteNotice(dto);
    }

    @Override
    public void addManagerViewModel(Model model, CustomUser customUser, String mgmtOfcNo) {

        String aptCmplexNo = mapper.selectAptCmplexNoByMgmtOfcNo(mgmtOfcNo);
        String boardNo = mapper.selectNoticeBoardNoByAptCmplexNo(aptCmplexNo);

        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        model.addAttribute("aptCmplexNo", aptCmplexNo);
        model.addAttribute("boardNo", boardNo);
        model.addAttribute("loginUserId", customUser.getMember().getUserId());
    }

    @Override
    public void setManagerNoticeBaseInfo(
            MngrRegidentNoticeDTO dto,
            CustomUser customUser,
            String mgmtOfcNo
    ) {
        String aptCmplexNo = mapper.selectAptCmplexNoByMgmtOfcNo(mgmtOfcNo);
        String boardNo = mapper.selectNoticeBoardNoByAptCmplexNo(aptCmplexNo);

        /*
         * boardNo
         * → 현재 단지의 공지사항 게시판 번호.
         * null이면 insert는 되더라도 목록 조회 조건과 맞지 않아 화면에 안 나올 수 있음.
         */
        if (boardNo == null || boardNo.isBlank()) {
            throw new IllegalStateException("공지사항 게시판 번호가 없습니다. APT_BOARD_INSTANCE 데이터를 확인하세요.");
        }

        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("aptCmplexNo", aptCmplexNo);
        paramMap.put("userNo", customUser.getMember().getUserNo());

        String writerName = mapper.selectNoticeWriterName(paramMap);

        dto.setAptCmplexNo(aptCmplexNo);
        dto.setBoardNo(boardNo);
        dto.setWrtrId(writerName);
    }
}