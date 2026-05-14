package kr.or.ddit.domain.apt.main.vo;

import lombok.Data;

/*db 테이블과 1:1 매칭되는 vo 입니다*/
@Data
public class AptDetailVO {
    private String hoNo;
    private int floor;
    private String hoTyNo;
    private String hoSttsCd;
    private String imageNo;
    private String panoImageNo;
    private String dongNo;
    private String ho;
}