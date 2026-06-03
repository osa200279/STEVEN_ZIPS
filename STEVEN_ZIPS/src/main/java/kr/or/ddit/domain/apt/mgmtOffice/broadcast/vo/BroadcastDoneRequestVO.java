package kr.or.ddit.domain.apt.mgmtOffice.broadcast.vo;

import lombok.Data;

@Data
public class BroadcastDoneRequestVO {
    private String broadcastId;
    private String mgmtOfcNo;
    private String dongNo;
    private String dongLabel;
    private String senderUserNo;
    /** DONE | FAILED */
    private String status;
}
