package kr.or.ddit.common.webSocket.chat.vo;

import lombok.Data;

import java.util.Date;

@Data
public class ChatRoomVO {
    private String chatRoomNo;
    private String chatRoomNm;
    private String chatRoomTyCd;
    private String chatJoinKey;
    private Date regDt;
    private String useYn;
    private String rgtrId;
}