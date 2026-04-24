package kr.or.ddit.domain.ApiApartment.vo;

import lombok.Data;

@Data
public class AptListResponseWrapper {
    private Header header;
    private AptListBody body;
}