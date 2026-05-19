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

        /*
         * 1. 공지사항 기본 정보 조회
         */
        MngrRegidentNoticeDTO detail = mapper.selectNoticeDetail(dto);

        /*
         * 2. 첨부파일이 있으면 파일 목록 조회
         */
        if (detail != null
                && detail.getAtchFileId() != null
                && !detail.getAtchFileId().isBlank()) {

            /*
             * attachFileList
             * → JSP JavaScript에서 data.attachFileList로 사용
             */
            detail.setAttachFileList(
                    mapper.selectNoticeAttachFileList(detail)
            );
        }

        return detail;
    }

    @Override
    @Transactional
    public int insertNotice(MngrRegidentNoticeDTO dto, MultipartFile[] uploadFiles) throws Exception {

        /*
         * 긴급공지 체크 안 했을 때 기본값 N
         */
        if (dto.getTopFixYn() == null) {
            dto.setTopFixYn("N");
        }

        /*
         * 첨부파일이 있을 때만 파일 업로드 처리
         */
        if (uploadFiles != null
                && uploadFiles.length > 0
                && !uploadFiles[0].isEmpty()) {

            /*
             * 파일 그룹번호 생성
             * 여러 파일을 하나의 그룹으로 묶기 위해 사용
             */
            int fileGroupNo = mapper.selectAttachFileGroupNo();

            /*
             * 여러 파일 반복 처리
             */
            for (MultipartFile uploadFile : uploadFiles) {

                /*
                 * 빈 파일은 제외
                 */
                if (uploadFile == null || uploadFile.isEmpty()) {
                    continue;
                }

                /*
                 * 원본 파일명
                 */
                String originalName = uploadFile.getOriginalFilename();

                /*
                 * UUID 생성
                 * 파일명 중복 방지용
                 */
                String uuid = UUID.randomUUID().toString().replace("-", "");

                /*
                 * 확장자 추출
                 */
                String ext = "";

                if (originalName != null
                        && originalName.lastIndexOf(".") > -1) {

                    ext = originalName.substring(
                            originalName.lastIndexOf(".") + 1
                    );
                }

                /*
                 * 저장 파일명 생성
                 */
                String saveFileName = uuid + "_" + originalName;

                /*
                 * DB 저장 경로
                 */
                String dbFilePath =
                        "apt/notice/"
                                + dto.getMgmtOfcNo()
                                + "/"
                                + saveFileName;

                /*
                 * Google Drive 업로드
                 */
                String googleId = googleDriveService.uploadFile(
                        uploadFile,
                        "apt/notice/" + dto.getMgmtOfcNo(),
                        saveFileName
                );

                /*
                 * ATTACH_FILE insert용 DTO
                 */
                MngrRegidentNoticeDTO fileDTO =
                        new MngrRegidentNoticeDTO();

                fileDTO.setAtchFileId(String.valueOf(fileGroupNo));
                fileDTO.setFileOgName(originalName);
                fileDTO.setFileSaveUuid(uuid);
                fileDTO.setFilePath(dbFilePath);
                fileDTO.setFileExt(ext);
                fileDTO.setFileSize(uploadFile.getSize());
                fileDTO.setMimeType(uploadFile.getContentType());
                fileDTO.setGoogleId(googleId);

                /*
                 * 첨부파일 DB 저장
                 */
                mapper.insertAttachFile(fileDTO);
            }

            /*
             * 공지사항과 첨부파일 그룹 연결
             */
            dto.setAtchFileId(String.valueOf(fileGroupNo));
        }

        /*
         * 11. 공지사항 insert
         */
        return mapper.insertNotice(dto);
    }

    @Override
    @Transactional
    public int updateNotice(
            MngrRegidentNoticeDTO dto,
            MultipartFile[] uploadFiles,
            String deleteAttachYn
    ) throws Exception {

        /*
         * 긴급공지 체크 안 했으면 N으로 저장
         */
        if (dto.getTopFixYn() == null) {
            dto.setTopFixYn("N");
        }

        /*
         * 1. 공지사항 제목/내용/긴급여부 수정
         */
        int result = mapper.updateNotice(dto);

        /*
         * 수정 대상이 없으면 종료
         */
        if (result <= 0) {
            return 0;
        }

        /*
         * 2. 기존 첨부파일 삭제 체크한 경우
         * → 공지사항과 기존 파일 그룹 연결만 끊음
         */
        if ("Y".equals(deleteAttachYn)) {
            dto.setAtchFileId(null);
            mapper.updateNoticeAttachFileId(dto);
        }

        /*
         * 3. 새 첨부파일이 있으면 기존 파일 그룹에 추가
         */
        if (uploadFiles != null
                && uploadFiles.length > 0
                && !uploadFiles[0].isEmpty()) {

            /*
             * 기존 공지사항 상세 조회
             * → 기존 atchFileId가 있으면 그 그룹에 추가하기 위해 필요
             */
            MngrRegidentNoticeDTO origin = mapper.selectNoticeDetail(dto);

            String fileGroupNo;

            if ("Y".equals(deleteAttachYn)
                    || origin == null
                    || origin.getAtchFileId() == null
                    || origin.getAtchFileId().isBlank()) {

                /*
                 * 기존 파일을 삭제했거나 기존 파일이 없으면 새 그룹 생성
                 */
                fileGroupNo = String.valueOf(mapper.selectAttachFileGroupNo());

                dto.setAtchFileId(fileGroupNo);
                mapper.updateNoticeAttachFileId(dto);

            } else {

                /*
                 * 기존 파일이 있으면 기존 그룹번호에 추가
                 */
                fileGroupNo = origin.getAtchFileId();
            }

            for (MultipartFile uploadFile : uploadFiles) {

                /*
                 * 빈 파일은 제외
                 */
                if (uploadFile == null || uploadFile.isEmpty()) {
                    continue;
                }

                String originalName = uploadFile.getOriginalFilename();
                String uuid = UUID.randomUUID().toString().replace("-", "");

                String ext = "";
                if (originalName != null && originalName.lastIndexOf(".") > -1) {
                    ext = originalName.substring(originalName.lastIndexOf(".") + 1);
                }

                String saveFileName = uuid + "_" + originalName;
                String dbFilePath = "apt/notice/" + dto.getMgmtOfcNo() + "/" + saveFileName;

                /*
                 * Google Drive 업로드
                 */
                String googleId = googleDriveService.uploadFile(
                        uploadFile,
                        "apt/notice/" + dto.getMgmtOfcNo(),
                        saveFileName
                );

                MngrRegidentNoticeDTO fileDTO = new MngrRegidentNoticeDTO();

                /*
                 * 기존 그룹번호 또는 새 그룹번호에 파일 저장
                 */
                fileDTO.setAtchFileId(fileGroupNo);
                fileDTO.setFileOgName(originalName);
                fileDTO.setFileSaveUuid(uuid);
                fileDTO.setFilePath(dbFilePath);
                fileDTO.setFileExt(ext);
                fileDTO.setFileSize(uploadFile.getSize());
                fileDTO.setMimeType(uploadFile.getContentType());
                fileDTO.setGoogleId(googleId);

                mapper.insertAttachFile(fileDTO);
            }
        }

        return result;
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