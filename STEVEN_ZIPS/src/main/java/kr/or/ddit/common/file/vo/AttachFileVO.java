package kr.or.ddit.common.file.vo;

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
    private long fileGroupNo;
    private String cat;
    private String fileSaveUuid;
    private String fileOgName;
    private String filePath;
    private String fileExt;
    private long fileSize;
    private String mimeType;
    private Date regDt;
    private Date mdfDt;
    private int fileSortOrder;
    private int downCnt;
    private String googleId;

    public static AttachFileVO from(MultipartFile file, long fileGroupNo, String cat, String uuid,
                                    String googleId, String path, int fileSortOrder) {
        String originalFilename = file.getOriginalFilename();
        String ext = "";
        if (originalFilename != null && originalFilename.contains(".")) {
            ext = originalFilename.substring(originalFilename.lastIndexOf(".") + 1);
        }

        return AttachFileVO.builder()
                .fileGroupNo(fileGroupNo)
                .cat(cat)
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
