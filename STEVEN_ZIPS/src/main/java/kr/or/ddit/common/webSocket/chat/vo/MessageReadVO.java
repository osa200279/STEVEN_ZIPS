package kr.or.ddit.common.webSocket.chat.vo;

import lombok.Data;

import java.util.Date;

@Data
public class MessageReadVO {
    private String readNo;
    private String chatMsgNo;
    private String chatMemberId;
    private Date readDttm;
}