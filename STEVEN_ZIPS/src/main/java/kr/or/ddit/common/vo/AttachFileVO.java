package kr.or.ddit.common.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

import java.util.Date;


@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AttachFileVO {
    private String fileGroupId;
    private String fileNo;
    private String fileOgName;
    private String fileSaveUuid;
    private String filePath;
    private String fileExt;
    private long fileSize;
    private String mimeType;
    private Date regDt;
    private Date mdfDt;
    private int fileSortOrder;
    private int downCnt;
    private String googleId;

    public static AttachFileVO from(
            MultipartFile file, String fileGroupId, String uuid, String googleId, String path, int fileSortOrder) {
        String originalFilename = file.getOriginalFilename();
        String ext = "";
        if (originalFilename != null && originalFilename.contains(".")) {
            ext = originalFilename.substring(originalFilename.lastIndexOf(".") + 1);
        }

        return AttachFileVO.builder()
                .fileGroupId(fileGroupId)
                .fileNo(uuid)
                .fileOgName(originalFilename)
                .fileSaveUuid(uuid)
                .fileExt(ext)
                .fileSize(file.getSize())
                .mimeType(file.getContentType())
                .googleId(googleId)
                .filePath(path)
                .fileSortOrder(fileSortOrder)
                .build();
    }
}
