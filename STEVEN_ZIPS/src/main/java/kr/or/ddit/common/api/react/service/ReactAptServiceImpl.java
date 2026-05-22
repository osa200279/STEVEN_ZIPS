package kr.or.ddit.common.api.react.service;

import kr.or.ddit.common.api.google.service.GoogleDriveService;
import kr.or.ddit.common.api.react.mapper.IReactAptMapper;
import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
public class ReactAptServiceImpl implements IReactAptService {

    @Autowired
    private IReactAptMapper reactAptMapper;

    @Autowired
    private GoogleDriveService googleDriveService;

    @Override
    public Map<String, Object> searchApartment(
            String keyword
            , int page
            , int size
    ) {
        int startRow = (page - 1) * size;
        List<AptComplexVO> content = reactAptMapper.searchApartment(
                keyword,
                startRow,
                size
        );

        int totalCount = reactAptMapper.countApartment(
                keyword
        );

        boolean hasNext = totalCount > (page * size);

        Map<String, Object> result = new HashMap<>();

        result.put(
                "content",
                content
        );

        result.put(
                "page",
                page
        );

        result.put(
                "size",
                size
        );

        result.put(
                "totalCount",
                totalCount
        );

        result.put(
                "hasNext",
                hasNext
        );

        return result;
    }

    @Override
    public List<Map<String, Object>> getDongList(String aptCmplexNo) {
        return reactAptMapper.getDongList(aptCmplexNo);
    }

    @Override
    public List<Map<String, Object>> getHoList(String aptCmplexNo, String dongNo) {
        return reactAptMapper.getHoList(aptCmplexNo, dongNo);
    }

    @Override
    public Map<String, Object>
    getRentListingDetail(String hoNo) {
        return reactAptMapper.getRentListingDetail(hoNo);
    }

    @Override
    public List<Map<String, Object>>
    getRequiredDocs(String rentLstgNo) {
        return reactAptMapper.getRequiredDocs(rentLstgNo);
    }

    @Override
    @Transactional
    public void assignResident(
            Map<String, String> param,
            List<MultipartFile> files,
            List<String> fileTypes
    ) {

        // 계약 생성
/*        reactAptMapper.insertRentContract(

        );*/

        // 계약 생성용 데이터


        /*for (int i = 0; i < files.size(); i++) {
            MultipartFile file = files.get(i);
            String fileType = fileTypes.get(i);
            String cat = resolveCategory(fileType);
            String fileSaveUuid = UUID.randomUUID()
                            .toString()
                            .replaceAll("-", "")
                            + "_"
                            + file.getOriginalFilename();

            String savePath =
                    uploadPath + "/" + fileSaveUuid;

            try {

                String googleId =
                        googleDriveService.uploadFile(
                                file,
                                uploadPath,
                                fileSaveUuid
                        );

                AttachFileVO attachFileVO =
                        AttachFileVO.fileSettings(

                                file,
                                fileGroupNo,

                                cat,

                                fileSaveUuid,

                                googleId,

                                savePath,

                                sortOrder++
                        );

                attachFileService.insertAttachFile(
                        attachFileVO
                );

            } catch (IOException e) {

                throw new RuntimeException(e);
            }
        }

        // 제출서류 처리
        if (
                files != null
                        && !files.isEmpty()
        ) {

            for (int i = 0;
                 i < files.size();
                 i++) {

                MultipartFile file =
                        files.get(i);

                String fileType =
                        fileTypes.get(i);

                // attach file service 저장

                Long fileGroupNo = 1L;

                Map<String, Object> docParam =
                        new HashMap<>();

                docParam.put(
                        "sbmsnDocTyCd",
                        fileType
                );

                docParam.put(
                        "fileGroupNo",
                        fileGroupNo
                );

                docParam.put(
                        "rentLstgNo",
                        param.get("rentListingNo")
                );

                reactAptMapper.insertSubmissionDoc(
                        docParam
                );
            }
        }

        // 매물 상태 변경
        reactAptMapper.updateRentListingStatus(
                param.get("rentListingNo")
        );

        // 호 상태 변경
        reactAptMapper.updateHoStatus(
                param.get("hoNo")
        );
    }

    private String resolveCategory(
            String fileType
    ) {

        switch (fileType) {

            case "ID":
                return "residentId";

            case "FAMILY":
                return "familyDoc";

            case "RESIDENCE":
                return "residenceDoc";

            case "CONTRACT":
                return "contractDoc";

            case "INCOME":
                return "incomeDoc";

            case "EMPLOY":
                return "employDoc";

            default:
                return "etc";
        }*/
    }
}
