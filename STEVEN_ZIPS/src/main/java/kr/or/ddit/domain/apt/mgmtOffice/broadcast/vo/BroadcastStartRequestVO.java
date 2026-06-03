package kr.or.ddit.domain.apt.mgmtOffice.broadcast.vo;

import lombok.Data;

import java.util.List;

@Data
public class BroadcastStartRequestVO {
    private String mgmtOfcNo;
    private String text;
    private String languageCode;
    private String voiceName;
    private List<String> areas;
    private List<BroadcastDongTargetVO> targets;
    private String broadcastId;
}
