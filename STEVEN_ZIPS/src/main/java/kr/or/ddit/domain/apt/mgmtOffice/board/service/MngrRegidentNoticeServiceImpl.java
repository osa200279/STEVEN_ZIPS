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
import kr.or.ddit.common.api.google.service.GoogleDriveService;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class MngrRegidentNoticeServiceImpl implements IMngrRegidentNoticeService {

    private final ImngrRegidentNoticeMapper mapper;

    private final GoogleDriveService googleDriveService;

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

        /*
         * 긴급공지 체크 안 했을 때 기본값 N
         */
        if (dto.getTopFixYn() == null) {
            dto.setTopFixYn("N");
        }

        /*
         * 첨부파일이 있을 때만 파일 테이블 insert
         */
        if (uploadFile != null && !uploadFile.isEmpty()) {
            /*
             * 1. 파일 그룹 번호 생성
             */
            int fileGroupNo = mapper.selectAttachFileGroupNo();

            /*
             * 2. 원본 파일명
             */
            String originalName = uploadFile.getOriginalFilename();

            /*
             * 3. UUID 생성
             */
            String uuid = UUID.randomUUID().toString().replace("-", "");

            /*
             * 4. 확장자 추출
             */
            String ext = "";
            if (originalName != null && originalName.lastIndexOf(".") > -1) {
                ext = originalName.substring(originalName.lastIndexOf(".") + 1);
            }

            /*
             * 5. 저장 파일명 생성
             */
            String saveFileName = uuid + "_" + originalName;

            /*
             * 6. DB에 저장할 논리 경로
             */
            String dbFilePath = "apt/notice/" + dto.getMgmtOfcNo() + "/" + saveFileName;

            /*
             * 7. 구글드라이브 업로드
             * googleId
             * → 구글드라이브 파일 고유 ID.
             * 왜 필요?
             * → /file/display/{googleId}로 미리보기할 때 사용.
             */
            String googleId = googleDriveService.uploadFile(
                    uploadFile,
                    "apt/notice/" + dto.getMgmtOfcNo(),
                    saveFileName
            );

            /*
             * 8. ATTACH_FILE insert용 DTO 생성
             */
            MngrRegidentNoticeDTO fileDTO = new MngrRegidentNoticeDTO();
            fileDTO.setAtchFileId(String.valueOf(fileGroupNo));
            fileDTO.setFileOgName(originalName);
            fileDTO.setFileSaveUuid(uuid);
            fileDTO.setFilePath(dbFilePath);
            fileDTO.setFileExt(ext);
            fileDTO.setFileSize(uploadFile.getSize());
            fileDTO.setMimeType(uploadFile.getContentType());
            fileDTO.setGoogleId(googleId);

            /*
             * 9. 첨부파일 DB insert
             */
            mapper.insertAttachFile(fileDTO);

            /*
             * 10. 공지사항 테이블과 첨부파일 그룹 연결
             */
            dto.setAtchFileId(String.valueOf(fileGroupNo));
        }

        /*
         * 11. 공지사항 insert
         */
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

    @Override
    public int insertNotice(MngrRegidentNoticeDTO dto) {
        /*
         * Service
         * → Controller와 Mapper 사이에서 업무 로직을 처리하는 계층.
         *
         * 여기서는 Controller에서 받은 공지사항 DTO를 Mapper로 넘겨
         * 실제 DB insert를 실행한다.
         */
        return mapper.insertNotice(dto);
    }

}