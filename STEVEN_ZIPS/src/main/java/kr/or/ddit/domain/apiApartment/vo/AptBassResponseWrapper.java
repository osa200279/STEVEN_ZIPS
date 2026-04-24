package kr.or.ddit.domain.apiApartment.vo;

import lombok.Data;

@Data
public class AptBassResponseWrapper {
    private Header header;
    private AptBassBody body;
}
