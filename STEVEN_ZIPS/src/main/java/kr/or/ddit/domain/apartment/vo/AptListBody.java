package kr.or.ddit.domain.apartment.vo;

import lombok.Data;

import java.util.List;

@Data
public class AptListBody {
    private List<AptListItemDto> items; // 리스트
    private int numOfRows;              // 한 페이지 개수
    private int pageNo;                 // 현재 페이지
    private int totalCount;             // 전체 개수
}