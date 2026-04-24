package kr.or.ddit.domain.apiApartment.vo;

import lombok.Data;

@Data
public class AptListResponseWrapper {
    private Header header;
    private AptListBody body;
}