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
import java.util.List;
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

        dto.setAptCmplexNo(aptCmplexNo);
        dto.setBoardNo(boardNo);
        dto.setWrtrId(customUser.getMember().getUserId());
    }
}