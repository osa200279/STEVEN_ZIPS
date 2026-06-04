package kr.or.ddit.domain.apt.mgmtOffice.broadcast.vo;

import lombok.Data;

@Data
public class BroadcastAckMessageVO {
    private String action;
    private String broadcastId;
    private String mgmtOfcNo;
    private String targetDongNo;
    private String targetDongLabel;
    private String senderUserNo;
    /** DONE | FAILED */
    private String status;
}
