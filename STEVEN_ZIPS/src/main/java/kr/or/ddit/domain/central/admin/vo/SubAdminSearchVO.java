package kr.or.ddit.domain.central.admin.vo;

import lombok.Data;

/**
 * 검색 조건 VO
 * VO란?
 * → 화면/Controller/Service/Mapper 사이에서 데이터를 담아 전달하는 객체.
 */
@Data
public class SubAdminSearchVO {
    private String keyword; // 이름, 아이디, 단지명 통합 검색어
    private String status;  // wait / ok / reject / active / inactive
    private String role;    // HEAD / ACNT / ADM / FAC 또는 한글명
}
