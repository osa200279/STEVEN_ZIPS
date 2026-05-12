package kr.or.ddit.domain.apt.apiApartment.vo;

import lombok.Data;

@Data
public class AptHoTyVO {

    // 호 타입 번호
    private String hoTyNo;
    // 아파트 단지 번호
    private String aptCmplexNo;
    // 타입명
    private String typeNm;
    // 전용면적
    private String exclusiveArea;
    // 방 개수
    private Integer roomCnt;
    // 욕실 개수
    private Integer bathroomCnt;
}