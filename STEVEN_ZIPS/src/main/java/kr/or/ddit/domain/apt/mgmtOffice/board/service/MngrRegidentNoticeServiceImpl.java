package kr.or.ddit.domain.apt.mgmtOffice.board.service;

import kr.or.ddit.common.api.google.service.GoogleDriveService;
import kr.or.ddit.domain.apt.mgmtOffice.board.dto.MngrRegidentNoticeDTO;
import kr.or.ddit.domain.apt.mgmtOffice.board.mapper.ImngrRegidentNoticeMapper;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;

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

            detail.setAttachFileList(
                    mapper.selectNoticeAttachFileList(detail)
            );
        }

        return detail;
    }

    @Override
    @Transactional
    public int insertNotice(
            MngrRegidentNoticeDTO dto,
            MultipartFile[] uploadFiles
    ) throws Exception {

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

            int fileGroupNo = mapper.selectAttachFileGroupNo();

            for (MultipartFile uploadFile : uploadFiles) {

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

                String dbFilePath =
                        "apt/notice/"
                                + dto.getMgmtOfcNo()
                                + "/"
                                + saveFileName;

                String googleId = googleDriveService.uploadFile(
                        uploadFile,
                        "apt/notice/" + dto.getMgmtOfcNo(),
                        saveFileName
                );

                MngrRegidentNoticeDTO fileDTO = new MngrRegidentNoticeDTO();

                fileDTO.setAtchFileId(String.valueOf(fileGroupNo));
                fileDTO.setFileOgName(originalName);
                fileDTO.setFileSaveUuid(uuid);
                fileDTO.setFilePath(dbFilePath);
                fileDTO.setFileExt(ext);
                fileDTO.setFileSize(uploadFile.getSize());
                fileDTO.setMimeType(uploadFile.getContentType());
                fileDTO.setGoogleId(googleId);

                mapper.insertAttachFile(fileDTO);
            }

            /*
             * 공지사항과 첨부파일 그룹 연결
             */
            dto.setAtchFileId(String.valueOf(fileGroupNo));
        }

        return mapper.insertNotice(dto);
    }

    /*
     * 공지사항 수정
     *
     * deleteFileNos
     * → 수정 화면에서 삭제 선택한 기존 첨부파일 번호 목록
     */
    @Override
    @Transactional
    public int updateNotice(
            MngrRegidentNoticeDTO dto,
            MultipartFile[] uploadFiles,
            List<Integer> deleteFileNos
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

//        /*
//         * 2. 기존 첨부파일 개별 삭제
//         *
//         * deleteFileNos란?
//         * → 삭제 버튼을 누른 첨부파일 번호 목록.
//         *
//         * 왜 먼저 조회?
//         * → Google Drive 파일 ID를 알아야 실제 파일도 삭제할 수 있음.
//         */
//        if (deleteFileNos != null && !deleteFileNos.isEmpty()) {
//
//            for (Integer fileNo : deleteFileNos) {
//
//                if (fileNo == null) {
//                    continue;
//                }
//
//                /*
//                 * 삭제할 파일 정보 조회
//                 */
//                MngrRegidentNoticeDTO fileInfo =
//                        mapper.selectAttachFileDetail(fileNo);
//
//                /*
//                 * Google Drive 실제 파일 삭제
//                 */
//                if (fileInfo != null
//                        && fileInfo.getGoogleId() != null
//                        && !fileInfo.getGoogleId().isBlank()) {
//
//                    googleDriveService.deleteFile(fileInfo.getGoogleId());
//                }
//
//                /*
//                 * DB 첨부파일 삭제
//                 */
//                mapper.deleteAttachFile(fileNo);
//            }
//        }

        /*
         * 3. 새 첨부파일이 있으면 기존 파일 그룹에 추가
         */
        if (uploadFiles != null
                && uploadFiles.length > 0
                && !uploadFiles[0].isEmpty()) {

            MngrRegidentNoticeDTO origin = mapper.selectNoticeDetail(dto);

            String fileGroupNo;

            if (origin == null
                    || origin.getAtchFileId() == null
                    || origin.getAtchFileId().isBlank()) {

                fileGroupNo = String.valueOf(mapper.selectAttachFileGroupNo());

                dto.setAtchFileId(fileGroupNo);
                mapper.updateNoticeAttachFileId(dto);

            } else {
                fileGroupNo = origin.getAtchFileId();
            }

            for (MultipartFile uploadFile : uploadFiles) {

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

                String dbFilePath =
                        "apt/notice/"
                                + dto.getMgmtOfcNo()
                                + "/"
                                + saveFileName;

                String googleId = googleDriveService.uploadFile(
                        uploadFile,
                        "apt/notice/" + dto.getMgmtOfcNo(),
                        saveFileName
                );

                MngrRegidentNoticeDTO fileDTO = new MngrRegidentNoticeDTO();

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
    public void addManagerViewModel(
            Model model,
            CustomUser customUser,
            String mgmtOfcNo
    ) {

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