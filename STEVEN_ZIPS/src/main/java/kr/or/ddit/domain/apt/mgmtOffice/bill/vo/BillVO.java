package kr.or.ddit.domain.apt.mgmtOffice.bill.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

@Data
public class BillVO {
    // BILL 테이블
    private String billNo;          // 관리비번호
    private String hoNo;            // 호번호
    private String billYm;          // 관리년월 ex) 202605
    private String billPblancDt;    // 고지일자
    private Long billTotAmt;        // 관리비 총액
    private Date dueDt;             // 납부기한
    private String pymtSttsCd;      // 납부상태코드 READY, PAID, UNPAID, OVERDUE
    private Date pymtDt;            // 납부일자
    private Long pymtAmt;           // 실제 납부 금액
    private BigDecimal lateFeeRt;   // 연체요율
    private Long lateFeeAmt;        // 연체료금액
}
