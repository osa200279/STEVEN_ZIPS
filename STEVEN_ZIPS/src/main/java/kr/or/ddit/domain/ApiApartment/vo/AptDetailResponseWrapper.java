package kr.or.ddit.domain.ApiApartment.vo;

import lombok.Data;

@Data
public class AptDetailResponseWrapper {
    private Header header;
    private AptDetailBody body;
}
