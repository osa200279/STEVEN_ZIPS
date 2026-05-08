package kr.or.ddit.domain.apt.board.free.vo;

import lombok.Data;

import java.util.Date;

@Data
public class RsidBoardCommentVO {

    private String cmtNo;
    private String postNo;
    private double cmtGroup;
    private String cmtCn;
    private double cmtSortOrd;
    private Date regDttm;
    private String delYn;
    private Date mdfDttm;
    private String userNo;
    private String userId;
}
