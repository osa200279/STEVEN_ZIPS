package kr.or.ddit.domain.apt.mgmtOffice.broadcast.vo;

import lombok.Data;

import java.util.List;

@Data
public class BroadcastPlayMessageVO {
    private String action;
    private String mgmtOfcNo;
    private String text;
    private String languageCode;
    private String voiceName;
    private List<String> areas;
    private String targetDongNo;
    private String targetDongLabel;
    private String senderUserNo;
    private String senderUserNm;
    private long sentAt;
    private String broadcastId;
}
