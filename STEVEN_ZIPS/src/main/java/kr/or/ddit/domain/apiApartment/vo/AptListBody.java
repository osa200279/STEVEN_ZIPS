package kr.or.ddit.domain.apiApartment.vo;

import lombok.Data;

import java.util.List;

@Data
public class AptListBody {
    private List<AptListItem> items;
    private int numOfRows;
    private int pageNo;
    private int totalCount;
}